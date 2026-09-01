import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/localization/l10n/app_l10n.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/app_bottom_sheet.dart';
import '../../shared/widgets/app_button.dart';

/// Pupil shell — Instagram-style bottom navigation:
/// Lenta · Munozara · ➕ (create) · Oʻyinlar · Profil.
///
/// The centre "create" is an action, not a branch, so nav-slot indices map onto
/// the four [StatefulNavigationShell] branches with the create slot skipped.
class PupilShell extends StatelessWidget {
  const PupilShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // nav slot → branch index (slot 2 is the create action, no branch).
  static const _navToBranch = {0: 0, 1: 1, 3: 2, 4: 3};
  // branch index → nav slot.
  static const _branchToNav = {0: 0, 1: 1, 2: 3, 3: 4};
  static const _createSlot = 2;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _branchToNav[navigationShell.currentIndex] ?? 0,
        onTap: (slot) {
          if (slot == _createSlot) {
            _openCreate(context, l);
            return;
          }
          final branch = _navToBranch[slot]!;
          navigationShell.goBranch(branch,
              initialLocation: branch == navigationShell.currentIndex);
        },
        items: [
          AppNavItem(icon: LucideIcons.house, label: l.navFeed),
          AppNavItem(icon: LucideIcons.messagesSquare, label: l.navMunozara),
          AppNavItem(
              icon: LucideIcons.plus, label: l.navCreate, isAction: true),
          AppNavItem(icon: LucideIcons.swords, label: l.navGames),
          AppNavItem(icon: LucideIcons.user, label: l.navProfile),
        ],
      ),
    );
  }

  /// The create chooser: a photo/video post (→ Lenta) or a text discussion
  /// (→ Munozara). Both open the composer in the matching mode.
  Future<void> _openCreate(BuildContext context, AppL10n l) async {
    await showAppBottomSheet<void>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            l.createPhoto,
            icon: LucideIcons.image,
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/compose?mode=photo');
            },
          ),
          const SizedBox(height: Space.sm),
          AppButton(
            l.createText,
            variant: AppButtonVariant.secondary,
            icon: LucideIcons.penLine,
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/compose?mode=text');
            },
          ),
          const SizedBox(height: Space.sm),
        ],
      ),
    );
  }
}
