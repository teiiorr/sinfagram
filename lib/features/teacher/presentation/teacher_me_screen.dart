import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// Teacher "Men" tab — profile and the shared settings/about/sign-out links.
class TeacherMeScreen extends ConsumerWidget {
  const TeacherMeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final s = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.navMe)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.lg, Space.gutter, Space.xxl),
          children: [
            Row(
              children: [
                Avatar(name: s?.displayName ?? '', size: 56),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s?.displayName ?? '',
                          style:
                              AppText.h2.copyWith(color: colors.textPrimary)),
                      const SizedBox(height: Space.xs),
                      Text(s?.classLabel ?? '',
                          style: AppText.bodySm
                              .copyWith(color: colors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _row(context, LucideIcons.settings, l.meSettings,
                () => context.push('/settings'),
                accent: AppAccents.blue),
            const SizedBox(height: Space.sm),
            _row(context, LucideIcons.info, l.meAbout,
                () => context.push('/about'),
                accent: AppAccents.cyan),
            const SizedBox(height: Space.sm),
            _row(context, LucideIcons.logOut, l.meSignOut,
                () => ref.read(sessionProvider.notifier).signOut(),
                danger: true),
          ],
        ),
      ),
    );
  }

  Widget _row(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool danger = false, Color accent = AppAccents.blue}) {
    final colors = context.colors;
    final color = danger ? colors.danger : colors.textPrimary;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon, color: danger ? AppAccents.red : accent, size: 44),
          const SizedBox(width: Space.md),
          Expanded(
              child: Text(label, style: AppText.body.copyWith(color: color))),
          Icon(LucideIcons.chevronRight, size: 20, color: colors.textTertiary),
        ],
      ),
    );
  }
}
