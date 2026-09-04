import 'dart:ui' show FontFeature;
import 'package:flutter/painting.dart';

/// Type scale — Instagram design system. **No custom font**: styles omit
/// `fontFamily` so each platform renders its native UI face (SF Pro on iOS,
/// Roboto on Android) — the interface looks "native" everywhere by design.
///
/// The scale is small and exact (all values real px): nothing in the chrome
/// exceeds 16px; body is 14/400; secondary meta is 12. No letter-spacing, no
/// all-caps, no italics.
abstract final class AppText {
  /// Screen title / header. (Also the largest allowed chrome size.)
  static const h1 = TextStyle(
      fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w600);

  /// Section header inside a screen.
  static const h2 = TextStyle(
      fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w600);

  /// Sub-header / emphasised row title.
  static const h3 = TextStyle(
      fontSize: 14, height: 18 / 14, fontWeight: FontWeight.w600);

  /// Wordmark — plain, no brand font (never copy Instagram Sans).
  static const wordmark = TextStyle(
      fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w600);

  /// Caption / body copy.
  static const body = TextStyle(
      fontSize: 14, height: 18 / 14, fontWeight: FontWeight.w400);

  /// Username / like-count / emphasised inline (600).
  static const bodyStrong = TextStyle(
      fontSize: 14, height: 18 / 14, fontWeight: FontWeight.w600);

  /// Time, secondary metadata.
  static const bodySm = TextStyle(
      fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w400);

  /// Button / action label (14/600).
  static const label = TextStyle(
      fontSize: 14, height: 18 / 14, fontWeight: FontWeight.w600);

  /// Small meta (timestamps, "Sponsored").
  static const caption = TextStyle(
      fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w400);

  /// Numbers (like counts, standings). 14/600 by default; profile stats use
  /// copyWith(fontSize: 16). Tabular so they never jitter.
  static const numeric = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
