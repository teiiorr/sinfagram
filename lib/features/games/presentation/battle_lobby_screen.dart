import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S21 — battle lobby (docs/07 §7.5). Opponent, subject, participation, and the
/// single start button. The session cannot be paused once begun — stated before
/// the button, not after.
class BattleLobbyScreen extends ConsumerWidget {
  const BattleLobbyScreen({super.key, required this.battleId});

  final String battleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final b = ref.watch(activeBattleProvider);

    if (b == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: EmptyState(
                icon: LucideIcons.swords, title: l.gamesEmpty, message: '')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.gameActiveBattle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _kv(context, l.gameSubject, b.subject)),
                      Expanded(
                          child: _kv(context, l.gameOpponent, b.opponentClass)),
                    ],
                  ),
                  const SizedBox(height: Space.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: LinearProgressIndicator(
                      value: b.classSize == 0 ? 0 : b.playedCount / b.classSize,
                      minHeight: 6,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(l.gamePlayed(b.playedCount),
                      style: AppText.caption
                          .copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.info, size: 16, color: colors.textTertiary),
                const SizedBox(width: Space.sm),
                Expanded(
                    child: Text(l.gameCannotPause,
                        style: AppText.bodySm
                            .copyWith(color: colors.textSecondary))),
              ],
            ),
            const SizedBox(height: Space.lg),
            AppButton(
              l.gameStart,
              size: AppButtonSize.lg,
              icon: LucideIcons.swords,
              onPressed: () {
                ref.read(battleSessionProvider.notifier).restart();
                context.push('/battle/$battleId/play');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: AppText.caption.copyWith(color: colors.textTertiary)),
        const SizedBox(height: 2),
        Text(v, style: AppText.bodyStrong.copyWith(color: colors.textPrimary)),
      ],
    );
  }
}
