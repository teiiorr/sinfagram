import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/help/application/help_controller.dart';
import 'package:sinfagram/features/help/domain/help.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

enum _HelpFilter { all, waiting, closed }

/// S13 — help board (docs/07 §7.4). Segmented filter, question cards, and a FAB
/// to ask. No fabricated activity: an empty board says so.
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  _HelpFilter _filter = _HelpFilter.all;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final all = ref.watch(helpBoardProvider);
    final questions = switch (_filter) {
      _HelpFilter.all => all,
      _HelpFilter.waiting => all.where((q) => !q.isResolved).toList(),
      _HelpFilter.closed => all.where((q) => q.isResolved).toList(),
    };

    return Scaffold(
      appBar: AppBar(title: Text(l.helpTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAsk(context, l),
        icon: const Icon(LucideIcons.plus),
        label: Text(l.helpAsk),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _filters(context, l),
            Expanded(
              child: questions.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.messageCircleQuestion,
                      title: l.helpEmpty,
                      message: '')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                          Space.gutter, Space.sm, Space.gutter, Space.xxl),
                      itemCount: questions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: Space.sm),
                      itemBuilder: (context, i) =>
                          _questionCard(context, l, questions[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters(BuildContext context, AppL10n l) {
    final colors = context.colors;
    Widget seg(String label, _HelpFilter value) {
      final selected = _filter == value;
      return Padding(
        padding: const EdgeInsets.only(right: Space.sm),
        child: GestureDetector(
          onTap: () => setState(() => _filter = value),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Space.md, vertical: Space.sm),
            decoration: BoxDecoration(
              color: selected ? colors.primarySubtle : colors.surface,
              borderRadius: BorderRadius.circular(Radii.control),
              border: Border.all(
                  color: selected ? colors.primary : colors.border,
                  width: Stroke.hairline),
            ),
            child: Text(label,
                style: AppText.label.copyWith(
                    color: selected ? colors.primary : colors.textSecondary)),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Row(children: [
        seg(l.helpFilterAll, _HelpFilter.all),
        seg(l.helpFilterWaiting, _HelpFilter.waiting),
        seg(l.helpFilterClosed, _HelpFilter.closed),
      ]),
    );
  }

  Widget _questionCard(BuildContext context, AppL10n l, HelpQuestion q) {
    final colors = context.colors;
    return AppCard(
      onTap: () => context.push('/help/${q.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppChip(q.subject, variant: AppChipVariant.primary),
              const Spacer(),
              if (q.isResolved)
                AppChip(l.helpBest,
                    variant: AppChipVariant.success, icon: LucideIcons.check),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(q.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary)),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              Icon(LucideIcons.messageCircle, size: 16, color: AppAccents.blue),
              const SizedBox(width: Space.xs),
              Text(l.helpAnswers(q.answerCount),
                  style: AppText.caption.copyWith(color: colors.textSecondary)),
              const Spacer(),
              Text(q.timeLabel,
                  style: AppText.caption.copyWith(color: colors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  void _openAsk(BuildContext context, AppL10n l) {
    final subject = TextEditingController();
    final title = TextEditingController();
    showAppBottomSheet<void>(
      context: context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter,
            MediaQuery.viewInsetsOf(context).bottom + Space.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.helpAskTitle,
                style: AppText.h2.copyWith(color: context.colors.textPrimary)),
            const SizedBox(height: Space.md),
            AppTextField(controller: subject, label: l.helpSubject),
            const SizedBox(height: Space.md),
            AppTextField(
                controller: title, label: l.helpQuestionHint, maxLines: 3),
            const SizedBox(height: Space.lg),
            AppButton(
              l.helpAsk,
              size: AppButtonSize.lg,
              onPressed: () {
                ref.read(helpBoardProvider.notifier).addQuestion(
                      subject.text.trim().isEmpty
                          ? l.helpSubject
                          : subject.text.trim(),
                      title.text,
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
