import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S05 — pick your own name off the class roster.
///
/// The roster is a fixed, already-sorted list of the unclaimed names in the
/// class the pupil joined at S04. Tapping a name opens a confirm sheet
/// ("is this you?"); confirming claims the name and advances to PIN set-up.
///
/// Stateful because it owns the confirm-sheet flow and is the natural home for a
/// search field once a roster grows past ~20 names. Today the roster is 10, so
/// the whole list fits on screen and the search field is intentionally omitted.
class JoinRosterScreen extends ConsumerStatefulWidget {
  const JoinRosterScreen({super.key});

  @override
  ConsumerState<JoinRosterScreen> createState() => _JoinRosterScreenState();
}

class _JoinRosterScreenState extends ConsumerState<JoinRosterScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    // A stable, pre-sorted constant on the controller — read, not watch: it does
    // not change while this screen is alive.
    final roster = ref.read(sessionProvider.notifier).roster;

    return Scaffold(
      appBar: AppBar(title: Text(l.rosterTitle)),
      body: roster.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(Space.gutter),
              child: EmptyState(
                icon: LucideIcons.users,
                title: l.emptyTitle,
                message: l.emptyBody,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                Space.gutter,
                Space.md,
                Space.gutter,
                Space.xxl,
              ),
              itemCount: roster.length,
              separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
              itemBuilder: (context, index) {
                final name = roster[index];
                return _RosterTile(
                  name: name,
                  onTap: () => _openConfirm(name),
                );
              },
            ),
    );
  }

  /// Confirm sheet: who this name belongs to, their class, and the single
  /// primary action. Runs on the screen's own context (not the sheet builder's)
  /// so [_confirm] can still navigate after the sheet route is popped.
  void _openConfirm(String name) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final classLabel = ref.read(sessionProvider.notifier).classLabel;

    showAppBottomSheet<void>(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(Space.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Avatar(name: name, size: Space.xxl)),
            const SizedBox(height: Space.md),
            Text(
              l.rosterConfirmTitle,
              style: AppText.h2.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Space.xs),
            Text(
              name,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Space.xs),
            Text(
              classLabel,
              style: AppText.bodySm.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: Space.lg),
            AppButton(
              l.actionContinue,
              size: AppButtonSize.lg,
              onPressed: () => _confirm(name),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(String name) {
    ref.read(sessionProvider.notifier).claimRoster(name);
    Navigator.of(context).pop(); // close the confirm sheet first
    context.go('/join/pin');
  }
}

/// One tappable roster row: an initials avatar, the name, and a quiet chevron.
class _RosterTile extends StatelessWidget {
  const _RosterTile({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // The name is already carried by the Text beside it; drop the avatar's
          // own name label so the row is announced once, not twice.
          ExcludeSemantics(child: Avatar(name: name)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              name,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(width: Space.sm),
          Icon(
            LucideIcons.chevronRight,
            size: Space.md,
            color: colors.textTertiary,
          ),
        ],
      ),
    );
  }
}
