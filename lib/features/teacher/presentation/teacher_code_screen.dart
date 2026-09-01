import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';

/// T04 — class join code (docs/07 §7.9). A single large code shown once, a note
/// on sharing it, and a flat print action. Mock only — print reports itself as
/// a SnackBar.
class TeacherCodeScreen extends ConsumerWidget {
  const TeacherCodeScreen({super.key});

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.tCodeTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.gutter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Center(
                    child: Text(
                      '473921',
                      textAlign: TextAlign.center,
                      style: AppText.display.copyWith(
                        color: colors.textPrimary,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Space.md),
                Text(
                  l.tCodeShareNote,
                  textAlign: TextAlign.center,
                  style: AppText.bodySm.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: Space.lg),
                AppButton(
                  l.tCodePrint,
                  icon: LucideIcons.printer,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _toast(context, l.tCodePrint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
