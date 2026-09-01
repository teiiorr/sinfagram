import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/teacher/application/teacher_controllers.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// T03 — roster import (docs/07 §7.9). Two flat entry points (manual / CSV),
/// a change preview showing the additions, and a single apply. Mock only —
/// every action reports itself as a SnackBar.
class TeacherRosterImportScreen extends ConsumerWidget {
  const TeacherRosterImportScreen({super.key});

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    // The diff preview shows only the first handful of additions.
    final additions = ref.watch(teacherRosterProvider).take(4).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.tImportTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    l.tImportManual,
                    icon: LucideIcons.userPlus,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _toast(context, l.tImportManual),
                  ),
                ),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: AppButton(
                    l.tImportCsv,
                    icon: LucideIcons.upload,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _toast(context, l.tImportCsv),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            Text(
              l.tImportChanges,
              style: AppText.label.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: Space.sm),
            for (final name in additions)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: Row(
                  children: [
                    Icon(LucideIcons.check, size: 16, color: colors.success),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Text(
                        '+ $name',
                        style: AppText.body.copyWith(color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: Space.lg),
            AppButton(
              l.tImportApply,
              size: AppButtonSize.lg,
              onPressed: () => _toast(context, l.tImportApply),
            ),
          ],
        ),
      ),
    );
  }
}
