import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/help/application/help_controller.dart';
import 'package:sinfagram/features/help/domain/help.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S14 — help question detail (docs/07 §7.4). Answers ordered best-first then
/// chronological; the answer composer enforces the 40-char minimum live and the
/// controller enforces it again on submit.
class HelpDetailScreen extends ConsumerStatefulWidget {
  const HelpDetailScreen({super.key, required this.questionId});

  final String questionId;

  @override
  ConsumerState<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends ConsumerState<HelpDetailScreen> {
  final _controller = TextEditingController();
  var _length = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final n = _controller.text.trim().length;
      if (n != _length) setState(() => _length = n);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    ref
        .read(helpBoardProvider.notifier)
        .addAnswer(widget.questionId, _controller.text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    HelpQuestion? q;
    for (final item in ref.watch(helpBoardProvider)) {
      if (item.id == widget.questionId) q = item;
    }

    if (q == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: EmptyState(
                icon: LucideIcons.fileQuestion,
                title: l.emptyTitle,
                message: l.emptyBody)),
      );
    }

    // Best answer first, then the rest in original (chronological) order.
    final answers = [
      ...q.answers.where((a) => a.isBest),
      ...q.answers.where((a) => !a.isBest),
    ];
    final canSend = _length >= kHelpAnswerMinChars;

    return Scaffold(
      appBar: AppBar(
          title:
              Text(l.helpTitle, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.lg, Space.gutter, Space.lg),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppChip(q.subject, variant: AppChipVariant.primary),
                        const SizedBox(height: Space.sm),
                        Text(q.title,
                            style:
                                AppText.h3.copyWith(color: colors.textPrimary)),
                        const SizedBox(height: Space.xs),
                        Text(q.timeLabel,
                            style: AppText.caption
                                .copyWith(color: colors.textTertiary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  Text(l.helpAnswers(q.answerCount),
                      style: AppText.label.copyWith(
                          color: colors.textTertiary, letterSpacing: 0.6)),
                  const SizedBox(height: Space.sm),
                  for (final a in answers) _answer(context, l, q.id, a),
                ],
              ),
            ),
            _composer(context, l, colors, canSend),
          ],
        ),
      ),
    );
  }

  Widget _answer(
      BuildContext context, AppL10n l, String questionId, HelpAnswer a) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(name: a.author, size: 28),
                const SizedBox(width: Space.sm),
                Expanded(
                    child: Text(a.author,
                        style: AppText.bodyStrong
                            .copyWith(color: colors.textPrimary),
                        overflow: TextOverflow.ellipsis)),
                if (a.isBest)
                  AppChip(l.helpBest,
                      variant: AppChipVariant.success, icon: LucideIcons.check),
              ],
            ),
            const SizedBox(height: Space.sm),
            Text(a.body,
                style: AppText.body.copyWith(color: colors.textPrimary)),
            if (!a.isBest) ...[
              const SizedBox(height: Space.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  l.helpMarkBest,
                  variant: AppButtonVariant.ghost,
                  icon: LucideIcons.check,
                  onPressed: () => ref
                      .read(helpBoardProvider.notifier)
                      .markBest(questionId, a.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _composer(
      BuildContext context, AppL10n l, AppColors colors, bool canSend) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
            top: BorderSide(color: colors.border, width: Stroke.hairline)),
      ),
      padding:
          const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.sm, Space.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!canSend && _length > 0)
            Padding(
              padding: const EdgeInsets.only(left: Space.xs, bottom: Space.xs),
              child: Text(l.helpAnswerMin,
                  style: AppText.caption.copyWith(color: colors.warning)),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body.copyWith(color: colors.textPrimary),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: l.helpAnswerHint,
                    hintStyle:
                        AppText.body.copyWith(color: colors.textTertiary),
                  ),
                ),
              ),
              IconButton(
                onPressed: canSend ? _send : null,
                tooltip: l.actionSend,
                icon: Icon(LucideIcons.send,
                    size: 20,
                    color: canSend ? colors.primary : colors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
