import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/localization/l10n/app_l10n.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../application/teacher_controllers.dart';

/// Teacher shell — 4 tabs (docs/07 §7.9). A single dot on the cases tab when the
/// inbox has open work.
class TeacherShell extends ConsumerWidget {
  const TeacherShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final openCases = ref.watch(openCaseCountProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        dotIndex: openCases > 0 ? 1 : null,
        onTap: (i) => navigationShell.goBranch(i,
            initialLocation: i == navigationShell.currentIndex),
        items: [
          AppNavItem(
              icon: Icons.people_outline,
              activeIcon: Icons.people,
              label: l.tNavClasses),
          AppNavItem(
              icon: Icons.flag_outlined,
              activeIcon: Icons.flag,
              label: l.tNavCases),
          AppNavItem(
              icon: Icons.sports_esports_outlined,
              activeIcon: Icons.sports_esports,
              label: l.navGames),
          AppNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: l.navMe),
        ],
      ),
    );
  }
}
