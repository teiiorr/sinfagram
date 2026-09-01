import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/teacher/application/teacher_controllers.dart';
import 'package:sinfagram/features/teacher/domain/teacher.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// T05 — case inbox (docs/07 §7.9). Open cases, overdue first; overdue rows use
/// warning, never red. An empty inbox is a good state and says so.
class TeacherCasesScreen extends ConsumerWidget {
  const TeacherCasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final all = ref
        .watch(casesProvider)
        .where((c) => c.status == CaseStatus.open)
        .toList()
      ..sort((a, b) => (b.overdue ? 1 : 0).compareTo(a.overdue ? 1 : 0));

    return Scaffold(
      appBar: AppBar(title: Text(l.tNavCases)),
      body: SafeArea(
        child: all.isEmpty
            ? EmptyState(
                icon: LucideIcons.circleCheck,
                title: l.tCasesEmpty,
                message: '')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.md, Space.gutter, Space.xxl),
                itemCount: all.length,
                separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
                itemBuilder: (context, i) => _caseCard(context, l, all[i]),
              ),
      ),
    );
  }

  Widget _caseCard(BuildContext context, AppL10n l, ModerationCase c) {
    final colors = context.colors;
    return AppCard(
      onTap: () => context.push('/teacher/case/${c.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(c.targetSummary,
                      style: AppText.bodyStrong
                          .copyWith(color: colors.textPrimary))),
              if (c.overdue)
                AppChip(l.tCaseOverdue,
                    variant: AppChipVariant.warning, icon: LucideIcons.clock),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(c.reason,
              style: AppText.bodySm.copyWith(color: colors.textSecondary)),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              Icon(LucideIcons.clock,
                  size: 14,
                  color: c.overdue ? colors.warning : colors.textTertiary),
              const SizedBox(width: Space.xs),
              Text(l.tCaseDue(c.dueLabel),
                  style: AppText.caption.copyWith(
                      color: c.overdue ? colors.warning : colors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}
