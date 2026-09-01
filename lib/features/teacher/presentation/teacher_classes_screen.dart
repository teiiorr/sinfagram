import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/teacher/application/teacher_controllers.dart';
import 'package:sinfagram/features/teacher/domain/teacher.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';

/// T01 — teacher class list (docs/07 §7.9). Each card: class label, joined /
/// roster size, and an open-cases badge. The home must be readable in seconds.
class TeacherClassesScreen extends ConsumerWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final classes = ref.watch(teacherClassesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tNavClasses)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          itemCount: classes.length,
          separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
          itemBuilder: (context, i) => _classCard(context, l, classes[i]),
        ),
      ),
    );
  }

  Widget _classCard(BuildContext context, AppL10n l, TeacherClass c) {
    final colors = context.colors;
    return AppCard(
      onTap: () => context.push('/teacher/class/${c.id}'),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.primarySubtle,
                borderRadius: BorderRadius.circular(Radii.control)),
            child: Text(c.label,
                style: AppText.bodyStrong.copyWith(color: colors.primary)),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.label,
                    style: AppText.h3.copyWith(color: colors.textPrimary)),
                const SizedBox(height: Space.xs),
                Text(l.tClassJoined(c.joined, c.rosterSize),
                    style:
                        AppText.bodySm.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          if (c.openCases > 0)
            AppChip(l.tOpenCases(c.openCases), variant: AppChipVariant.warning),
        ],
      ),
    );
  }
}
