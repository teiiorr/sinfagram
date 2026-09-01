import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/people/application/people_controllers.dart';
import 'package:sinfagram/features/people/domain/person.dart';
import 'package:sinfagram/features/stories/application/stories_controller.dart';
import 'package:sinfagram/features/stories/domain/story.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S40 — Me. The signed-in pupil's own profile, styled like Instagram but
/// deliberately **count-less** (product-owner direction, docs/12): no
/// follower/post/like tallies anywhere. A large avatar + name + class, an
/// editable "About me" bio, the viewer's story highlights, and a 3-tab grid of
/// their own posts / reposts / a jump into the class chronicle.
///
/// The profile lives in [myProfileProvider] and is the one profile the pupil
/// owns and can change. Everything here is scoped to the session.
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final s = ref.watch(sessionProvider);
    final me = ref.watch(myProfileProvider);

    final name = s?.displayName ?? '';
    final classLabel = s?.classLabel ?? '';

    // The viewer's own media posts (by author == their display name) and reposts.
    final myPosts = ref
        .watch(feedPhotoPostsProvider)
        .where((p) => p.authorName == name)
        .toList();
    final reposts = ref.watch(repostedPostsProvider);

    // The viewer's own story slides drive the highlights row.
    final mine = ref.watch(storiesProvider).where((st) => st.isMine).toList();
    final slides = mine.isEmpty ? const <StorySlide>[] : mine.first.slides;

    final tabBar = _ProfileTabBar(colors: colors, l: l);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          title: Text(name),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.menu),
              onPressed: () => showAppBottomSheet<void>(
                context: context,
                child: const _MenuSheet(),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: _ProfileHeader(
                  name: name,
                  classLabel: classLabel,
                  me: me,
                  slides: slides,
                  onEdit: () => _openEditor(context, ref, me, l),
                  onOpenStories: () => context.push('/stories/0'),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: tabBar,
                  background: colors.bg,
                  border: colors.border,
                ),
              ),
            ],
            body: TabBarView(
              children: [
                _MediaGrid(
                  posts: myPosts,
                  emptyIcon: LucideIcons.image,
                  emptyTitle: l.profileNoPosts,
                  storageKey: 'me.posts',
                ),
                _MediaGrid(
                  posts: reposts,
                  emptyIcon: LucideIcons.repeat2,
                  emptyTitle: l.profileNoReposts,
                  storageKey: 'me.reposts',
                ),
                const _ChronicleTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditor(
      BuildContext context, WidgetRef ref, Person me, AppL10n l) async {
    final saved = await showAppBottomSheet<bool>(
      context: context,
      child: _AboutEditor(initial: me),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.meEditSaved)));
    }
  }
}

/// The Instagram-style identity block: a large ringed avatar beside the name and
/// class, the "About me" bio (with reading / listening / interests), a full-width
/// "Edit profile" button, and the story highlights row. No numeric counters.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.classLabel,
    required this.me,
    required this.slides,
    required this.onEdit,
    required this.onOpenStories,
  });

  final String name;
  final String classLabel;
  final Person me;
  final List<StorySlide> slides;
  final VoidCallback onEdit;
  final VoidCallback onOpenStories;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.lg, Space.gutter, Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identity row: ringed avatar + name/class. No stats, by design.
          Row(
            children: [
              _RingedAvatar(name: name),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name,
                        style: AppText.h1.copyWith(color: colors.textPrimary)),
                    if (classLabel.isNotEmpty) ...[
                      const SizedBox(height: Space.xs),
                      Text(classLabel,
                          style: AppText.bodySm
                              .copyWith(color: colors.textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.lg),

          // Bio — the free-text line, soft when empty.
          Text(
            me.bio.isEmpty ? l.meEmpty : me.bio,
            style: AppText.body.copyWith(
              color: me.bio.isEmpty ? colors.textTertiary : colors.textPrimary,
            ),
          ),
          const SizedBox(height: Space.md),

          // Personality lines — small lucide icons, IG-bio style.
          _BioLine(
            icon: LucideIcons.bookOpen,
            color: AppAccents.amber,
            label: l.meReading,
            value: me.reading,
            empty: l.meEmpty,
          ),
          const SizedBox(height: Space.sm),
          _BioLine(
            icon: LucideIcons.music,
            color: AppAccents.pink,
            label: l.meListening,
            value: me.listening,
            empty: l.meEmpty,
          ),
          if (me.interests.isNotEmpty) ...[
            const SizedBox(height: Space.md),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final t in me.interests)
                  AppChip(t, variant: AppChipVariant.accent),
              ],
            ),
          ],
          const SizedBox(height: Space.lg),

          // Full-width secondary CTA — opens the editor sheet.
          SizedBox(
            width: double.infinity,
            child: AppButton(
              l.meEditProfile,
              variant: AppButtonVariant.secondary,
              onPressed: onEdit,
            ),
          ),

          // Story highlights — hidden entirely when the viewer has no slides.
          if (slides.isNotEmpty) ...[
            const SizedBox(height: Space.lg),
            _HighlightsRow(slides: slides, onTap: onOpenStories),
          ],
        ],
      ),
    );
  }
}

/// A large avatar wrapped in the brand story-ring (hero gradient).
class _RingedAvatar extends StatelessWidget {
  const _RingedAvatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.hero,
        boxShadow: Shadows.lift,
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: colors.surface),
        child: Avatar(name: name, size: 82),
      ),
    );
  }
}

/// One "icon + label + value" bio line. Shows [empty] softly when [value] is
/// blank, so the reading/listening rows never read as broken.
class _BioLine extends StatelessWidget {
  const _BioLine({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.empty,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEmpty = value.isEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          child: isEmpty
              ? Text(empty,
                  style:
                      AppText.body.copyWith(color: colors.textTertiary))
              : Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: '$label  ',
                      style: AppText.caption
                          .copyWith(color: colors.textTertiary),
                    ),
                    TextSpan(
                      text: value,
                      style:
                          AppText.body.copyWith(color: colors.textPrimary),
                    ),
                  ]),
                ),
        ),
      ],
    );
  }
}

/// Horizontal row of gradient-ring story-highlight bubbles. Every bubble opens
/// the viewer's own story.
class _HighlightsRow extends StatelessWidget {
  const _HighlightsRow({required this.slides, required this.onTap});
  final List<StorySlide> slides;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: slides.length,
        separatorBuilder: (_, __) => const SizedBox(width: Space.md),
        itemBuilder: (context, i) {
          final slide = slides[i];
          return SizedBox(
            width: 72,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppGradients.hero,
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surfaceRaised,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: Icon(LucideIcons.image,
                          size: 22, color: colors.textTertiary),
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    slide.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppText.caption.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The three icon tabs. Icon-only (no numeric labels), each carrying a screen
/// reader label for accessibility.
class _ProfileTabBar extends StatelessWidget {
  const _ProfileTabBar({required this.colors, required this.l});
  final AppColors colors;
  final AppL10n l;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: colors.textPrimary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      labelColor: colors.textPrimary,
      unselectedLabelColor: colors.textTertiary,
      dividerColor: Colors.transparent,
      tabs: [
        Tab(
          icon: Semantics(
            label: l.profileTabPosts,
            child: const Icon(LucideIcons.grid3x3),
          ),
        ),
        Tab(
          icon: Semantics(
            label: l.profileTabReposts,
            child: const Icon(LucideIcons.repeat2),
          ),
        ),
        Tab(
          icon: Semantics(
            label: l.profileTabChronicle,
            child: const Icon(LucideIcons.scrollText),
          ),
        ),
      ],
    );
  }
}

/// Pins the [tabBar] under the header while the grids scroll. Icon-only tabs
/// keep a fixed height regardless of the text-scale factor.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({
    required this.tabBar,
    required this.background,
    required this.border,
  });

  final Widget tabBar;
  final Color background;
  final Color border;

  static const double _height = 48;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(color: border, width: Stroke.hairline),
        ),
      ),
      child: SizedBox(height: _height, child: tabBar),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.background != background ||
      old.border != border ||
      old.tabBar != tabBar;
}

/// A 3-column, count-less media grid of [posts]. Edge-to-edge cells with a 2 px
/// gutter, Instagram-style. Empty → a quiet [EmptyState].
class _MediaGrid extends StatelessWidget {
  const _MediaGrid({
    required this.posts,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.storageKey,
  });

  final List<Post> posts;
  final IconData emptyIcon;
  final String emptyTitle;
  final String storageKey;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return CustomScrollView(
        key: PageStorageKey<String>(storageKey),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(icon: emptyIcon, title: emptyTitle, message: ''),
          ),
        ],
      );
    }

    return CustomScrollView(
      key: PageStorageKey<String>(storageKey),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 2, bottom: Space.xl),
          sliver: SliverGrid(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _GridCell(post: posts[i]),
              childCount: posts.length,
            ),
          ),
        ),
      ],
    );
  }
}

/// One grid cell: the real device photo when present, otherwise a deterministic
/// gradient placeholder with a faint image glyph. Tapping opens the post.
class _GridCell extends StatelessWidget {
  const _GridCell({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final hasFile = post.photoPath != null && post.photoPath!.isNotEmpty;
    final Widget content = hasFile
        ? Image.file(
            File(post.photoPath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => _placeholder(),
          )
        : _placeholder();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/post/${post.id}'),
      child: content,
    );
  }

  Widget _placeholder() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.of(AppAccents.forSeed(post.id)),
      ),
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 28,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// The Solnoma (chronicle) tab: a centered tappable tile into the class
/// chronicle. Kept scrollable so it plays nicely inside the [NestedScrollView].
class _ChronicleTab extends StatelessWidget {
  const _ChronicleTab();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    return CustomScrollView(
      key: const PageStorageKey<String>('me.chronicle'),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: AppCard(
                  onTap: () => context.push('/chronicle'),
                  padding: const EdgeInsets.all(Space.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTile(LucideIcons.scrollText,
                          color: AppAccents.violet, size: 56),
                      const SizedBox(height: Space.md),
                      Text(
                        l.profileTabChronicle,
                        textAlign: TextAlign.center,
                        style: AppText.h3.copyWith(color: colors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The overflow menu sheet: classmates, settings, about, and the danger sign-out.
class _MenuSheet extends ConsumerWidget {
  const _MenuSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.sm, Space.gutter, Space.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetRow(
            icon: LucideIcons.users,
            label: l.classmatesOpen,
            onTap: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.push('/classmates');
            },
          ),
          const SizedBox(height: Space.sm),
          _SheetRow(
            icon: LucideIcons.settings,
            label: l.meSettings,
            onTap: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.push('/settings');
            },
          ),
          const SizedBox(height: Space.sm),
          _SheetRow(
            icon: LucideIcons.info,
            label: l.meAbout,
            onTap: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.push('/about');
            },
          ),
          const SizedBox(height: Space.sm),
          _SheetRow(
            icon: LucideIcons.logOut,
            label: l.meSignOut,
            danger: true,
            onTap: () {
              final notifier = ref.read(sessionProvider.notifier);
              Navigator.of(context).pop();
              notifier.signOut();
            },
          ),
        ],
      ),
    );
  }
}

/// A tappable menu row: a colourful leading tile, a label, and a chevron.
class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelColor = danger ? colors.danger : colors.textPrimary;
    final tileColor = danger ? AppAccents.red : AppAccents.forSeed(label);

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 28),
          child: Row(
            children: [
              IconTile(icon, color: tileColor, size: 44),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(label,
                    style: AppText.body.copyWith(color: labelColor)),
              ),
              const SizedBox(width: Space.md),
              Icon(LucideIcons.chevronRight,
                  size: 20, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom-sheet editor for "About me". Local controllers; commits to
/// [myProfileProvider] on save and pops `true`. Interests split on commas.
class _AboutEditor extends ConsumerStatefulWidget {
  const _AboutEditor({required this.initial});
  final Person initial;

  @override
  ConsumerState<_AboutEditor> createState() => _AboutEditorState();
}

class _AboutEditorState extends ConsumerState<_AboutEditor> {
  late final TextEditingController _bio =
      TextEditingController(text: widget.initial.bio);
  late final TextEditingController _reading =
      TextEditingController(text: widget.initial.reading);
  late final TextEditingController _listening =
      TextEditingController(text: widget.initial.listening);
  late final TextEditingController _interests =
      TextEditingController(text: widget.initial.interests.join(', '));

  @override
  void dispose() {
    _bio.dispose();
    _reading.dispose();
    _listening.dispose();
    _interests.dispose();
    super.dispose();
  }

  void _save() {
    final c = ref.read(myProfileProvider.notifier);
    c.setBio(_bio.text);
    c.setReading(_reading.text);
    c.setListening(_listening.text);
    c.setInterests(
      _interests.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, 0, Space.gutter, Space.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.meEditProfile,
              style: AppText.h2.copyWith(color: colors.textPrimary)),
          const SizedBox(height: Space.lg),
          AppTextField(
            controller: _bio,
            label: l.meBio,
            hint: l.meBioHint,
            maxLines: 3,
            maxLength: 160,
          ),
          const SizedBox(height: Space.md),
          AppTextField(
            controller: _reading,
            label: l.meReading,
            hint: l.meReadingHint,
            maxLength: 80,
          ),
          const SizedBox(height: Space.md),
          AppTextField(
            controller: _listening,
            label: l.meListening,
            hint: l.meListeningHint,
            maxLength: 80,
          ),
          const SizedBox(height: Space.md),
          AppTextField(
            controller: _interests,
            label: l.meInterests,
            maxLength: 120,
          ),
          const SizedBox(height: Space.lg),
          AppButton(l.meSave, onPressed: _save),
          const SizedBox(height: Space.sm),
        ],
      ),
    );
  }
}
