import 'package:flutter/material.dart';

/// Raw palette. Widgets never reference this directly — they read [AppColors]
/// from the theme. See docs/05 §5.1.
abstract final class Palette {
  // Primary — calm institutional blue. Trustworthy without being a government form.
  static const primary50 = Color(0xFFEEF3FF);
  static const primary100 = Color(0xFFDCE6FF);
  static const primary200 = Color(0xFFBACCFF);
  static const primary300 = Color(0xFF8FA9F7);
  static const primary400 = Color(0xFF5F82EF);
  static const primary500 = Color(0xFF3A62E0);
  static const primary600 = Color(0xFF2B4FC7);
  static const primary700 = Color(0xFF23409F);
  static const primary800 = Color(0xFF1D3480);
  static const primary900 = Color(0xFF182A66);

  // Accent — used for a class win, a sealed chapter, a treasury reward. Nowhere else.
  static const accent100 = Color(0xFFFDF0D6);
  static const accent300 = Color(0xFFF0C070);
  static const accent500 = Color(0xFFD98A12);
  static const accent700 = Color(0xFF9A5F08);

  // Neutral
  static const neutral0 = Color(0xFFFFFFFF);
  static const neutral25 = Color(0xFFFAFBFC);
  static const neutral50 = Color(0xFFF4F6F8);
  static const neutral100 = Color(0xFFE9EDF1);
  static const neutral200 = Color(0xFFD8DDE2);
  static const neutral300 = Color(0xFFBAC2CA);
  static const neutral400 = Color(0xFF98A2AC);
  static const neutral500 = Color(0xFF74808C);
  static const neutral600 = Color(0xFF5A6570);
  static const neutral700 = Color(0xFF414A54);
  static const neutral800 = Color(0xFF2A323A);
  static const neutral900 = Color(0xFF171C22);
  static const neutral950 = Color(0xFF0F1419);

  // Semantic
  static const success500 = Color(0xFF1F8A55);
  static const success100 = Color(0xFFDDF3E7);
  static const warning500 = Color(0xFFB4690E);
  static const warning100 = Color(0xFFFBEEDA);
  static const danger500 = Color(0xFFC8372D);
  static const danger100 = Color(0xFFFBE4E2);
}

/// Semantic colour roles. Every widget reads these, so dark mode is a single swap.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.primary,
    required this.primaryHover,
    required this.primarySubtle,
    required this.accent,
    required this.accentSubtle,
    required this.success,
    required this.successSubtle,
    required this.warning,
    required this.warningSubtle,
    required this.danger,
    required this.dangerSubtle,
    required this.skeleton,
  });

  final Color bg, surface, surfaceRaised, border, borderStrong;
  final Color textPrimary, textSecondary, textTertiary, textOnPrimary;
  final Color primary, primaryHover, primarySubtle;
  final Color accent, accentSubtle;
  final Color success,
      successSubtle,
      warning,
      warningSubtle,
      danger,
      dangerSubtle;
  final Color skeleton;

  static const light = AppColors(
    bg: Palette.neutral25,
    surface: Palette.neutral0,
    surfaceRaised: Palette.neutral0,
    border: Palette.neutral200,
    borderStrong: Palette.neutral300,
    textPrimary: Palette.neutral900,
    textSecondary: Palette.neutral600,
    textTertiary: Palette.neutral400,
    textOnPrimary: Palette.neutral0,
    // Vibrant indigo-violet brand (DECISIONS.md — creative, not institutional).
    primary: Color(0xFF6A4CE6),
    primaryHover: Color(0xFF5638C7),
    primarySubtle: Color(0xFFEFEBFF),
    accent: Palette.accent500,
    accentSubtle: Palette.accent100,
    success: Palette.success500,
    successSubtle: Palette.success100,
    warning: Palette.warning500,
    warningSubtle: Palette.warning100,
    danger: Palette.danger500,
    dangerSubtle: Palette.danger100,
    skeleton: Palette.neutral100,
  );

  static const dark = AppColors(
    bg: Palette.neutral950,
    surface: Palette.neutral900,
    surfaceRaised: Palette.neutral800,
    border: Color(0xFF2C343C),
    borderStrong: Color(0xFF3D4750),
    textPrimary: Color(0xFFECEFF2),
    textSecondary: Palette.neutral400,
    textTertiary: Palette.neutral500,
    textOnPrimary: Palette.neutral0,
    primary: Color(0xFF9B87F5),
    primaryHover: Color(0xFFB4A6FA),
    primarySubtle: Color(0xFF241C46),
    accent: Palette.accent300,
    accentSubtle: Color(0xFF3A2A10),
    success: Color(0xFF48B27C),
    successSubtle: Color(0xFF10301F),
    warning: Color(0xFFD79233),
    warningSubtle: Color(0xFF33240C),
    danger: Color(0xFFE0655B),
    dangerSubtle: Color(0xFF3A1917),
    skeleton: Color(0xFF232B33),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnPrimary,
    Color? primary,
    Color? primaryHover,
    Color? primarySubtle,
    Color? accent,
    Color? accentSubtle,
    Color? success,
    Color? successSubtle,
    Color? warning,
    Color? warningSubtle,
    Color? danger,
    Color? dangerSubtle,
    Color? skeleton,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      accent: accent ?? this.accent,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      success: success ?? this.success,
      successSubtle: successSubtle ?? this.successSubtle,
      warning: warning ?? this.warning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      danger: danger ?? this.danger,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      skeleton: skeleton ?? this.skeleton,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSubtle: Color.lerp(successSubtle, other.successSubtle, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSubtle: Color.lerp(warningSubtle, other.warningSubtle, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSubtle: Color.lerp(dangerSubtle, other.dangerSubtle, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
    );
  }
}

/// Read semantic colours from anywhere: `context.colors.primary`.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
