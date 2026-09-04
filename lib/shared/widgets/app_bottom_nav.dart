import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';

class AppNavItem {
  const AppNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.isAction = false,
  });

  /// The resting (outline) glyph.
  final IconData icon;

  /// The filled glyph shown when this tab is selected. When null, [icon] is used
  /// for both states.
  final IconData? activeIcon;

  final String label;

  /// An action item (the centre "Create" slot) renders as a plain icon and never
  /// takes the selected/filled treatment.
  final bool isAction;
}

/// Instagram bottom navigation: a flat 49px bar on [AppColors.surface] with a
/// single hairline top border, five icon-only slots, no labels, no shadow, no
/// floating margin, no sliding blob, and no gradient FAB. The selected tab shows
/// a filled glyph; the rest are outlines — both in [AppColors.textPrimary], so
/// selection reads by fill, never by colour. A single dot (never a number) marks
/// [dotIndex].
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

  /// Instagram's tab bar height.
  static const double _barHeight = 49;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.border, width: Stroke.hairline),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: _barHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _NavItem(
                    item: items[i],
                    selected: i == currentIndex,
                    dot: i == dotIndex,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(i);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
    this.dot = false,
  });

  final AppNavItem item;
  final bool selected;
  final bool dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // The create slot is a plain "+" — no FAB, no fill treatment.
    final IconData icon = item.isAction
        ? LucideIcons.plus
        : (selected ? (item.activeIcon ?? item.icon) : item.icon);

    return Semantics(
      selected: !item.isAction && selected,
      button: true,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        containedInkWell: false,
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 24, color: colors.textPrimary),
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
          ),
        ),
      ),
    );
  }
}
