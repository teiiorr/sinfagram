import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/features/games/domain/game.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (reduceMotion(context)) {
          _ring.value = 1;
        } else {
          HapticFeedback.mediumImpact();
          _ring.forward();
        }
      });
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

    // Own class label comes from the standings (the flagged row); opponent from
    // the active battle. Both fall back to the neutral role labels.
    final leagueRows = ref.watch(leagueProvider(LeagueScope.parallel));
    var myClass = l.battleYourClass;
    for (final r in leagueRows) {
      if (r.isOwn) {
        myClass = r.classLabel;
        break;
      }
    }
    final oppClass = battle?.opponentClass ?? l.battleOpponentClass;

    final title = switch (_status) {
      BattleStatus.win => l.battleWin,
      BattleStatus.lose => l.battleLose,
      BattleStatus.draw => l.battleDraw,
    };

    // Per-subject breakdown is server-scored; inline demo rows stand in here.
    const subjects = <(String, int, int)>[
      ('Algebra', 120, 90),
      ('Geometriya', 110, 115),
      ('Mantiqiy masalalar', 110, 100),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.battleResultTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Reveal(index: 0, child: _hero(context, title, myClass, oppClass)),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Space.gutter, Space.lg, Space.gutter, Space.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Reveal(
                    index: 1,
                    rise: Motion.riseSm,
                    child: Text(l.battlePerSubject,
                        style:
                            AppText.h3.copyWith(color: colors.textPrimary)),
                  ),
                  const SizedBox(height: Space.sm + 4),
                  Reveal(
                    index: 2,
                    rise: Motion.riseSm,
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < subjects.length; i++) ...[
                            _subjectRow(context, subjects[i].$1,
                                subjects[i].$2, subjects[i].$3),
                            if (i != subjects.length - 1)
                              const SizedBox(height: Space.md),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.md),
                  Reveal(
                    index: 3,
                    rise: Motion.riseSm,
                    child: _note(context, l.battleNoPupilScore),
                  ),
                  const SizedBox(height: Space.xl),
                  Reveal(
                    index: 4,
                    rise: Motion.riseSm,
                    child: AppButton(l.actionContinue,
                        size: AppButtonSize.lg,
                        onPressed: () => context.go('/games')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Hero -----------------------------------------------------------------

  Widget _hero(
      BuildContext context, String title, String myClass, String oppClass) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.xxl, Space.gutter, Space.xl),
      decoration: const BoxDecoration(
        gradient: AppGradients.battle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _badge(context),
          const SizedBox(height: Space.md),
          Text(title,
              textAlign: TextAlign.center,
              style: AppText.h1.copyWith(color: Colors.white)),
          const SizedBox(height: Space.lg),
          _scoreLine(context, myClass, oppClass),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context) {
    final win = _status == BattleStatus.win;
    final icon = switch (_status) {
      BattleStatus.win => LucideIcons.trophy,
      BattleStatus.draw => LucideIcons.swords,
      BattleStatus.lose => LucideIcons.shield,
    };
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (win)
            AnimatedBuilder(
              animation: _ring,
              builder: (_, __) => CustomPaint(
                  size: const Size(90, 90),
                  painter: _RingPainter(_ring.value, Colors.white)),
            ),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: Stroke.hairline),
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }

  Widget _scoreLine(BuildContext context, String myClass, String oppClass) {
    final base = AppText.numeric.copyWith(fontSize: 38, color: Colors.white);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          style: base,
          children: [
            TextSpan(text: '$myClass  $_classScore'),
            TextSpan(
                text: '  —  ',
                style:
                    base.copyWith(color: Colors.white.withValues(alpha: 0.6))),
            TextSpan(
                text: '$oppClass  $_opponentScore',
                style: base.copyWith(
                    color: Colors.white.withValues(alpha: 0.75))),
          ],
        ),
      ),
    );
  }

  // ---- Below the hero -------------------------------------------------------

  Widget _subjectRow(BuildContext context, String name, int mine, int opp) {
    final colors = context.colors;
    final total = mine + opp;
    final fraction = total == 0 ? 0.5 : mine / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(color: colors.textPrimary)),
            ),
            const SizedBox(width: Space.sm),
            Text('$mine : $opp',
                maxLines: 1,
                softWrap: false,
                style: AppText.numeric
                    .copyWith(fontSize: 14, color: colors.textSecondary)),
          ],
        ),
        const SizedBox(height: Space.sm),
        _subjectBar(context, fraction),
      ],
    );
  }

  Widget _subjectBar(BuildContext context, double fraction) {
    final colors = context.colors;
    final mineFlex = (fraction * 1000).round().clamp(1, 1000);
    final oppFlex = ((1 - fraction) * 1000).round().clamp(1, 1000);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 7,
        child: Row(
          children: [
            Expanded(
              flex: mineFlex,
              child: const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppGradients.league)),
            ),
            Expanded(
              flex: oppFlex,
              child: ColoredBox(color: colors.primarySubtle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _note(BuildContext context, String text) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 16, color: colors.primary),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(text,
                style: AppText.bodySm.copyWith(color: colors.textSecondary)),
          ),
        ],
      ),
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
