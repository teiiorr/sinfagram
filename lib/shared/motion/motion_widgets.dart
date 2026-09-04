import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/motion.dart';

/// Instagram rule: nothing animates on appearance/scroll. [Reveal] is kept as a
/// pass-through so existing call sites (`Reveal(index:, child:)`) compile while
/// rendering their child immediately, with no entrance animation.
class Reveal extends StatelessWidget {
  const Reveal({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = Duration.zero,
    this.rise = 0,
    this.scaleFrom = 1,
  });

  final Widget child;
  final int index;
  final Duration duration;
  final double rise;
  final double scaleFrom;

  @override
  Widget build(BuildContext context) => child;
}

/// Wrap any tappable surface: dims to 0.7 opacity while pressed (Instagram press
/// feedback — opacity, not scale) and fires an optional light haptic on tap.
class TapScale extends StatefulWidget {
  const TapScale(
      {super.key, required this.child, this.onTap, this.haptic = true});

  final Widget child;
  final VoidCallback? onTap;
  final bool haptic;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _down = false;

  void _set(bool v) {
    if (v != _down) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _set(true),
      onTapUp: widget.onTap == null ? null : (_) => _set(false),
      onTapCancel: widget.onTap == null ? null : () => _set(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.haptic) HapticFeedback.selectionClick();
              widget.onTap!();
            },
      // A soft, relaxing press: the surface eases down a touch and dims
      // slightly, then settles back — every tap gets a gentle response.
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: motionOf(context, const Duration(milliseconds: 190)),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _down ? 0.88 : 1.0,
          duration: motionOf(context, const Duration(milliseconds: 130)),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A number that counts up to [value] once (tabular, no jitter). Used on scores,
/// stats and standings.
class AnimatedCountText extends StatelessWidget {
  const AnimatedCountText(this.value,
      {super.key, this.style, this.duration = Motion.emphasized});

  final int value;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: motionOf(context, duration),
      curve: Motion.emphasize,
      builder: (context, v, _) => Text('${v.round()}', style: style),
    );
  }
}

/// A moving sheen for skeleton placeholders. More noticeable than a plain pulse
/// (product-owner direction), still cheap: one animated ShaderMask. Falls back to
/// a static tint under reduce-motion.
class Shimmer extends StatefulWidget {
  const Shimmer(
      {super.key,
      required this.child,
      required this.base,
      required this.highlight});

  final Widget child;
  final Color base;
  final Color highlight;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = bounds.width * (_c.value * 2 - 1);
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [widget.base, widget.highlight, widget.base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}
