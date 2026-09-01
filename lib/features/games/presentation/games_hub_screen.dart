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
import 'package:sinfagram/shared/motion/motion_widgets.dart';

/// S20 — games hub (docs/07 §7.5). The four modes a pupil can play, each a
/// vivid gradient "sticker" card: a class-vs-class battle, the league
/// standings, a solo rapid quiz and the weekly challenge. The two full-width
/// cards lead the eye; the two solo modes sit half-width beneath them.
class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  // Per-card gradients (design handoff). Built topLeft → bottomRight.
  static const _battleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE0655B), Color(0xFFEB4D8C)],
  );
  static const _leagueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE7A63A), Color(0xFFF2802E)],
  );
  static const _challengeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF12B39B), Color(0xFF1EA7C5)],
  );

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
            Reveal(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.gamesHubTitle,
                      style: AppText.h1.copyWith(color: colors.textPrimary)),
                  const SizedBox(height: Space.xs),
                  Text(l.gamesHubLead,
                      style:
                          AppText.bodySm.copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),

            // 1 — Sinf bellashuvi (full width). Opens the real battle lobby.
            Reveal(
              index: 1,
              child: _StickerCard(
                gradient: _battleGradient,
                shadowColor: const Color(0xFFE0655B),
                icon: LucideIcons.swords,
                title: l.gamesBattle,
                desc: l.gamesBattleDesc,
                chip: 'Matematika · 7-B sinf',
                onTap: () => context.push(
                    battle != null ? '/battle/${battle.id}' : '/league'),
              ),
            ),
            const SizedBox(height: Space.md),

            // 2 — Reyting (full width) → league standings.
            Reveal(
              index: 2,
              child: _StickerCard(
                gradient: _leagueGradient,
                shadowColor: const Color(0xFFE7A63A),
                icon: LucideIcons.trophy,
                title: l.gamesLeague,
                desc: l.gamesLeagueDesc,
                chip: '2-oʻrin · 340 ball',
                onTap: () => context.push('/league'),
              ),
            ),
            const SizedBox(height: Space.md),

            // 3 & 4 — the two solo modes, half-width and equal-height.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Reveal(
                      index: 3,
                      child: _StickerCard(
                        gradient: AppGradients.primary,
                        shadowColor: const Color(0xFF7A5CF0),
                        icon: LucideIcons.lightbulb,
                        title: l.gamesQuiz,
                        desc: l.gamesQuizDesc,
                        onTap: () => context.push('/quiz'),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Reveal(
                      index: 4,
                      child: _StickerCard(
                        gradient: _challengeGradient,
                        shadowColor: const Color(0xFF12B39B),
                        icon: LucideIcons.sparkles,
                        title: l.gameChallengeSection,
                        desc: l.gameDaysLeft(daysLeft),
                        onTap: () => context.push('/challenge'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One gradient "sticker": a vivid card with a soft decorative highlight, a
/// white glyph, a title and a short line, plus an optional status chip. The
/// whole surface bounces on press ([TapScale]) and casts a shadow tinted to its
/// own colour so each mode feels tangible and distinct.
class _StickerCard extends StatelessWidget {
  const _StickerCard({
    required this.gradient,
    required this.shadowColor,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
    this.chip,
  });

  final Gradient gradient;
  final Color shadowColor;
  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback? onTap;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(Radii.hero),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative highlight — a big soft circle peeking from the corner,
            // clipped to the card's rounded rectangle.
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 34, color: Colors.white),
                  const SizedBox(height: Space.md),
                  Text(
                    title,
                    style: AppText.h2.copyWith(color: Colors.white, fontSize: 19),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    desc,
                    style: AppText.bodySm
                        .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                  if (chip != null) ...[
                    const SizedBox(height: Space.md),
                    _CardChip(chip!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A quiet status pill drawn on a gradient card: translucent white fill, white
/// label. (On-gradient, so it can't reuse AppChip's token colours.)
class _CardChip extends StatelessWidget {
  const _CardChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Space.sm, vertical: Space.xs),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(color: Colors.white),
      ),
    );
  }
}
