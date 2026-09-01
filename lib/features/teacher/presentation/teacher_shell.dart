import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          AppNavItem(icon: LucideIcons.users, label: l.tNavClasses),
          AppNavItem(icon: LucideIcons.flag, label: l.tNavCases),
          AppNavItem(icon: LucideIcons.swords, label: l.navGames),
          AppNavItem(icon: LucideIcons.user, label: l.navMe),
        ],
      ),
    );
  }
}
