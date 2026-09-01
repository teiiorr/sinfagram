import 'package:flutter/painting.dart';

/// Accent gradients for hero surfaces and primary CTAs only (DECISIONS.md —
/// elevated design). Everything else stays flat and on-token. Brand-consistent
/// (built on the primary/accent palette) and legible in both themes.
abstract final class AppGradients {
  /// Primary CTA — a vivid violet with a depth shift.
  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7A5CF0), Color(0xFF5B3FE0)],
  );

  /// Hero surfaces — a bold indigo → violet → pink sweep (creative).
  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B4FE0), Color(0xFF9B4CE6), Color(0xFFE6568F)],
  );

  /// Reward / win moments only.
  static const accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE7A63A), Color(0xFFD98A12)],
  );

  /// A vivid two-stop gradient from a single accent colour (for [IconTile]).
  static LinearGradient of(Color c) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(c, const Color(0xFFFFFFFF), 0.18)!, c],
      );
}

/// A vivid, friendly accent palette (DECISIONS.md — the product owner asked for a
/// colourful, non-monotone interface). Used on icon tiles, section glyphs and
/// hero moments; body text/surfaces stay on the neutral token ramp for balance.
abstract final class AppAccents {
  static const violet = Color(0xFF6D4FE0);
  static const blue = Color(0xFF3A62E0);
  static const cyan = Color(0xFF1EA7C5);
  static const teal = Color(0xFF12B39B);
  static const green = Color(0xFF27AE60);
  static const amber = Color(0xFFE7A63A);
  static const orange = Color(0xFFF2802E);
  static const pink = Color(0xFFEB4D8C);
  static const red = Color(0xFFE0655B);

  static const all = [
    violet,
    blue,
    cyan,
    teal,
    green,
    amber,
    orange,
    pink,
    red
  ];

  /// Deterministic colour for a label/seed, so the same section always keeps its
  /// hue across the app.
  static Color forSeed(String seed) {
    var h = 0;
    for (final c in seed.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return all[h % all.length];
  }
}
