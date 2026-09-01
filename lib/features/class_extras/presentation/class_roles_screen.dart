import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/class_extras/application/class_extras_controllers.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// S16 — class roles (docs/07). Read-only: this week's role holders and the
/// rotation order for the weeks to come. No taps, no edits.
class ClassRolesScreen extends ConsumerWidget {
  const ClassRolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final r = ref.watch(classRolesProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(title: Text(l.rolesTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            _sectionHeader(context, l.rolesThisWeek),
            for (final role in r.current) ...[
              _roleCard(context, role),
              const SizedBox(height: Space.sm),
            ],
            const SizedBox(height: Space.lg),
            _sectionHeader(context, l.rolesRotation),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < r.rotation.length; i++)
                    _rotationRow(context, i, r.rotation[i]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Text(
        title,
        style: AppText.label.copyWith(
          color: context.colors.textTertiary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _roleCard(BuildContext context, ClassRole role) {
    final colors = context.colors;
    return AppCard(
      child: Row(
        children: [
          Avatar(name: role.holder, size: 40),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.role,
                  style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: Space.xs),
                Text(
                  role.holder,
                  style: AppText.bodySm.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rotationRow(BuildContext context, int index, String name) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding:
          const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              style: AppText.numeric.copyWith(color: colors.textTertiary),
            ),
          ),
          const SizedBox(width: Space.sm),
          Avatar(name: name, size: 28),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              name,
              style: AppText.body.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
