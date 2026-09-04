import 'package:flutter/material.dart';
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
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';

/// S23 — battle result (docs/07 §7.5). The score is the CLASS's; no per-pupil
/// score is shown to anyone. A flat header (no gradient, no confetti) with a
/// neutral badge, the verdict and the class-vs-class score.
class BattleResultScreen extends ConsumerStatefulWidget {
  const BattleResultScreen({super.key, required this.battleId});

  final String battleId;

  @override
  ConsumerState<BattleResultScreen> createState() => _BattleResultScreenState();
}

class _BattleResultScreenState extends ConsumerState<BattleResultScreen> {
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
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.xl, Space.gutter, Space.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      child: Column(
        children: [
          _badge(context),
          const SizedBox(height: Space.md),
          Text(title,
              textAlign: TextAlign.center,
              style: AppText.h1.copyWith(color: colors.textPrimary)),
          const SizedBox(height: Space.xs),
          Text('$myClass — $oppClass',
              textAlign: TextAlign.center,
              style: AppText.bodySm.copyWith(color: colors.textSecondary)),
          const SizedBox(height: Space.md),
          _scoreLine(context),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context) {
    final colors = context.colors;
    final icon = switch (_status) {
      BattleStatus.win => LucideIcons.trophy,
      BattleStatus.draw => LucideIcons.swords,
      BattleStatus.lose => LucideIcons.shield,
    };
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.textPrimary, size: 32),
    );
  }

  Widget _scoreLine(BuildContext context) {
    final colors = context.colors;
    final base = AppText.numeric.copyWith(fontSize: 24);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          style: base.copyWith(color: colors.textPrimary),
          children: [
            TextSpan(text: '$_classScore'),
            TextSpan(
                text: '  —  ',
                style: base.copyWith(color: colors.textTertiary)),
            TextSpan(
                text: '$_opponentScore',
                style: base.copyWith(color: colors.textSecondary)),
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
    // Thin flat bar: the class's share fills blue over a grey track.
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: colors.skeleton)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction.clamp(0.0, 1.0),
              child: ColoredBox(color: colors.primary),
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
        borderRadius: BorderRadius.circular(Radii.hero),
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
