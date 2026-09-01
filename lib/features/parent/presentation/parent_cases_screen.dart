import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/parent/application/parent_controllers.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// P03 — complaints involving the child and their outcomes (docs/07 §7.10).
class ParentCasesScreen extends ConsumerWidget {
  const ParentCasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final cases = ref.watch(parentCasesProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.pCases)),
      body: SafeArea(
        child: cases.isEmpty
            ? EmptyState(
                icon: LucideIcons.circleCheck,
                title: l.pCasesEmpty,
                message: '')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.md, Space.gutter, Space.xxl),
                itemCount: cases.length,
                separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
                itemBuilder: (context, i) {
                  final c = cases[i];
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.summary,
                            style: AppText.bodyStrong
                                .copyWith(color: colors.textPrimary)),
                        const SizedBox(height: Space.xs),
                        Text(c.outcome,
                            style: AppText.bodySm
                                .copyWith(color: colors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
