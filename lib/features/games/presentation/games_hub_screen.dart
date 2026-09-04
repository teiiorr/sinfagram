import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';

/// S20 — games hub (docs/07 §7.5). The modes a pupil can play, presented as a
/// plain list of flat rows: a class-vs-class battle, the league standings, a
/// solo rapid quiz and the weekly challenge. No coloured cards, no gradients —
/// a neutral glyph, a title and a short line, each row leading to its route.
class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final battle = ref.watch(activeBattleProvider);
    final daysLeft = ref.watch(challengeDaysLeftProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            Text(l.gamesHubTitle,
                style: AppText.h1.copyWith(color: colors.textPrimary)),
            const SizedBox(height: Space.xs),
            Text(l.gamesHubLead,
                style: AppText.bodySm.copyWith(color: colors.textSecondary)),
            const SizedBox(height: Space.lg),

            // 1 — Sinf bellashuvi → the real battle lobby (or the league when
            // no battle is scheduled).
            _GameRow(
              icon: LucideIcons.swords,
              title: l.gamesBattle,
              desc: l.gamesBattleDesc,
              onTap: () => context
                  .push(battle != null ? '/battle/${battle.id}' : '/league'),
            ),
            const SizedBox(height: Space.sm),

            // 2 — Reyting → league standings.
            _GameRow(
              icon: LucideIcons.trophy,
              title: l.gamesLeague,
              desc: l.gamesLeagueDesc,
              onTap: () => context.push('/league'),
            ),
            const SizedBox(height: Space.sm),

            // 3 — Tezkor viktorina → solo rapid quiz.
            _GameRow(
              icon: LucideIcons.lightbulb,
              title: l.gamesQuiz,
              desc: l.gamesQuizDesc,
              onTap: () => context.push('/quiz'),
            ),
            const SizedBox(height: Space.sm),

            // 4 — Haftalik chaqiriq → weekly challenge.
            _GameRow(
              icon: LucideIcons.sparkles,
              title: l.gameChallengeSection,
              desc: l.gameDaysLeft(daysLeft),
              onTap: () => context.push('/challenge'),
            ),
          ],
        ),
      ),
    );
  }
}

/// One flat mode row: surface fill, a hairline border and an 8 px radius, a
/// neutral 24 px glyph, the title, a short line and a chevron. Presses fade
/// (TapScale). Not a card — no shadow, no gradient.
class _GameRow extends StatelessWidget {
  const _GameRow({
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: title,
      child: TapScale(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(Radii.hero),
            border: Border.all(color: colors.border, width: Stroke.hairline),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: colors.textPrimary),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppText.bodyStrong
                            .copyWith(color: colors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(desc,
                        style: AppText.bodySm
                            .copyWith(color: colors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              Icon(LucideIcons.chevronRight,
                  size: 20, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
