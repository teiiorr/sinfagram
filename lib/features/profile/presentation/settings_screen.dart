import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/app_mode.dart';
import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
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
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: colors.textTertiary,
              ),
            ),
            const SizedBox(height: Space.sm),
            _SettingsRow(
              icon: LucideIcons.moon,
              label: l.settingsDarkMode,
              trailing: Switch(
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
              trailing: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A settings list row: leading glyph, label, and a trailing widget (a chevron
/// for navigation, a [Switch] for a toggle). When [onTap] is null the card is
/// inert and the trailing control is the only interactive element.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelColor = danger ? colors.danger : colors.textPrimary;
    // A big, colourful leading tile — red for the destructive row, a stable
    // per-label hue otherwise so the list reads as a vivid set.
    final tileColor = danger ? AppAccents.red : AppAccents.forSeed(label);

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        // Min-height leaves room for the switch without pinning the row, so it
        // still grows with the text scale rather than clipping.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              IconTile(icon, color: tileColor, size: 44),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  label,
                  style: AppText.body.copyWith(color: labelColor),
                ),
              ),
              const SizedBox(width: Space.md),
              trailing,
            ],
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(LucideIcons.settings2, size: 24, color: AppAccents.violet),
            const SizedBox(width: Space.md),
            Text(l.settingsMode,
                style: AppText.body.copyWith(color: colors.textPrimary)),
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
                            : colors.surface,
                        borderRadius: BorderRadius.circular(Radii.control),
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
    );
  }
}
