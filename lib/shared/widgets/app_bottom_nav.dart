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

  /// An action item (e.g. the centre "Create" button) renders as a prominent
  /// filled circle and never shows the sliding selection pill.
  final bool isAction;
}

/// Shared bottom navigation with an animated indicator pill that slides between
/// tabs and an icon that scales on selection (DECISIONS.md — elevated motion).
/// Labels always visible; a single dot (never a number) marks [dotIndex].
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
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
              top: BorderSide(color: colors.border, width: Stroke.hairline)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                return Stack(
                  children: [
                    // Sliding indicator pill behind the active item.
                    AnimatedPositioned(
                      duration: motionOf(context, Motion.base),
                      curve: Motion.emphasize,
                      left: itemWidth * currentIndex + Space.md,
                      top: 8,
                      width: itemWidth - Space.md * 2,
                      height: 44,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primarySubtle,
                          borderRadius: BorderRadius.circular(Radii.control),
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

    // The centre "Create" action: a prominent filled primary circle.
    if (item.isAction) {
      return Semantics(
        button: true,
        label: item.label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  shape: BoxShape.circle,
                  boxShadow: Shadows.lift,
                ),
                child: const Icon(LucideIcons.plus, size: 24, color: Colors.white),
              ),
              const SizedBox(height: 3),
              Text(item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(color: colors.textSecondary)),
            ],
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
        borderRadius: BorderRadius.circular(Radii.control),
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
                  child: Icon(item.icon, size: 26, color: color),
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
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
              child: Text(item.label,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
