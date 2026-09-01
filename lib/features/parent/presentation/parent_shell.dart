import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/localization/l10n/app_l10n.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

/// Parent shell — 3 tabs (docs/07 §7.10) on the shared animated nav. No badges,
/// no live feed.
class ParentShell extends StatelessWidget {
  const ParentShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(i,
            initialLocation: i == navigationShell.currentIndex),
        items: [
          AppNavItem(icon: LucideIcons.graduationCap, label: l.pNavChild),
          AppNavItem(icon: LucideIcons.messageCircle, label: l.pNavMessages),
          AppNavItem(icon: LucideIcons.user, label: l.navMe),
        ],
      ),
    );
  }
}
