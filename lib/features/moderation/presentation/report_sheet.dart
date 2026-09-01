import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// S50 — report modal (docs/07 §7.7, docs/10). Reason radios, optional note, and
/// a plain statement of who will see it. The reporter is never revealed to the
/// reported party. Mock submit for now (a real POST /reports lands with the API).
Future<void> showReportSheet(BuildContext context,
    {required String targetKind, required String targetId}) {
  return showAppBottomSheet<void>(
      context: context, child: const _ReportSheet());
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet();

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  int? _reason;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final reasons = [
      l.reportReasonBullying,
      l.reportReasonOffensive,
      l.reportReasonSpam,
      l.reportReasonOther
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter,
          MediaQuery.viewInsetsOf(context).bottom + Space.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.reportTitle,
              style: AppText.h2.copyWith(color: colors.textPrimary)),
          const SizedBox(height: Space.md),
          for (var i = 0; i < reasons.length; i++)
            _reasonRow(context, i, reasons[i]),
          const SizedBox(height: Space.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.shieldCheck,
                  size: 16, color: colors.textTertiary),
              const SizedBox(width: Space.sm),
              Expanded(
                  child: Text(l.reportWhoSees,
                      style: AppText.caption
                          .copyWith(color: colors.textSecondary))),
            ],
          ),
          const SizedBox(height: Space.lg),
          AppButton(
            l.actionSend,
            size: AppButtonSize.lg,
            variant: AppButtonVariant.danger,
            onPressed: _reason == null
                ? null
                : () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(l.reportSent)));
                  },
          ),
        ],
      ),
    );
  }

  Widget _reasonRow(BuildContext context, int i, String label) {
    final colors = context.colors;
    final selected = _reason == i;
    return InkWell(
      onTap: () => setState(() => _reason = i),
      borderRadius: BorderRadius.circular(Radii.control),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Row(
          children: [
            Icon(
              selected ? LucideIcons.circleCheck : LucideIcons.circle,
              size: 22,
              color: selected ? colors.primary : colors.textTertiary,
            ),
            const SizedBox(width: Space.md),
            Expanded(
                child: Text(label,
                    style: AppText.body.copyWith(color: colors.textPrimary))),
          ],
        ),
      ),
    );
  }
}
