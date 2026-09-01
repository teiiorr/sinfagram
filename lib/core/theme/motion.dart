import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/// Motion tokens. Baseline from docs/06; elevated per the product owner's
/// "best modern, more noticeable" direction (see DECISIONS.md) — springier
/// curves and slightly longer, more legible entrances/transitions. All motion is
/// compositing-only (Transform/Opacity) and honours reduce-motion.
abstract final class Motion {
  // Durations
  static const instant = Duration.zero;
  static const micro = Duration(milliseconds: 120); // taps, tiny state flips
  static const fast = Duration(milliseconds: 180); // colour, opacity
  static const base =
      Duration(milliseconds: 260); // the default for anything visible
  static const slow =
      Duration(milliseconds: 340); // sheets, size changes, reordering
  static const page = Duration(milliseconds: 320); // route transitions
  static const emphasized = Duration(milliseconds: 440); // hero moments
  static const celebrate = Duration(milliseconds: 560); // a win

  // Curves
  static const standard = Curves.easeOutCubic;
  static const enter = Curves.easeOutCubic; // something arriving
  static const exit = Curves.easeInCubic; // something leaving
  static const move =
      Curves.easeInOutCubic; // something on screen changing place
  static const press = Curves.easeOut; // touch feedback
  static const pop = Curves.easeOutBack; // overshoot for delight moments

  /// Material-3 "emphasized decelerate" — a confident, modern deceleration.
  static const emphasize = Cubic(0.05, 0.7, 0.1, 1.0);

  /// A soft spring-like settle for entrances and cards.
  static const spring = Cubic(0.34, 1.2, 0.64, 1.0);

  // Displacements
  static const riseSm = 6.0;
  static const riseMd = 12.0;
  static const riseLg = 20.0;
  static const slideX = 16.0;

  /// Per-item stagger step for list/section entrances.
  static const stagger = Duration(milliseconds: 55);
}

/// Honour the OS "reduce motion" setting everywhere. Wrap every duration in this.
Duration motionOf(BuildContext context, Duration d) =>
    MediaQuery.of(context).disableAnimations ? Duration.zero : d;

/// Opacity is the one channel we keep, shortened — a hard cut reads as a bug.
Duration fadeOf(BuildContext context, Duration d) =>
    MediaQuery.of(context).disableAnimations
        ? const Duration(milliseconds: 100)
        : d;

/// True when the viewer asked for reduced motion.
bool reduceMotion(BuildContext context) =>
    MediaQuery.of(context).disableAnimations;
