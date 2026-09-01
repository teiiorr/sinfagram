import 'package:flutter/painting.dart' show BoxShadow, Color, Offset;

/// 8 px grid. `xs = 4` exists only for icon-to-label gaps. docs/05 §5.3.
/// Never write a raw spacing number in a widget — `EdgeInsets.all(Space.md)`.
abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;

  /// Horizontal page gutter. Every screen uses this — no screen invents its own.
  static const gutter = 16.0;
}

/// "Play" redesign radii (design handoff). Big, soft, rounded.
abstract final class Radii {
  static const chip = 10.0;
  static const control = 15.0; // buttons, inputs
  static const media = 16.0; // photo/video blocks
  static const fab = 20.0; // rounded-square FAB (not a circle)
  static const hero = 24.0; // gradient hero cards
  static const card = 26.0; // post / discussion / classmate cards, sheets
  static const sheet = 26.0; // top corners of bottom sheets
  static const nav = 28.0; // floating nav bar
  static const lg = 28.0; // large surfaces
  static const header = 42.0; // feed hero header bottom corners
  static const avatar = 999.0; // the only place a full round is allowed
}

/// Shadows — the signature is a **violet-tinted glow**, not a neutral grey
/// shadow (design handoff). Central to the look; used on both themes.
abstract final class Shadows {
  /// Resting cards — violet glow.
  static const card = [
    BoxShadow(color: Color(0x246B4CE6), blurRadius: 26, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x146B4CE6), blurRadius: 8, offset: Offset(0, 3)),
  ];

  /// Floating nav bar — a broader violet lift.
  static const soft = [
    BoxShadow(color: Color(0x3D5A3CC8), blurRadius: 32, offset: Offset(0, 16)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  /// A lifted, tappable hero surface / primary CTA / FAB (strong violet glow).
  static const lift = [
    BoxShadow(color: Color(0x4C5B3FE0), blurRadius: 24, offset: Offset(0, 14)),
    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  /// Menus, popovers.
  static const raised = [
    BoxShadow(color: Color(0x1F6B4CE6), blurRadius: 16, offset: Offset(0, 6))
  ];

  /// Bottom sheets and dialogs only (upward cast).
  static const overlay = [
    BoxShadow(color: Color(0x33000000), blurRadius: 40, offset: Offset(0, -10))
  ];
}

/// Border widths. docs/05 §5.3. Everything is a single hairline; the only place
/// a wider stroke is allowed is the 2 px focus ring.
abstract final class Stroke {
  static const hairline = 1.0;
  static const focus = 2.0;
}
