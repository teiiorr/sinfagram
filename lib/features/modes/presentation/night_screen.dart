import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/app_mode.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// S60 — night mode (docs/07 §7.8). Full screen, no bottom bar, one calm line,
/// the reopen time, and a link to the board. No ticking countdown — a live timer
/// is something to sit and watch.
class NightScreen extends ConsumerWidget {
  const NightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.moon,
                    size: Space.xxl, color: colors.textTertiary),
                const SizedBox(height: Space.lg),
                Text(l.nightTitle,
                    textAlign: TextAlign.center,
                    style: AppText.h1.copyWith(color: colors.textPrimary)),
                const SizedBox(height: Space.sm),
                Text(l.nightBody(nightReopenTime(ref)),
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: colors.textSecondary)),
                const SizedBox(height: Space.xl),
                AppButton(l.nightToBoard,
                    variant: AppButtonVariant.secondary,
                    icon: LucideIcons.clipboardList,
                    onPressed: () => context.go('/board')),
                const SizedBox(height: Space.sm),
                // Demo-only escape: the mode override lives in settings.
                AppButton(l.settingsTitle,
                    variant: AppButtonVariant.ghost,
                    onPressed: () => context.go('/settings')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
