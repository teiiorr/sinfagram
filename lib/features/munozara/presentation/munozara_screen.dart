import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/moderation/presentation/report_sheet.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/post_card.dart';

/// Munozara — the discussions tab (docs/05). A Threads/Instagram-style feed of
/// text-only posts: each carries like (thanks), reply and repost. Media posts
/// live in Lenta; anything without media surfaces here.
///
/// The reply screen is the shared post detail at `/post/:id`; the composer opens
/// in text mode at `/compose?mode=text`.
class MunozaraScreen extends ConsumerWidget {
  const MunozaraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final posts = ref.watch(munozaraPostsProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(l.munozaraTitle),
        actions: [
          // Compose a new text post. Icon-only top-bar action (Instagram-style,
          // black chrome icon), 24px glyph on a 48px IconButton tap target.
          IconButton(
            tooltip: l.munozaraNew,
            icon: const Icon(LucideIcons.plus, size: 24),
            color: colors.textPrimary,
            onPressed: () => context.push('/compose?mode=text'),
          ),
          const SizedBox(width: Space.xs),
        ],
      ),
      body: SafeArea(
        child: posts.isEmpty
            ? EmptyState(
                icon: LucideIcons.messagesSquare,
                title: l.munozaraEmpty,
                message: '',
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.md,
                  Space.gutter,
                  Space.xxl,
                ),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
                itemBuilder: (context, i) {
                  final p = posts[i];
                  return Reveal(
                    index: i,
                    child: _postCard(context, ref, l, p),
                  );
                },
              ),
      ),
    );
  }

  Widget _postCard(BuildContext context, WidgetRef ref, AppL10n l, Post p) {
    return PostCard(
      key: ValueKey(p.id),
      authorName: p.authorName,
      timeLabel: p.timeLabel,
      body: p.body,
      hasPhoto: false,
      thanksLabel: l.thanks,
      thankedByMe: p.thankedByMe,
      onThanks: () => ref.read(dayPageProvider.notifier).toggleThanks(p.id),
      commentLabel: l.comments(p.commentCount),
      onComment: () => context.push('/post/${p.id}'),
      onReport: () =>
          showReportSheet(context, targetKind: 'post', targetId: p.id),
      onMore: () {},
      onRepost: () {
        final now = ref.read(dayPageProvider.notifier).toggleRepost(p.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(now ? l.repostDone : l.repostRemoved)),
          );
      },
      repostedByMe: p.repostedByMe,
      repostLabel: l.repost,
    );
  }
}
