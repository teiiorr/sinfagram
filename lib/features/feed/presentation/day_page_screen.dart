import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/social/application/social_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/board/presentation/school_board_carousel.dart';
import 'package:sinfagram/features/moderation/presentation/report_sheet.dart';
import 'package:sinfagram/features/stories/presentation/story_tray.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_banner.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/post_card.dart';
import 'package:sinfagram/shared/widgets/skeleton_block.dart';

/// S10 — the day page (docs/08). The one screen the pupil opens most: a finite,
/// chronological feed of one class-day, rendered straight in the order it comes
/// with no ranking of its own.
///
/// Chrome is a plain Instagram top bar — the wordmark on the left, a theme
/// toggle and the classmates shortcut on the right, on a white ground with a
/// single hairline under it. Below it the content scrolls: the story rail, the
/// (flat) school-board strip, then the full-bleed photo feed. No gradient hero,
/// no rounded header, no overlap.
///
/// Every one of the four [Loadable] states is still drawn in the scroll body. A
/// refresh that already has a previous day keeps that day on screen, dimmed —
/// never a spinner over content — so the page never blinks to empty between
/// reads.
class DayPageScreen extends ConsumerWidget {
  const DayPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final state = ref.watch(dayPageProvider);

    // The photo feed, per state. The story rail and board strip above it stay
    // put — only this section swaps between the four states.
    final Widget feed = switch (state) {
      // First load with nothing cached: placeholder cards, never a bare spinner.
      Loading(:final previous) => previous == null
          ? _skeletonFeed()
          : Opacity(
              opacity: 0.6,
              child: _readyFeed(context, ref, l, previous, isStale: false),
            ),
      Ready(:final value, :final isStale) =>
        _readyFeed(context, ref, l, value, isStale: isStale),
      Failed() => _errorFeed(context, ref, l),
    };

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _FeedTopBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ~104px story rail with a hairline beneath it.
                  const StoryTray(),
                  Container(height: Stroke.hairline, color: colors.border),
                  const SizedBox(height: Space.md),
                  // Flat school-board strip.
                  const SchoolBoardCarousel(),
                  const SizedBox(height: Space.md),
                  feed,
                  const SizedBox(height: Space.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Ready / stale feed ----------------------------------------------------

  Widget _readyFeed(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    DayPage day, {
    required bool isStale,
  }) {
    // Instagram home feed: media posts from people the viewer follows (plus
    // their own), newest first. Text-only posts live in Munozara.
    final photos = ref.watch(followingFeedProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isStale) ...[
          AppBanner(l.bannerOffline),
          const SizedBox(height: Space.md),
        ],
        if (photos.isEmpty)
          _hpad(EmptyState(
            icon: LucideIcons.image,
            title: l.feedPhotosEmpty,
            message: '',
          ))
        else
          ..._postWidgets(context, ref, l, photos),
      ],
    );
  }

  /// The full-bleed feed: posts span edge to edge, each carrying its own
  /// hairline, separated by whitespace. No side gutter.
  List<Widget> _postWidgets(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    List<Post> posts,
  ) {
    final saved = ref.watch(savedProvider);
    final widgets = <Widget>[];
    for (var i = 0; i < posts.length; i++) {
      final p = posts[i];
      widgets.add(Reveal(
        index: i,
        child: PostCard(
          key: ValueKey(p.id),
          authorName: p.authorName,
          timeLabel: p.timeLabel,
          body: p.body,
          hasPhoto: p.hasPhoto,
          photoPath: p.photoPath,
          videoPath: p.videoPath,
          thanksLabel: l.thanks,
          thankedByMe: p.thankedByMe,
          onThanks: () => ref.read(dayPageProvider.notifier).toggleThanks(p.id),
          likeCountLabel: l.likesCount(p.displayLikes),
          saved: saved.contains(p.id),
          onSave: () => ref.read(savedProvider.notifier).toggle(p.id),
          commentLabel: l.comments(p.commentCount),
          onComment: () => context.push('/post/${p.id}'),
          onReport: () =>
              showReportSheet(context, targetKind: 'post', targetId: p.id),
          onMore: () {},
          onRepost: () {
            final now = ref.read(dayPageProvider.notifier).toggleRepost(p.id);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(now ? l.repostDone : l.repostRemoved),
              ));
          },
          repostedByMe: p.repostedByMe,
          repostLabel: l.repost,
          heldForReview: p.heldForReview,
          waitingLabel: l.composeReview,
        ),
      ));
      if (i != posts.length - 1) {
        widgets.add(const SizedBox(height: Space.sm));
      }
    }
    return widgets;
  }

  // --- Loading & failure -----------------------------------------------------

  Widget _skeletonFeed() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonPostCard(),
          SizedBox(height: Space.sm),
          _SkeletonPostCard(),
          SizedBox(height: Space.sm),
          _SkeletonPostCard(),
        ],
      ),
    );
  }

  Widget _errorFeed(BuildContext context, WidgetRef ref, AppL10n l) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l.errorTitle,
              textAlign: TextAlign.center,
              style: AppText.h3.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Space.xs),
            Text(
              l.errorBody,
              textAlign: TextAlign.center,
              style: AppText.bodySm.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: Space.md),
            AppButton(
              l.actionRetry,
              onPressed: () => ref.invalidate(dayPageProvider),
            ),
          ],
        ),
      ),
    );
  }

  // --- Shared ----------------------------------------------------------------

  /// Applies the page gutter to a single item (empty state, etc.), leaving
  /// full-bleed items untouched.
  Widget _hpad(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        child: child,
      );
}

/// The plain Instagram top bar: wordmark left, two 24px icon buttons right
/// (theme toggle + classmates). White ground, a single hairline beneath, no
/// shadow. It is fixed chrome — the story rail and feed scroll under it.
class _FeedTopBar extends ConsumerWidget {
  const _FeedTopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.only(left: Space.gutter, right: Space.sm),
          child: Row(
            children: [
              Text(
                // Brand wordmark (proper noun — not localised copy).
                'Sinfagram',
                style: AppText.wordmark.copyWith(color: colors.textPrimary),
              ),
              const Spacer(),
              _iconButton(
                context,
                icon: LucideIcons.search,
                tooltip: l.searchTitle,
                onTap: () => context.push('/search'),
              ),
              _iconButton(
                context,
                icon: LucideIcons.heart,
                tooltip: l.activityTitle,
                onTap: () => context.push('/activity'),
              ),
              _iconButton(
                context,
                icon: LucideIcons.users,
                tooltip: l.classmatesTitle,
                onTap: () => context.push('/classmates'),
              ),
              _iconButton(
                context,
                icon: isDark ? LucideIcons.sun : LucideIcons.moon,
                tooltip: l.settingsDarkMode,
                onTap: () => ref.read(themeModeProvider.notifier).state =
                    isDark ? ThemeMode.light : ThemeMode.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A 24px icon on a 44×44 target, with tooltip + semantics (icon-only rule).
  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          onTap: onTap,
          radius: 24,
          splashColor: colors.primary.withValues(alpha: 0.06),
          highlightColor: colors.primary.withValues(alpha: 0.06),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Icon(icon, size: 24, color: colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

/// A resting placeholder shaped like a [PostCard]: an avatar dot, two header
/// lines, and a couple of body lines. Quiet by design (see [SkeletonBlock]).
class _SkeletonPostCard extends StatelessWidget {
  const _SkeletonPostCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SkeletonBlock(width: 36, height: 36, radius: Radii.avatar),
              SizedBox(width: Space.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonBlock(width: 128, height: 12),
                    SizedBox(height: Space.xs),
                    SkeletonBlock(width: 72, height: 10),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Space.md),
          SkeletonBlock(height: 12),
          SizedBox(height: Space.sm),
          SkeletonBlock(width: 220, height: 12),
        ],
      ),
    );
  }
}
