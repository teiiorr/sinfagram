import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/app_mode.dart';
import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';

/// S41 — Settings. Three device-level controls: language & script, the dark-mode
/// toggle, and sign-out. Language opens the shared picker (S02); the theme switch
/// flips [themeModeProvider] live so the whole shell re-themes immediately.
///
/// Instagram styling: plain full-bleed list rows — a neutral 24px glyph, a label,
/// and a trailing value/chevron/switch — grouped by hairline dividers. No cards,
/// no colourful tiles, no shadows.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: Space.sm),
            const _Hairline(),
            _SettingsRow(
              icon: LucideIcons.languages,
              label: l.settingsLanguage,
              onTap: () => context.push('/locale'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _localeLabel(context, l),
                    style: AppText.body.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(width: Space.xs),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: colors.textTertiary,
                  ),
                ],
              ),
            ),
            _SettingsRow(
              icon: LucideIcons.moon,
              label: l.settingsDarkMode,
              // The whole 48px row is the toggle target (>=44x44); the pill is a
              // display-only indicator so the two never contend for the tap.
              onTap: () => ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark,
              trailing: _PillSwitch(value: isDark),
            ),
            const _ModeSelector(),
            const SizedBox(height: Space.lg),
            const _Hairline(),
            _SettingsRow(
              icon: LucideIcons.logOut,
              label: l.settingsSignOut,
              danger: true,
              onTap: () => ref.read(sessionProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }

  /// The active resolved app locale, in its own script — mirrors the labels the
  /// language picker (S02) offers.
  String _localeLabel(BuildContext context, AppL10n l) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'uz') {
      return locale.scriptCode == 'Cyrl' ? l.localeUzCyrl : l.localeUzLatn;
    }
    if (locale.languageCode == 'kaa') return l.localeKaa;
    if (locale.languageCode == 'ru') return l.localeRu;
    return l.localeUzLatn;
  }
}

/// A full-width hairline, edge to edge — the divider between list rows and the
/// top edge of a grouped section.
class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) => Container(
        height: Stroke.hairline,
        color: context.colors.border,
      );
}

/// A settings list row: a neutral 24px glyph, a label, and a trailing widget
/// (a value + chevron for navigation, or a toggle). 48px tall, surface fill, a
/// hairline bottom divider, no radius or shadow. The destructive row is tinted
/// danger. When [onTap] is null the row is inert and the trailing control is the
/// only interactive element.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.textPrimary;

    final row = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Row(
            children: [
              Icon(icon, size: 24, color: fg),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  label,
                  style: AppText.body.copyWith(color: fg),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: Space.md),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return MergeSemantics(child: row);

    return MergeSemantics(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, child: row),
      ),
    );
  }
}

/// The dark-mode pill: a rounded track that fills with the brand primary when on
/// and a neutral border grey when off, with a white knob that slides across.
/// Flat (no knob shadow). Display-only — the enclosing row carries the tap.
/// 250ms, honours reduce-motion.
class _PillSwitch extends StatelessWidget {
  const _PillSwitch({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = motionOf(context, const Duration(milliseconds: 250));

    return Semantics(
      toggled: value,
      child: AnimatedContainer(
        duration: duration,
        curve: Motion.standard,
        width: 50,
        height: 29,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? colors.primary : colors.border,
          borderRadius: BorderRadius.circular(Radii.avatar),
        ),
        child: AnimatedAlign(
          duration: duration,
          curve: Motion.standard,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Demo-only: forces night/lesson mode so the interstitials (S60/S61) are
/// reachable at any hour. In production the mode is server-driven. Rendered as a
/// flat labelled block in the list (neutral glyph + a row of selectable pills).
class _ModeSelector extends ConsumerWidget {
  const _ModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final current = ref.watch(appModeProvider);

    final items = <(AppMode, String)>[
      (AppMode.normal, l.modeNormal),
      (AppMode.night, l.modeNight),
      (AppMode.lesson, l.modeLesson),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Space.gutter, vertical: Space.sm + Space.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(LucideIcons.settings2, size: 24, color: colors.textPrimary),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(l.settingsMode,
                    style: AppText.body.copyWith(color: colors.textPrimary)),
              ),
            ]),
            const SizedBox(height: Space.md),
            Row(
              children: [
                for (final (mode, label) in items)
                  Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(modeOverrideProvider.notifier).state = mode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Space.md, vertical: Space.sm),
                        decoration: BoxDecoration(
                          color: current == mode
                              ? colors.primarySubtle
                              : colors.bg,
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(
                              color: current == mode
                                  ? colors.primary
                                  : colors.border,
                              width: Stroke.hairline),
                        ),
                        child: Text(label,
                            style: AppText.label.copyWith(
                                color: current == mode
                                    ? colors.primary
                                    : colors.textSecondary)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
