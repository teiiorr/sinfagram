import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, TextInputFormatter;

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// The counter stays hidden until the field is nearly full, so an ordinary
/// half-typed field reads as clean rather than as a form under pressure.
const double _counterRevealFraction = 0.8;

/// A text input with the label held permanently above the field. docs/05 §5.5.
///
/// A floating placeholder is deliberately avoided: it disappears the instant the
/// user starts typing, taking the field's purpose with it. Instead the label sits
/// above in [AppText.label], and the field carries a single hairline border that
/// thickens to a [Stroke.focus] primary ring on focus and recolours to
/// [AppColors.danger] whenever [errorText] is set. The two combine — a focused,
/// errored field shows a 2 px danger ring — and the border colour animates within
/// the motion budget, honouring reduce-motion.
///
/// A character counter (e.g. "72/80") appears above-right only once the text
/// passes [_counterRevealFraction] of [maxLength]; when [maxLength] is given the
/// field is also hard-capped at that length.
///
/// Public constructor is stable for the gallery; the [State] exists only to track
/// focus and the live character count.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final int? maxLength;
  final int maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Created only when the caller supplies none, so we dispose exactly what we own.
  TextEditingController? _internalController;
  late final FocusNode _focusNode;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  bool get _tracksCounter => widget.maxLength != null;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    if (_tracksCounter) _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Move the counter listener when the effective controller (or the need to
    // count at all) changes; otherwise a swapped-in controller would silently
    // stop driving the counter.
    final bool controllerChanged = widget.controller != oldWidget.controller;
    final bool trackingChanged =
        (widget.maxLength != null) != (oldWidget.maxLength != null);
    if (controllerChanged || trackingChanged) {
      final TextEditingController oldEffective =
          oldWidget.controller ?? _internalController ?? _controller;
      oldEffective.removeListener(_handleTextChange);
      if (controllerChanged &&
          oldWidget.controller != null &&
          _internalController != null) {
        // The caller reclaimed control of the text; our own controller is dead weight.
        _internalController!.dispose();
        _internalController = null;
      }
      if (_tracksCounter) _controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  void _handleTextChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool hasError = widget.errorText != null;

    // Error owns the colour; focus owns the weight. Combined, an errored field
    // that is focused reads as a 2 px danger ring.
    final Color borderColor = hasError
        ? colors.danger
        : _focused
            ? colors.primary
            : colors.border;
    final double borderWidth = _focused ? Stroke.focus : Stroke.hairline;

    // The ring's extra pixel is absorbed by shrinking the padding, so the outer
    // box and the text baseline never shift as focus grows or releases.
    final double ringInset = borderWidth - Stroke.hairline;

    final int length = _controller.text.characters.length;
    final bool showCounter = widget.maxLength != null &&
        length > widget.maxLength! * _counterRevealFraction;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: AppText.label.copyWith(color: colors.textSecondary),
              ),
            ),
            if (showCounter)
              Padding(
                padding: const EdgeInsets.only(left: Space.sm),
                child: Text(
                  '$length/${widget.maxLength}',
                  // Tabular figures keep the counter from twitching as it counts.
                  style: AppText.caption.copyWith(
                    color: colors.textTertiary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: Space.xs),
        AnimatedContainer(
          duration: motionOf(context, Motion.fast),
          curve: Motion.press,
          // 40 px min kept on the 8 px grid (32 + 8) rather than as a raw literal.
          // A min height (not a fixed one) lets the field grow for large text
          // scales and extra lines without clipping.
          constraints: const BoxConstraints(minHeight: Space.xl + Space.sm),
          padding: EdgeInsets.symmetric(
            horizontal: Space.md - ringInset,
            vertical: Space.sm - ringInset,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(Radii.control),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            // obscureText requires a single line; guard the caller against an assert.
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            // Enforce the cap ourselves so the built-in Material counter stays off
            // and only our reveal-late counter shows.
            inputFormatters: widget.maxLength != null
                ? <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(widget.maxLength),
                  ]
                : null,
            cursorColor: colors.primary,
            style: AppText.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: widget.hint,
              hintStyle: AppText.body.copyWith(color: colors.textTertiary),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: Space.xs),
          Text(
            widget.errorText!,
            style: AppText.caption.copyWith(color: colors.danger),
          ),
        ],
      ],
    );
  }
}
