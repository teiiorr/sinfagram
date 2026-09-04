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

/// Instagram radii. Media in the feed is radius 0 (full-bleed); posts are not
/// "cards" and carry no radius. Only avatars/story rings are fully round;
/// modals/sheets are 12, buttons 8, fields 4, grid/reels previews 8.
abstract final class Radii {
  static const chip = 4.0;
  static const input = 4.0; // text fields
  static const control = 8.0; // buttons
  static const media = 0.0; // feed photo/video — full-bleed, no rounding
  static const fab = 0.0; // (no FAB in this system)
  static const hero = 8.0; // reels/grid previews, attachments, tooltips
  static const card = 0.0; // posts / list blocks are flat, not soft cards
  static const sheet = 12.0; // top corners of bottom sheets
  static const nav = 0.0;
  static const lg = 12.0; // modals
  static const header = 0.0;
  static const avatar = 999.0; // avatars + story circles only
}

/// Shadows exist in exactly three places — dropdown/menu, web modal, toast —
/// and NOWHERE on a static element (post, avatar, button, field). So the resting
/// `card`/`soft`/`lift` tokens are intentionally empty.
abstract final class Shadows {
  /// Static surfaces cast no shadow (Instagram rule).
  static const List<BoxShadow> card = [];
  static const List<BoxShadow> soft = [];
  static const List<BoxShadow> lift = [];

  /// Dropdowns, context menus. (--shadow-menu)
  static const raised = [
    BoxShadow(color: Color(0x26000000), blurRadius: 12, offset: Offset(0, 4))
  ];

  /// Web modals / dialogs. (--shadow-modal)
  static const overlay = [
    BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8))
  ];

  /// Toasts. (--shadow-toast)
  static const toast = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2))
  ];
}

/// Border widths. docs/05 §5.3. Everything is a single hairline; the only place
/// a wider stroke is allowed is the 2 px focus ring.
abstract final class Stroke {
  static const hairline = 1.0;
  static const focus = 2.0;
}
