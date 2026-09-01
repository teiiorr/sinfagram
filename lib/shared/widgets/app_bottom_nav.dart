import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

class AppNavItem {
  const AppNavItem(
      {required this.icon, required this.label, this.isAction = false});
  final IconData icon;
  final String label;

  /// An action item (the centre "Create" FAB) renders as a prominent gradient
  /// rounded-square and never shows the sliding selection blob.
  final bool isAction;
}

/// Floating bottom navigation ("Play" redesign): a rounded, elevated bar that
/// floats above the content, an animated `primarySubtle` blob that slides
/// between tabs, and a gradient rounded-square create FAB. Labels always
/// visible; a single dot (never a number) marks [dotIndex].
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.dotIndex,
  });

  final int currentIndex;
  final List<AppNavItem> items;
  final ValueChanged<int> onTap;
  final int? dotIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
        child: RepaintBoundary(
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(Radii.nav),
              border:
                  Border.all(color: colors.border, width: Stroke.hairline),
              boxShadow: Shadows.soft,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                const inset = 10.0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Sliding blob behind the active tab.
                    AnimatedPositioned(
                      duration: motionOf(context, Motion.slow),
                      curve: Motion.spring,
                      left: itemWidth * currentIndex + inset,
                      top: 9,
                      width: itemWidth - inset * 2,
                      height: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primarySubtle,
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          Expanded(
                            child: _NavItem(
                              item: items[i],
                              selected: i == currentIndex,
                              dot: i == dotIndex,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onTap(i);
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.item,
      required this.selected,
      required this.onTap,
      this.dot = false});

  final AppNavItem item;
  final bool selected;
  final bool dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // The centre "Create" FAB: a gradient rounded-square, tilted, glowing.
    if (item.isAction) {
      return Semantics(
        button: true,
        label: item.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: Transform.rotate(
              angle: -0.105, // ~ -6°
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(Radii.fab),
                  boxShadow: Shadows.lift,
                ),
                child: Transform.rotate(
                  angle: 0.105,
                  child: const Icon(LucideIcons.plus,
                      size: 26, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final color = selected ? colors.primary : colors.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: selected ? 1.15 : 1.0,
                  duration: motionOf(context, Motion.base),
                  curve: Motion.spring,
                  child: Icon(item.icon, size: 24, color: color),
                ),
                if (dot)
                  Positioned(
                    right: -3,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.danger,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: motionOf(context, Motion.fast),
              style: AppText.label.copyWith(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600),
              child: Text(item.label,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
