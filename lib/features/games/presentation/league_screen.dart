import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/games/application/games_controllers.dart';
import 'package:sinfagram/features/games/domain/game.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// S24 — league table (docs/07 §7.5). Scope switcher; own class row is tinted;
/// rank 1 uses accent text. Class-level only — no per-pupil data anywhere.
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

    return Scaffold(
      appBar: AppBar(title: Text(l.leagueTitle)),
      body: SafeArea(
        child: Column(
          children: [
            _scopeBar(context, l),
            _header(context, l),
            Expanded(
              child: rows.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.trophy,
                      title: l.leagueEmpty,
                      message: '')
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: Space.xxl),
                      itemCount: rows.length,
                      itemBuilder: (context, i) => _row(context, rows[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scopeBar(BuildContext context, AppL10n l) {
    final colors = context.colors;
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
              child: GestureDetector(
                onTap: () => setState(() => _scope = scope),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Space.md, vertical: Space.sm),
                  decoration: BoxDecoration(
                    color:
                        _scope == scope ? colors.primarySubtle : colors.surface,
                    borderRadius: BorderRadius.circular(Radii.control),
                    border: Border.all(
                        color: _scope == scope ? colors.primary : colors.border,
                        width: Stroke.hairline),
                  ),
                  child: Text(label,
                      style: AppText.label.copyWith(
                          color: _scope == scope
                              ? colors.primary
                              : colors.textSecondary)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AppL10n l) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.sm, Space.gutter, Space.xs),
      child: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
              child: Text(l.leagueColClass,
                  style: AppText.caption.copyWith(color: colors.textTertiary))),
          SizedBox(
              width: 56,
              child: Text(l.leagueColPlayed,
                  textAlign: TextAlign.center,
                  style: AppText.caption.copyWith(color: colors.textTertiary))),
          SizedBox(
              width: 56,
              child: Text(l.leagueColPoints,
                  textAlign: TextAlign.end,
                  style: AppText.caption.copyWith(color: colors.textTertiary))),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, LeagueRow r) {
    final colors = context.colors;
    final isFirst = r.rank == 1;
    final rankColor = isFirst ? colors.accent : colors.textSecondary;
    return Container(
      color: r.isOwn ? colors.primarySubtle : null,
      padding: const EdgeInsets.symmetric(
          horizontal: Space.gutter, vertical: Space.sm + 2),
      child: Row(
        children: [
          SizedBox(
              width: 24,
              child: Text('${r.rank}',
                  style: AppText.numeric.copyWith(color: rankColor))),
          _delta(context, r.delta),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(
              r.classLabel,
              style: AppText.body.copyWith(
                color: isFirst ? colors.accent : colors.textPrimary,
                fontWeight: r.isOwn ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
              width: 56,
              child: Text('${r.played}',
                  textAlign: TextAlign.center,
                  style:
                      AppText.numeric.copyWith(color: colors.textSecondary))),
          SizedBox(
              width: 56,
              child: Text('${r.points}',
                  textAlign: TextAlign.end,
                  style: AppText.numeric.copyWith(color: colors.textPrimary))),
        ],
      ),
    );
  }

  Widget _delta(BuildContext context, int delta) {
    final colors = context.colors;
    if (delta == 0) return const SizedBox(width: 16);
    final up = delta > 0;
    return SizedBox(
      width: 16,
      child: Icon(up ? LucideIcons.chevronUp : LucideIcons.chevronDown,
          size: 14, color: up ? colors.success : colors.danger),
    );
  }
}
