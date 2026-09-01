import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/teacher/application/teacher_controllers.dart';
import 'package:sinfagram/features/teacher/domain/teacher.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// T06 — case detail (docs/07 §7.9). Evidence, history, and the four level-1
/// actions, each of which requires a one-line note before it applies.
class TeacherCaseDetailScreen extends ConsumerWidget {
  const TeacherCaseDetailScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    ModerationCase? item;
    for (final c in ref.watch(casesProvider)) {
      if (c.id == caseId) item = c;
    }

    if (item == null || item.status == CaseStatus.resolved) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: EmptyState(
                icon: LucideIcons.circleCheck,
                title: l.tCaseResolved,
                message: '')),
      );
    }
    final c = item;

    return Scaffold(
      appBar: AppBar(
          title: Text(c.targetSummary,
              maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.reason,
                      style: AppText.h3.copyWith(color: colors.textPrimary)),
                  const SizedBox(height: Space.xs),
                  Row(children: [
                    Icon(LucideIcons.shieldCheck,
                        size: 14, color: colors.textTertiary),
                    const SizedBox(width: Space.xs),
                    Expanded(
                        child: Text(l.tCaseAnonymous,
                            style: AppText.caption
                                .copyWith(color: colors.textSecondary))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            _section(context, l.tCaseEvidence),
            AppCard(
                child: Text(c.evidence,
                    style: AppText.body.copyWith(color: colors.textPrimary))),
            if (c.history.isNotEmpty) ...[
              const SizedBox(height: Space.md),
              _section(context, l.tCaseHistory),
              for (final h in c.history)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.xs),
                  child: Text('• $h',
                      style:
                          AppText.bodySm.copyWith(color: colors.textSecondary)),
                ),
            ],
            const SizedBox(height: Space.lg),
            AppButton(l.tCaseActionHide,
                size: AppButtonSize.lg,
                variant: AppButtonVariant.danger,
                icon: LucideIcons.eyeOff,
                onPressed: () => _act(context, ref, l, c.id, CaseAction.hide)),
            const SizedBox(height: Space.sm),
            AppButton(l.tCaseActionMute,
                size: AppButtonSize.lg,
                variant: AppButtonVariant.secondary,
                icon: LucideIcons.volumeX,
                onPressed: () => _act(context, ref, l, c.id, CaseAction.mute)),
            const SizedBox(height: Space.sm),
            AppButton(l.tCaseActionEscalate,
                size: AppButtonSize.lg,
                variant: AppButtonVariant.secondary,
                icon: LucideIcons.arrowUp,
                onPressed: () =>
                    _act(context, ref, l, c.id, CaseAction.escalate)),
            const SizedBox(height: Space.sm),
            AppButton(l.tCaseActionDismiss,
                size: AppButtonSize.lg,
                variant: AppButtonVariant.ghost,
                icon: LucideIcons.x,
                onPressed: () =>
                    _act(context, ref, l, c.id, CaseAction.dismiss)),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(bottom: Space.sm),
        child: Text(title.toUpperCase(),
            style: AppText.label.copyWith(
                color: context.colors.textTertiary, letterSpacing: 0.6)),
      );

  void _act(BuildContext context, WidgetRef ref, AppL10n l, String caseId,
      CaseAction action) {
    showAppBottomSheet<void>(
      context: context,
      child: _NoteSheet(
        hint: l.tCaseNoteHint,
        submitLabel: l.actionSend,
        onSubmit: (note) {
          ref.read(casesProvider.notifier).act(caseId, action, note);
          Navigator.of(context).pop(); // close the sheet
          Navigator.of(context).pop(); // return to the inbox
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.tCaseResolved)));
        },
      ),
    );
  }
}

class _NoteSheet extends StatefulWidget {
  const _NoteSheet(
      {required this.hint, required this.submitLabel, required this.onSubmit});
  final String hint;
  final String submitLabel;
  final void Function(String note) onSubmit;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  final _controller = TextEditingController();
  var _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final can = _controller.text.trim().isNotEmpty;
      if (can != _canSend) setState(() => _canSend = can);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter,
          MediaQuery.viewInsetsOf(context).bottom + Space.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            style: AppText.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppText.body.copyWith(color: colors.textTertiary),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.control),
                  borderSide: BorderSide(color: colors.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.control),
                  borderSide: BorderSide(color: colors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.control),
                  borderSide:
                      BorderSide(color: colors.primary, width: Stroke.focus)),
            ),
          ),
          const SizedBox(height: Space.md),
          AppButton(widget.submitLabel,
              size: AppButtonSize.lg,
              onPressed:
                  _canSend ? () => widget.onSubmit(_controller.text) : null),
        ],
      ),
    );
  }
}
