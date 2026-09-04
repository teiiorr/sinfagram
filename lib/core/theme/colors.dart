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

  // Instagram design system (from-scratch redo). White canvas, black text, one
  // blue action colour, red for like/error; everything else is grey. No brand
  // gradient anywhere except the story ring (see AppGradients.storyRing).
  static const light = AppColors(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    border: Color(0xFFDBDBDB), // --border-default
    borderStrong: Color(0xFFA8A8A8), // input focus grey
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF737373),
    textTertiary: Color(0xFFC7C7C7),
    textOnPrimary: Color(0xFFFFFFFF),
    primary: Color(0xFF0095F6), // --accent-primary
    primaryHover: Color(0xFF1877F2),
    primarySubtle: Color(0xFFEFEFEF), // secondary button / hover fill
    accent: Color(0xFF00376B), // --text-link (@mentions, #tags)
    accentSubtle: Color(0xFFFAFAFA),
    success: Color(0xFF0095F6),
    successSubtle: Color(0xFFE0F1FF),
    warning: Color(0xFF737373), // neutral — no amber in this system
    warningSubtle: Color(0xFFFAFAFA),
    danger: Color(0xFFED4956),
    dangerSubtle: Color(0xFFFCE8EA),
    skeleton: Color(0xFFEFEFEF), // --border-subtle
  );

  static const dark = AppColors(
    bg: Color(0xFF000000), // pure black, not #111
    surface: Color(0xFF000000),
    surfaceRaised: Color(0xFF121212),
    border: Color(0xFF262626),
    borderStrong: Color(0xFF4D4D4D),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFA8A8A8),
    textTertiary: Color(0xFF4D4D4D),
    textOnPrimary: Color(0xFFFFFFFF),
    primary: Color(0xFF0095F6), // blue does not change between themes
    primaryHover: Color(0xFF1877F2),
    primarySubtle: Color(0xFF262626),
    accent: Color(0xFFE0F1FF),
    accentSubtle: Color(0xFF121212),
    success: Color(0xFF0095F6),
    successSubtle: Color(0xFF0A1A2A),
    warning: Color(0xFFA8A8A8),
    warningSubtle: Color(0xFF121212),
    danger: Color(0xFFFF3040), // slightly brighter red in dark
    dangerSubtle: Color(0xFF2A1416),
    skeleton: Color(0xFF1F1F1F),
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
