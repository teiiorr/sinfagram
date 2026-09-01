import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// Opponent classes offered for a scheduled match. Mock server content — literal
/// Latin labels are fine here as they stand in for data, not UI chrome.
const List<String> _opponents = ['7-A', '7-V', '8-A'];

/// Subjects offered for a scheduled match. Mock server content, see above.
const List<String> _subjects = ['Matematika', 'Fizika', 'Ingliz tili'];

/// The single mock time window, non-editable in this stub.
const String _window = 'Juma 10:00–10:30';

/// T08 — teacher match scheduler (docs/07). Pick an opponent class and a subject
/// from segmented controls, review the (mock) time window, and confirm.
class TeacherScheduleScreen extends ConsumerStatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  ConsumerState<TeacherScheduleScreen> createState() =>
      _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends ConsumerState<TeacherScheduleScreen> {
  int _opponentIndex = 0;
  int _subjectIndex = 0;

  void _confirm() {
    final l = AppL10n.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.tScheduled)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(LucideIcons.calendarClock),
        title: Text(l.tScheduleTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            Text(l.tPickOpponent,
                style: AppText.label.copyWith(color: colors.textSecondary)),
            const SizedBox(height: Space.sm),
            _SegmentedControl(
              options: _opponents,
              selectedIndex: _opponentIndex,
              onSelected: (i) => setState(() => _opponentIndex = i),
            ),
            const SizedBox(height: Space.lg),
            Text(l.tPickSubject,
                style: AppText.label.copyWith(color: colors.textSecondary)),
            const SizedBox(height: Space.sm),
            _SegmentedControl(
              options: _subjects,
              selectedIndex: _subjectIndex,
              onSelected: (i) => setState(() => _subjectIndex = i),
            ),
            const SizedBox(height: Space.lg),
            Row(
              children: [
                Expanded(
                  child: Text(l.tPickWindow,
                      style: AppText.body.copyWith(color: colors.textPrimary)),
                ),
                const SizedBox(width: Space.md),
                Text(_window,
                    style: AppText.body.copyWith(color: colors.textSecondary)),
              ],
            ),
            const SizedBox(height: Space.xl),
            AppButton(
              l.tScheduleConfirm,
              icon: LucideIcons.send,
              size: AppButtonSize.lg,
              onPressed: _confirm,
            ),
          ],
        ),
      ),
    );
  }
}

/// A flat, inline segmented control: a row of tappable cells that fill available
/// width. The selected cell reads as [AppColors.primarySubtle] with a primary
/// border; the rest sit on [AppColors.surface] with the resting border.
class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: Space.sm),
          Expanded(
            child: _SegmentCell(
              label: options[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
              colors: colors,
            ),
          ),
        ],
      ],
    );
  }
}

class _SegmentCell extends StatelessWidget {
  const _SegmentCell({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.control),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            horizontal: Space.md, vertical: Space.sm),
        decoration: BoxDecoration(
          color: selected ? colors.primarySubtle : colors.surface,
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: Stroke.hairline,
          ),
          borderRadius: BorderRadius.circular(Radii.control),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.label.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
