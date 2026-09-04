import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/accounts/application/accounts_controller.dart';
import 'package:sinfagram/features/people/application/people_controllers.dart';
import 'package:sinfagram/features/social/application/social_controller.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// Search / Explore — find people in the class (and the mock accounts) and
/// follow them. A flat grey search field filters a single flat list of people by
/// name as you type; each row carries a Follow / Following toggle and, for a
/// known classmate, opens their profile on tap. Instagram-quiet: no cards, no
/// shadows, no gradients — just faces, names and one blue action.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value);
  }

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
  }

  /// The class roster merged with the mock accounts, deduped by name (a
  /// classmate wins over an equally-named account so tapping still routes to a
  /// profile). Secondary line is "now reading" when present, otherwise the class.
  List<_SearchEntry> _entries() {
    final people = ref.watch(classmatesProvider);
    final accounts = ref.watch(accountsProvider);

    final out = <_SearchEntry>[];
    final seen = <String>{};

    for (final p in people) {
      if (!seen.add(p.name)) continue;
      out.add(_SearchEntry(
        name: p.name,
        secondary: p.reading.isNotEmpty ? p.reading : p.className,
        personId: p.id,
      ));
    }
    for (final a in accounts) {
      if (!seen.add(a.displayName)) continue;
      out.add(_SearchEntry(
        name: a.displayName,
        secondary: a.reading.isNotEmpty ? a.reading : a.classLabel,
        personId: null,
      ));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? _entries()
        : _entries()
            .where((e) => e.name.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.searchTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.gutter,
                Space.md,
                Space.gutter,
                Space.sm,
              ),
              child: _SearchField(
                controller: _controller,
                hint: l.searchHint,
                onChanged: _onChanged,
                onClear: _query.isEmpty ? null : _clear,
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.search,
                      title: l.searchEmpty,
                      message: '',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: Space.xl),
                      itemCount: results.length,
                      itemBuilder: (context, i) =>
                          _PersonRow(entry: results[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The flat search input: a grey rounded pill (no card, no blue focus ring) with
/// a leading magnifier and a clear affordance once text is entered. Grey cursor,
/// borderless — the fill alone signals the field.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      decoration: BoxDecoration(
        color: colors.skeleton,
        borderRadius: BorderRadius.circular(Radii.control),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, size: 18, color: colors.textSecondary),
          const SizedBox(width: Space.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              cursorColor: colors.textSecondary,
              style: AppText.body.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hint,
                hintStyle:
                    AppText.body.copyWith(color: colors.textTertiary),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: Space.sm + 2),
              ),
            ),
          ),
          if (onClear != null)
            TapScale(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(left: Space.sm),
                child: Icon(LucideIcons.x,
                    size: 18, color: colors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

/// One person row: a 44 px avatar, name over a secondary line, and a Follow /
/// Following toggle on the right. The name area dims on press and opens the
/// profile (classmates only); the button lives outside that tap target so
/// following never navigates. Flat — no card, no divider chrome.
class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.entry});

  final _SearchEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canOpen = entry.personId != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.gutter,
        vertical: Space.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: TapScale(
              onTap: canOpen
                  ? () => context.push('/person/${entry.personId}')
                  : null,
              child: Row(
                children: [
                  Avatar(name: entry.name, size: 44),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodyStrong
                              .copyWith(color: colors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.secondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySm
                              .copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Space.md),
          _FollowButton(name: entry.name),
        ],
      ),
    );
  }
}

/// The Follow toggle for one person. Watches [followsProvider] so it flips
/// between a solid blue "Kuzatish" (follow) and a grey "Kuzatilmoqda"
/// (following) the instant it is tapped.
class _FollowButton extends ConsumerWidget {
  const _FollowButton({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final isFollowing = ref.watch(followsProvider).contains(name);

    return AppButton(
      isFollowing ? l.following : l.follow,
      variant:
          isFollowing ? AppButtonVariant.secondary : AppButtonVariant.primary,
      onPressed: () => ref.read(followsProvider.notifier).toggle(name),
    );
  }
}

/// A flat search row model: a display name, a secondary line, and the profile id
/// to route to (null for a mock account that has no classmate profile).
class _SearchEntry {
  const _SearchEntry({
    required this.name,
    required this.secondary,
    required this.personId,
  });

  final String name;
  final String secondary;
  final String? personId;
}
