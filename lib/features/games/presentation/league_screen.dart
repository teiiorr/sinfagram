import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S24 — league table (docs/07 §7.5). Scope switcher (gradient-filled active
/// chip); each row carries a points bar; the viewer's OWN class row is tinted
/// with primary text. Class-level only — no per-pupil data anywhere.
class LeagueScreen extends ConsumerStatefulWidget {
  const LeagueScreen({super.key});

  @override
  ConsumerState<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends ConsumerState<LeagueScreen> {
  LeagueScope _scope = LeagueScope.parallel;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final rows = ref.watch(leagueProvider(_scope));
    final maxPoints =
        rows.isEmpty ? 0 : rows.map((r) => r.points).reduce(math.max);

    return Scaffold(
      appBar: AppBar(title: Text(l.leagueTitle)),
      body: SafeArea(
        child: Column(
          children: [
            _scopeBar(context, l),
            Expanded(
              child: rows.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.trophy,
                      title: l.leagueEmpty,
                      message: '')
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          top: Space.xs, bottom: Space.xxl),
                      itemCount: rows.length,
                      itemBuilder: (context, i) =>
                          _row(context, rows[i], maxPoints, i),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scopeBar(BuildContext context, AppL10n l) {
    final items = <(LeagueScope, String)>[
      (LeagueScope.parallel, l.leagueParallel),
      (LeagueScope.school, l.leagueSchool),
      (LeagueScope.district, l.leagueDistrict),
      (LeagueScope.region, l.leagueRegion),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Row(
        children: [
          for (final (scope, label) in items)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: TapScale(
                onTap: () => setState(() => _scope = scope),
                child: _chip(context, label, _scope == scope),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, bool active) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: motionOf(context, Motion.fast),
      curve: Motion.standard,
      padding: const EdgeInsets.symmetric(
          horizontal: Space.md, vertical: Space.sm + 2),
      decoration: BoxDecoration(
        gradient: active ? AppGradients.primary : null,
        color: active ? null : colors.surface,
        borderRadius: BorderRadius.circular(Radii.control),
        border: active
            ? null
            : Border.all(color: colors.border, width: Stroke.hairline),
        boxShadow: active ? Shadows.card : null,
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(
            color: active ? colors.textOnPrimary : colors.textSecondary),
      ),
    );
  }

  Widget _row(BuildContext context, LeagueRow r, int maxPoints, int index) {
    final colors = context.colors;
    final isOwn = r.isOwn;
    final isFirst = r.rank == 1;
    final rankColor = isOwn
        ? colors.primary
        : (isFirst ? colors.accent : colors.textSecondary);
    final nameColor = isOwn ? colors.primary : colors.textPrimary;
    final pointsColor = isOwn ? colors.primary : colors.textPrimary;
    final fraction =
        maxPoints == 0 ? 0.0 : (r.points / maxPoints).clamp(0.0, 1.0);

    return Reveal(
      index: index,
      rise: Motion.riseSm,
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.xs),
        padding: const EdgeInsets.symmetric(
            horizontal: Space.md, vertical: Space.sm + 4),
        decoration: BoxDecoration(
          color: isOwn ? colors.primarySubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text('${r.rank}',
                  style: AppText.numeric
                      .copyWith(fontSize: 18, color: rankColor)),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.classLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyStrong.copyWith(color: nameColor)),
                  const SizedBox(height: 7),
                  _bar(context, fraction, isOwn),
                ],
              ),
            ),
            const SizedBox(width: Space.md),
            Text('${r.points}',
                style: AppText.numeric
                    .copyWith(fontSize: 18, color: pointsColor)),
          ],
        ),
      ),
    );
  }

  Widget _bar(BuildContext context, double fraction, bool isOwn) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                  color: isOwn ? colors.surface : colors.primarySubtle),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppGradients.league)),
            ),
          ],
        ),
      ),
    );
  }
}
