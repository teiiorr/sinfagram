import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// One chronicle-admin action row.
class _ChronicleAction {
  const _ChronicleAction(this.icon, this.label);

  final IconData icon;
  final String label;
}

/// T10 — chronicle admin (docs/07). A flat list of the class-chronicle actions
/// a teacher can run. Each is a mock — it reports itself as a SnackBar.
class TeacherChronicleAdminScreen extends ConsumerWidget {
  const TeacherChronicleAdminScreen({super.key});

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    final actions = <_ChronicleAction>[
      _ChronicleAction(LucideIcons.image, l.tSetCover),
      _ChronicleAction(LucideIcons.pin, l.tSeal),
      _ChronicleAction(LucideIcons.upload, l.tExportPdf),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.tChronicleAdmin)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          itemCount: actions.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: Space.sm),
          itemBuilder: (context, index) {
            final action = actions[index];
            return AppCard(
              onTap: () => _toast(context, action.label),
              child: Row(
                children: [
                  IconTile(action.icon,
                      color: AppAccents.forSeed(action.label), size: 44),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Text(
                      action.label,
                      style: AppText.body.copyWith(color: colors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Icon(LucideIcons.chevronRight,
                      size: 20, color: colors.textTertiary),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
