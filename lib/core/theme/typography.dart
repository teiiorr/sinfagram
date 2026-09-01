import 'dart:ui' show FontFeature;
import 'package:flutter/painting.dart';

/// Type scale — the "Play" redesign (design handoff). Two rounded, friendly
/// families, bundled (docs/11 §11.7 — never fetched at runtime):
///
/// * **Baloo 2** — display: greeting, wordmark, screen titles, scores, avatar
///   initials. Heavy, rounded, characterful.
/// * **Fredoka** — everything else: body, labels, captions.
///
/// This deliberately replaces Inter on pupil-facing surfaces (Inter read as
/// generic/institutional). Body sits at ~15; nothing below 12 ships. All numeric
/// displays use tabular figures so they never jitter.
abstract final class AppText {
  static const _display = 'Baloo 2';
  static const _body = 'Fredoka';

  /// Greeting ("Salom, Nodira!") — Baloo 2 800.
  static const display = TextStyle(
      fontFamily: _display,
      fontSize: 27,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3);

  /// Wordmark ("Sinfagram") — Baloo 2 700, tracked.
  static const wordmark = TextStyle(
      fontFamily: _display,
      fontSize: 14,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4);

  /// Screen title.
  static const h1 = TextStyle(
      fontFamily: _display,
      fontSize: 23,
      height: 1.15,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2);

  /// Section / big label / profile name.
  static const h2 = TextStyle(
      fontFamily: _display,
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w800);

  /// Card header / section label.
  static const h3 = TextStyle(
      fontFamily: _body,
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w700);

  static const body = TextStyle(
      fontFamily: _body,
      fontSize: 15,
      height: 1.5,
      fontWeight: FontWeight.w400);

  /// Card author name / emphasised body.
  static const bodyStrong = TextStyle(
      fontFamily: _body,
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w700);

  static const bodySm = TextStyle(
      fontFamily: _body,
      fontSize: 13.5,
      height: 1.45,
      fontWeight: FontWeight.w500);

  /// Chip / action label / nav label.
  static const label = TextStyle(
      fontFamily: _body,
      fontSize: 13,
      height: 1.25,
      fontWeight: FontWeight.w600);

  static const caption = TextStyle(
      fontFamily: _body,
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w400);

  /// Scores, standings, counters — Baloo 2, tabular figures so numbers never
  /// jitter. Override [fontSize] for the big score displays.
  static const numeric = TextStyle(
    fontFamily: _display,
    fontSize: 20,
    height: 1.1,
    fontWeight: FontWeight.w800,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
