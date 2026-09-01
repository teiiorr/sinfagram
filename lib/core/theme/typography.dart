import 'dart:ui' show FontFeature;
import 'package:flutter/painting.dart';

/// Type scale. Inter, bundled (docs/05 §5.2, docs/11 §11.7 — never fetched at runtime).
/// Body sits at 15–16; nothing below 12 ever ships.
abstract final class AppText {
  static const _family = 'Inter';

  static const display = TextStyle(
      fontFamily: _family,
      fontSize: 28,
      height: 1.25,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4);
  static const h1 = TextStyle(
      fontFamily: _family,
      fontSize: 22,
      height: 1.30,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2);
  static const h2 = TextStyle(
      fontFamily: _family,
      fontSize: 18,
      height: 1.35,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1);
  static const h3 = TextStyle(
      fontFamily: _family,
      fontSize: 16,
      height: 1.40,
      fontWeight: FontWeight.w600);
  static const body = TextStyle(
      fontFamily: _family,
      fontSize: 15,
      height: 1.50,
      fontWeight: FontWeight.w400);
  static const bodyStrong = TextStyle(
      fontFamily: _family,
      fontSize: 15,
      height: 1.50,
      fontWeight: FontWeight.w600);
  static const bodySm = TextStyle(
      fontFamily: _family,
      fontSize: 13,
      height: 1.45,
      fontWeight: FontWeight.w400);
  static const label = TextStyle(
      fontFamily: _family,
      fontSize: 13,
      height: 1.30,
      fontWeight: FontWeight.w600);
  static const caption = TextStyle(
      fontFamily: _family,
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w400);

  /// Tabular figures on every score, standing, countdown and counter — numbers must not jitter.
  static const numeric = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    height: 1.20,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
