import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';

/// Scope of an announcement: the teacher's own class, or the whole school.
enum _AnnounceScope { classroom, school }

/// T07 — teacher announcement composer (docs/07). A scope segmented control, a
/// multi-line body, a pin toggle, and a single primary post action that stays
/// disabled until the body has content.
class TeacherAnnounceScreen extends ConsumerStatefulWidget {
  const TeacherAnnounceScreen({super.key});

  @override
  ConsumerState<TeacherAnnounceScreen> createState() =>
      _TeacherAnnounceScreenState();
}

class _TeacherAnnounceScreenState extends ConsumerState<TeacherAnnounceScreen> {
  final TextEditingController _bodyController = TextEditingController();

  _AnnounceScope _scope = _AnnounceScope.classroom;
  bool _pin = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final has = _bodyController.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    _bodyController.removeListener(_handleTextChange);
    _bodyController.dispose();
    super.dispose();
  }

  void _post() {
    final l = AppL10n.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.tAnnouncePosted)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(LucideIcons.megaphone),
        title: Text(l.tAnnounceTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            Text(l.tAnnounceScope,
                style: AppText.label.copyWith(color: colors.textSecondary)),
            const SizedBox(height: Space.sm),
            _SegmentedControl(
              options: [l.tScopeClass, l.tScopeSchool],
              selectedIndex: _scope == _AnnounceScope.classroom ? 0 : 1,
              onSelected: (i) => setState(() => _scope =
                  i == 0 ? _AnnounceScope.classroom : _AnnounceScope.school),
            ),
            const SizedBox(height: Space.lg),
            AppTextField(
              controller: _bodyController,
              label: l.tAnnounceHint,
              maxLines: 5,
            ),
            const SizedBox(height: Space.lg),
            Row(
              children: [
                Expanded(
                  child: Text(l.tAnnouncePin,
                      style: AppText.body.copyWith(color: colors.textPrimary)),
                ),
                Switch(
                  value: _pin,
                  onChanged: (v) => setState(() => _pin = v),
                ),
              ],
            ),
            const SizedBox(height: Space.xl),
            AppButton(
              l.tAnnouncePost,
              icon: LucideIcons.send,
              size: AppButtonSize.lg,
              onPressed: _hasText ? _post : null,
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
