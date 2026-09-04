import 'package:flutter/material.dart';
import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// ThemeData for both modes. Colours live in the [AppColors] extension; widgets
/// read them via `context.colors`. Flat by mandate (docs/05): no gradients, no
/// glow, elevation carried by hairline borders and the tiny [Shadows] tokens.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final scheme = ColorScheme.fromSeed(
      seedColor: c.primary,
      brightness: brightness,
    ).copyWith(
      surface: c.surface,
      error: c.danger,
      primary: c.primary,
      onPrimary: c.textOnPrimary,
    );

    final base =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.surface,
      extensions: [c],
      // No custom family — the platform's native UI face (SF Pro / Roboto).
      textTheme: _textTheme(c.textPrimary),
      appBarTheme: AppBarTheme(
        toolbarHeight: 52,
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.h2.copyWith(color: c.textPrimary),
        iconTheme: IconThemeData(color: c.textSecondary),
      ),
      dividerTheme: DividerThemeData(
          color: c.border, thickness: Stroke.hairline, space: Stroke.hairline),
      splashColor: c.primary.withValues(alpha: 0.06),
      highlightColor: c.primary.withValues(alpha: 0.04),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceRaised,
        contentTextStyle: AppText.bodySm.copyWith(color: c.textPrimary),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.card)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        ),
      ),
      visualDensity: VisualDensity.standard,
    );
  }

  static TextTheme _textTheme(Color color) {
    TextStyle t(TextStyle s) => s.copyWith(color: color);
    return TextTheme(
      displayLarge: t(AppText.h1),
      headlineMedium: t(AppText.h1),
      titleLarge: t(AppText.h2),
      titleMedium: t(AppText.h3),
      bodyLarge: t(AppText.body),
      bodyMedium: t(AppText.body),
      bodySmall: t(AppText.bodySm),
      labelLarge: t(AppText.label),
      labelSmall: t(AppText.caption),
    );
  }
}
