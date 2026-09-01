import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/features/games/domain/game.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S20 — games hub (docs/07 §7.5). A clear menu of what you can play: a
/// class-vs-class battle, the league standings, a solo rapid quiz, and the
/// weekly challenge. Each is one big, colourful, tappable card so a pupil can
/// tell the modes apart at a glance.
class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final battle = ref.watch(activeBattleProvider);
    final league = ref.watch(leagueProvider(LeagueScope.parallel));
    final daysLeft = ref.watch(challengeDaysLeftProvider);

    LeagueRow? own;
    for (final r in league) {
      if (r.isOwn) {
        own = r;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.gamesHubTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            Reveal(
              index: 0,
              child: Text(
                l.gamesHubLead,
                style: AppText.body.copyWith(color: colors.textSecondary),
              ),
            ),
            const SizedBox(height: Space.lg),
            Reveal(
              index: 1,
              child: _HubCard(
                icon: LucideIcons.swords,
                color: AppAccents.red,
                title: l.gamesBattle,
                desc: l.gamesBattleDesc,
                meta: battle != null
                    ? '${battle.subject} · ${battle.opponentClass}'
                    : l.gamesEmpty,
                metaVariant: AppChipVariant.accent,
                onTap: battle != null
                    ? () => context.push('/battle/${battle.id}')
                    : null,
              ),
            ),
            const SizedBox(height: Space.md),
            Reveal(
              index: 2,
              child: _HubCard(
                icon: LucideIcons.trophy,
                color: AppAccents.amber,
                title: l.gamesLeague,
                desc: l.gamesLeagueDesc,
                meta: own != null
                    ? '${l.gameRankValue(own.rank)} · ${l.gamePointsValue(own.points)}'
                    : null,
                metaVariant: AppChipVariant.warning,
                onTap: () => context.push('/league'),
              ),
            ),
            const SizedBox(height: Space.md),
            Reveal(
              index: 3,
              child: _HubCard(
                icon: LucideIcons.brain,
                color: AppAccents.violet,
                title: l.gamesQuiz,
                desc: l.gamesQuizDesc,
                onTap: () => context.push('/quiz'),
              ),
            ),
            const SizedBox(height: Space.md),
            Reveal(
              index: 4,
              child: _HubCard(
                icon: LucideIcons.sparkles,
                color: AppAccents.teal,
                title: l.gameChallengeSection,
                desc: l.gameDaysLeft(daysLeft),
                onTap: () => context.push('/challenge'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One big, colourful entry in the games hub: a vivid [IconTile], a title, a
/// short description and an optional status chip. Inert (greyed chevron) when
/// [onTap] is null.
class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    required this.onTap,
    this.meta,
    this.metaVariant = AppChipVariant.neutral,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  final VoidCallback? onTap;
  final String? meta;
  final AppChipVariant metaVariant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onTap != null;
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconTile(icon, color: color, size: 56),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.h2.copyWith(color: colors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc,
                    style:
                        AppText.bodySm.copyWith(color: colors.textSecondary)),
                if (meta != null) ...[
                  const SizedBox(height: Space.sm),
                  AppChip(meta!, variant: metaVariant),
                ],
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          Icon(LucideIcons.chevronRight,
              size: 20,
              color: enabled ? colors.textTertiary : colors.border),
        ],
      ),
    );
  }
}
