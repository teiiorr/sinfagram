import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// Visual weight of an [AppButton]. Only one `primary` should be on screen at a
/// time; everything else is `secondary` or `ghost`. docs/05 §5.5.
enum AppButtonVariant { primary, secondary, ghost, danger }

/// Control height. `md` is the default; `lg` is for primary calls-to-action that
/// deserve a wider touch surface (onboarding, submit-a-form). docs/05 §5.5.
enum AppButtonSize { md, lg }

/// The one button in the system. Flat fill or hairline border, a single press
/// scale, an in-place loading ring — no gradients, glows, or bounce. docs/05 §5.5.
class AppButton extends StatefulWidget {
  const AppButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.loading = false,
  });

  final String label;

  /// Null disables the button (greyed, non-interactive). While [loading] the
  /// button also ignores taps but keeps its variant colours.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Optional leading icon. During [loading] it is swapped for the ring in the
  /// same 16 px slot, so the button never changes width.
  final IconData? icon;
  final bool loading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  // Control dimensions from docs/05 §5.5. Used as *floors* (minHeight) so text
  // scaled to 1.6x grows the button instead of clipping.
  // Larger controls per the product-owner direction (bigger buttons).
  static const double _heightMd = 48;
  static const double _heightLg = 56;

  // Leading icon / spinner box. Both share this size so the loading swap is
  // pixel-for-pixel and the label never shifts.
  static const double _iconSize = 20;

  // Accessibility floor for the tappable region, independent of the visual height.
  static const double _minTouch = 44;

  static const double _pressedScale = 0.98;

  bool _pressed = false;

  bool get _disabled => widget.onPressed == null;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  Color _background(AppColors c) {
    // A disabled button reads the same across variants: a flat, recessive fill.
    if (_disabled) return c.border;
    return switch (widget.variant) {
      AppButtonVariant.primary => _pressed ? c.primaryHover : c.primary,
      // No dedicated danger-hover role; the press scale carries the feedback.
      AppButtonVariant.danger => c.danger,
      AppButtonVariant.secondary => c.surface,
      AppButtonVariant.ghost => Colors.transparent,
    };
  }

  /// Primary CTAs carry the brand gradient for a premium read (DECISIONS.md).
  /// Other variants stay flat.
  Gradient? _gradient(AppColors c) {
    if (_disabled) return null;
    return widget.variant == AppButtonVariant.primary
        ? AppGradients.primary
        : null;
  }

  Color _foreground(AppColors c) {
    if (_disabled) return c.textTertiary;
    return switch (widget.variant) {
      AppButtonVariant.primary => c.textOnPrimary,
      AppButtonVariant.danger => c.textOnPrimary,
      AppButtonVariant.secondary => c.textPrimary,
      AppButtonVariant.ghost => c.primary,
    };
  }

  List<BoxShadow>? _shadow() {
    // Filled buttons get the faint resting card shadow; the border carries the
    // separation for secondary, and ghost has nothing to lift. Pressed = flat.
    if (_disabled || _pressed) return null;
    return switch (widget.variant) {
      AppButtonVariant.primary => Shadows.lift,
      AppButtonVariant.danger => Shadows.card,
      _ => null,
    };
  }

  Widget _content(AppColors c) {
    final fg = _foreground(c);

    final label = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppText.h3.copyWith(color: fg),
    );

    final ring = SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: CircularProgressIndicator(strokeWidth: 2, color: fg),
    );

    if (widget.icon != null) {
      // Leading-slot case: the ring occupies the icon's exact box, so width is
      // identical loading vs. not and the label stays put.
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: widget.loading
                ? ring
                : Icon(widget.icon, size: _iconSize, color: fg),
          ),
          const SizedBox(width: Space.xs),
          label,
        ],
      );
    }

    // No leading icon: the label is always laid out to fix the width, and the
    // ring is overlaid (label hidden only while it spins) so the box never grows.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: widget.loading ? 0 : 1, child: label),
        if (widget.loading) ring,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final interactive = !_disabled && !widget.loading;

    final height = widget.size == AppButtonSize.lg ? _heightLg : _heightMd;
    final hPad = widget.size == AppButtonSize.lg ? Space.lg : Space.md;
    // Transparent inset that lifts a sub-44 control (md) up to the touch floor
    // without changing its painted height.
    final touchInset = ((_minTouch - height) / 2).clamp(0.0, double.infinity);

    final visual = AnimatedContainer(
      duration: motionOf(context, Motion.fast),
      curve: Motion.press,
      constraints: BoxConstraints(minHeight: height),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Space.sm),
      decoration: BoxDecoration(
        color: _gradient(c) == null ? _background(c) : null,
        gradient: _gradient(c),
        borderRadius: BorderRadius.circular(Radii.control),
        border: (widget.variant == AppButtonVariant.secondary && !_disabled)
            ? Border.all(color: c.border)
            : null,
        boxShadow: _shadow(),
      ),
      child: _content(c),
    );

    return Semantics(
      button: true,
      enabled: interactive,
      label: widget.label,
      // The label is already announced by this node; drop the inner Text's
      // semantics so screen readers don't say it twice.
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: interactive ? (_) => _setPressed(true) : null,
        onTapUp: interactive ? (_) => _setPressed(false) : null,
        onTapCancel: interactive ? () => _setPressed(false) : null,
        onTap: interactive
            ? () {
                HapticFeedback.selectionClick();
                widget.onPressed!();
              }
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: touchInset),
          child: AnimatedScale(
            scale: _pressed ? _pressedScale : 1,
            duration: motionOf(context, Motion.fast),
            curve: Motion.press,
            child: visual,
          ),
        ),
      ),
    );
  }
}
