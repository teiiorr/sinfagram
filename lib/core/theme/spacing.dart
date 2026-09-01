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

abstract final class Radii {
  static const chip = 8.0;
  static const control = 12.0; // buttons, inputs — softer, modern
  static const card = 16.0; // cards — softer, modern
  static const lg = 20.0; // large surfaces
  static const sheet = 20.0; // top corners of bottom sheets
  static const hero = 24.0; // hero cards
  static const avatar = 999.0; // the only place a full round is allowed
}

abstract final class Shadows {
  /// Resting cards. Soft ambient depth (DECISIONS.md — elevated look).
  static const card = [
    BoxShadow(color: Color(0x0D0F1419), blurRadius: 10, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x080F1419), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Larger soft depth for elevated content.
  static const soft = [
    BoxShadow(color: Color(0x0F0F1419), blurRadius: 20, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0A0F1419), blurRadius: 4, offset: Offset(0, 1)),
  ];

  /// A lifted, tappable hero surface / primary CTA (tinted, premium).
  static const lift = [
    BoxShadow(color: Color(0x242B4FC7), blurRadius: 22, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x0F0F1419), blurRadius: 6, offset: Offset(0, 2)),
  ];

  /// Menus, popovers.
  static const raised = [
    BoxShadow(color: Color(0x140F1419), blurRadius: 12, offset: Offset(0, 4))
  ];

  /// Bottom sheets and dialogs only.
  static const overlay = [
    BoxShadow(color: Color(0x1A0F1419), blurRadius: 28, offset: Offset(0, 10))
  ];
}

/// Border widths. docs/05 §5.3. Everything is a single hairline; the only place
/// a wider stroke is allowed is the 2 px focus ring.
abstract final class Stroke {
  static const hairline = 1.0;
  static const focus = 2.0;
}
