import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/app_mode.dart';
import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S41 — Settings. Three device-level controls: language & script, the dark-mode
/// toggle, and sign-out. Language opens the shared picker (S02); the theme switch
/// flips [themeModeProvider] live so the whole shell re-themes immediately.
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
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.lg,
            Space.gutter,
            Space.lg,
          ),
          children: [
            _SettingsRow(
              icon: LucideIcons.languages,
              label: l.settingsLanguage,
              onTap: () => context.push('/locale'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _localeLabel(context, l),
                    style: AppText.label.copyWith(color: colors.textSecondary),
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
            const SizedBox(height: Space.sm),
            _SettingsRow(
              icon: LucideIcons.moon,
              label: l.settingsDarkMode,
              trailing: _PillSwitch(
                value: isDark,
                onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                    v ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
            const SizedBox(height: Space.sm),
            const _ModeSelector(),
            const SizedBox(height: Space.sm),
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

/// A settings list row: a big colourful leading tile, a label, and a trailing
/// widget (a value + chevron for navigation, or a toggle). Radius-15 surface with
/// a hairline border; the destructive row is tinted danger. When [onTap] is null
/// the row is inert and the trailing control is the only interactive element.
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
    final labelColor = danger ? colors.danger : colors.textPrimary;
    // A vivid leading tile — red for the destructive row, a stable per-label hue
    // otherwise so the list reads as a colourful set.
    final tileColor = danger ? AppAccents.red : AppAccents.forSeed(label);
    final bg = danger ? colors.dangerSubtle : colors.surface;
    final borderColor =
        danger ? colors.danger.withValues(alpha: 0.35) : colors.border;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: Stroke.hairline),
          borderRadius: BorderRadius.circular(Radii.control),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(Radii.control),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.control),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 42),
                child: Row(
                  children: [
                    IconTile(icon, color: tileColor, size: 42),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Text(
                        label,
                        style: AppText.body.copyWith(color: labelColor),
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
          ),
        ),
      ),
    );
  }
}

/// The dark-mode pill switch: a rounded track that fills with the brand primary
/// when on and a neutral strong-border when off, with a white knob that slides
/// across. 250ms, honours reduce-motion.
class _PillSwitch extends StatelessWidget {
  const _PillSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration =
        motionOf(context, const Duration(milliseconds: 250));

    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: duration,
          curve: Motion.standard,
          width: 50,
          height: 29,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? colors.primary : colors.borderStrong,
            borderRadius: BorderRadius.circular(Radii.avatar),
          ),
          child: AnimatedAlign(
            duration: duration,
            curve: Motion.standard,
            alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 23,
              height: 23,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Demo-only: forces night/lesson mode so the interstitials (S60/S61) are
/// reachable at any hour. In production the mode is server-driven.
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
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.control),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconTile(LucideIcons.settings2,
                  color: AppAccents.violet, size: 42),
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
