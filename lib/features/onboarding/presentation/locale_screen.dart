import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S02 — language picker (docs/09). The first onboarding step: choose the app
/// language before anything else is read. Selecting a row applies the locale
/// *immediately* via [localeProvider] so the whole shell — including this
/// screen's own title and button — flips to the chosen language live, and the
/// choice is confirmed with the continue button rather than auto-advancing.
class LocaleScreen extends ConsumerWidget {
  const LocaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    // The current selection. null == follow-system, which leaves every row
    // unchecked until the reader picks one.
    final selected = ref.watch(localeProvider);

    // Each label is already written in its own script, so it reads natively in
    // any current app language. Locale values match the app's supported set.
    final options = <({String label, Locale value})>[
      (label: l.localeUzLatn, value: const Locale('uz')),
      (
        label: l.localeUzCyrl,
        value: const Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
      ),
      (label: l.localeRu, value: const Locale('ru')),
      (label: l.localeKaa, value: const Locale('kaa')),
    ];

    final rows = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      rows.add(
        _LocaleOptionRow(
          label: option.label,
          accent: AppAccents.forSeed(option.label),
          selected: selected == option.value,
          onTap: () => ref.read(localeProvider.notifier).state = option.value,
        ),
      );
      if (i != options.length - 1) {
        rows.add(const SizedBox(height: Space.sm));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.localeTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.md,
                  Space.gutter,
                  Space.md,
                ),
                children: rows,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.gutter,
                Space.sm,
                Space.gutter,
                Space.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  l.actionContinue,
                  size: AppButtonSize.lg,
                  onPressed: () => context.go('/role'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable language row. Flat surface with a radio affordance on the
/// right: a filled check when chosen, an empty circle otherwise. The whole card
/// is the target, so it stays comfortable under a 1.6x text scale.
class _LocaleOptionRow extends StatelessWidget {
  const _LocaleOptionRow({
    required this.label,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Merge the label, the selected state, and the card's tap action into one
    // node so a screen reader announces "<language>, selected, button".
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        child: AppCard(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 28),
            child: Row(
              children: [
                // Colourful leading tile so the language list reads as a vivid
                // set (decorative — the row's merged semantics carry the label).
                IconTile(LucideIcons.languages, color: accent, size: 44),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Text(
                    label,
                    style: (selected ? AppText.bodyStrong : AppText.body)
                        .copyWith(color: colors.textPrimary),
                  ),
                ),
                const SizedBox(width: Space.md),
                // Decorative status marker (no semantics of its own — the row's
                // merged `selected` flag carries the state).
                Icon(
                  selected ? LucideIcons.circleCheck : LucideIcons.circle,
                  size: 20,
                  color: selected ? colors.primary : colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
