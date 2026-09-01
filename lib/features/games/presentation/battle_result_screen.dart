import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/features/games/domain/game.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';

/// S23 — battle result (docs/07 §7.5). The score is the CLASS's; no per-pupil
/// score is shown to anyone. Exactly one celebratory ring fires here on a win
/// (docs/06 §6.9), once per result.
class BattleResultScreen extends ConsumerStatefulWidget {
  const BattleResultScreen({super.key, required this.battleId});

  final String battleId;

  @override
  ConsumerState<BattleResultScreen> createState() => _BattleResultScreenState();
}

class _BattleResultScreenState extends ConsumerState<BattleResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ring;
  late final int _classScore;
  late final int _opponentScore;
  late final BattleStatus _status;

  @override
  void initState() {
    super.initState();
    // Mock aggregation: the class score blends the rest of the class (base) with
    // this device's correct answers. A real result is scored server-side.
    final correct = ref.read(battleSessionProvider.notifier).correctCount;
    _classScore = 40 + correct * 20;
    _opponentScore = 78;
    _status = _classScore > _opponentScore
        ? BattleStatus.win
        : (_classScore < _opponentScore
            ? BattleStatus.lose
            : BattleStatus.draw);

    _ring = AnimationController(vsync: this, duration: Motion.celebrate);
    if (_status == BattleStatus.win) {
      HapticFeedback.mediumImpact();
      WidgetsBinding.instance.addPostFrameCallback((_) => _ring.forward());
    }
  }

  @override
  void dispose() {
    _ring.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final battle = ref.watch(activeBattleProvider);
    final participation = battle == null || battle.classSize == 0
        ? 0.0
        : battle.playedCount / battle.classSize;
    final title = switch (_status) {
      BattleStatus.win => l.battleWin,
      BattleStatus.lose => l.battleLose,
      BattleStatus.draw => l.battleDraw,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l.battleResultTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.lg, Space.gutter, Space.xxl),
          children: [
            Center(
                child: Text(title,
                    style: AppText.h1.copyWith(
                        color: _status == BattleStatus.win
                            ? colors.accent
                            : colors.textPrimary))),
            const SizedBox(height: Space.xl),
            Row(
              children: [
                Expanded(
                    child: _scoreColumn(context, l.battleYourClass, _classScore,
                        own: true)),
                Text('—',
                    style: AppText.h2.copyWith(color: colors.textTertiary)),
                Expanded(
                    child: _scoreColumn(
                        context, l.battleOpponentClass, _opponentScore,
                        own: false)),
              ],
            ),
            const SizedBox(height: Space.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.battleParticipation,
                      style:
                          AppText.label.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: Space.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: LinearProgressIndicator(
                      value: participation,
                      minHeight: 8,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  if (battle != null)
                    Text(l.gamePlayed(battle.playedCount),
                        style: AppText.caption
                            .copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.info, size: 15, color: colors.textTertiary),
                const SizedBox(width: Space.sm),
                Expanded(
                    child: Text(l.battleNoPupilScore,
                        style: AppText.caption
                            .copyWith(color: colors.textSecondary))),
              ],
            ),
            const SizedBox(height: Space.xl),
            AppButton(l.actionContinue,
                size: AppButtonSize.lg, onPressed: () => context.go('/games')),
          ],
        ),
      ),
    );
  }

  Widget _scoreColumn(BuildContext context, String label, int score,
      {required bool own}) {
    final colors = context.colors;
    final showRing = own && _status == BattleStatus.win;
    return Column(
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showRing)
                AnimatedBuilder(
                  animation: _ring,
                  builder: (_, __) => CustomPaint(
                      size: const Size(96, 96),
                      painter: _RingPainter(_ring.value, colors.accent)),
                ),
              Text('$score',
                  style: AppText.display.copyWith(
                      color: own ? colors.textPrimary : colors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(label,
            textAlign: TextAlign.center,
            style: AppText.bodySm.copyWith(color: colors.textSecondary)),
      ],
    );
  }
}

/// A single accent ring that draws itself once (docs/06 §6.9). Nothing loops.
class _RingPainter extends CustomPainter {
  const _RingPainter(this.progress, this.color);
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final rect = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2 - 3);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress.clamp(0.0, 1.0),
        false, paint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}
