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

const _questionSeconds = 25;

/// S22 — battle play (docs/07 §7.5, motion docs/06 §6.7). One question at a time,
/// a linear timer, no back and no skip. Tapping an option locks it and reveals
/// correctness; a wrong answer shakes twice and highlights the correct option.
class BattlePlayScreen extends ConsumerStatefulWidget {
  const BattlePlayScreen({super.key, required this.battleId});

  final String battleId;

  @override
  ConsumerState<BattlePlayScreen> createState() => _BattlePlayScreenState();
}

class _BattlePlayScreenState extends ConsumerState<BattlePlayScreen>
    with TickerProviderStateMixin {
  late final AnimationController _timer;
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _timer = AnimationController(
        vsync: this, duration: const Duration(seconds: _questionSeconds))
      ..addListener(_onTick)
      ..addStatusListener(_onTimerStatus);
    _shake = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    WidgetsBinding.instance.addPostFrameCallback((_) => _timer.forward());
  }

  void _onTick() {
    // Rebuild for the bar; a setState guard keeps it cheap enough for 60fps.
    if (mounted) setState(() {});
  }

  void _onTimerStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed &&
        !ref.read(battleSessionProvider).revealed) {
      ref.read(battleSessionProvider.notifier).lockTimeout();
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _select(int i, int correct) {
    _timer.stop();
    ref.read(battleSessionProvider.notifier).select(i);
    if (i == correct) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.lightImpact();
      _shake.forward(from: 0);
    }
  }

  void _next() {
    ref.read(battleSessionProvider.notifier).advance();
    if (!ref.read(battleSessionProvider).finished) {
      _timer.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final session = ref.watch(battleSessionProvider);
    final notifier = ref.read(battleSessionProvider.notifier);

    if (session.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted)
          context.pushReplacement('/battle/${widget.battleId}/result');
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final q = notifier.current;
    if (q == null) return const Scaffold(body: SizedBox.shrink());

    final total = notifier.total;
    final revealed = session.revealed;
    final selected = session.answers[session.index];
    final remaining = (1 - _timer.value) * _questionSeconds;
    final timerColor = remaining <= 5 ? colors.warning : colors.primary;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Space.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.chip),
                        child: LinearProgressIndicator(
                          value: (1 - _timer.value).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: colors.border,
                          valueColor: AlwaysStoppedAnimation(timerColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Text('${session.index + 1}/$total',
                        style: AppText.numeric
                            .copyWith(color: colors.textSecondary)),
                  ],
                ),
                const SizedBox(height: Space.xl),
                // Question enters with a fade + rise on each new index.
                AnimatedSwitcher(
                  duration: motionOf(context, Motion.base),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position:
                          Tween(begin: const Offset(0, 0.06), end: Offset.zero)
                              .animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    q.stem,
                    key: ValueKey(q.id),
                    style: AppText.h2.copyWith(color: colors.textPrimary),
                  ),
                ),
                const SizedBox(height: Space.xl),
                for (var i = 0; i < q.options.length; i++)
                  _option(context, l, i, q.options[i], q.correctIndex, selected,
                      revealed),
                const Spacer(),
                if (revealed)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.textOnPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.control)),
                      ),
                      onPressed: _next,
                      child: Text(l.actionContinue,
                          style: AppText.bodyStrong
                              .copyWith(color: colors.textOnPrimary)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(BuildContext context, AppL10n l, int i, String text,
      int correct, int? selected, bool revealed) {
    final colors = context.colors;
    Color border = colors.border;
    Color bg = colors.surface;
    double width = Stroke.hairline;

    if (!revealed) {
      if (selected == i) {
        border = colors.primary;
        bg = colors.primarySubtle;
        width = Stroke.focus;
      }
    } else {
      if (i == correct) {
        border = colors.success;
        bg = colors.successSubtle;
        width = Stroke.focus;
      } else if (i == selected) {
        border = colors.danger;
        bg = colors.dangerSubtle;
        width = Stroke.focus;
      }
    }

    final letter = String.fromCharCode(65 + i); // A, B, C, D

    Widget row = AnimatedContainer(
      duration: motionOf(context, Motion.fast),
      curve: Motion.press,
      margin: const EdgeInsets.only(bottom: Space.sm),
      constraints: const BoxConstraints(minHeight: 56),
      padding:
          const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: width),
        borderRadius: BorderRadius.circular(Radii.control),
      ),
      child: Row(
        children: [
          Text('$letter  ',
              style: AppText.bodyStrong.copyWith(color: colors.textSecondary)),
          Expanded(
              child: Text(text,
                  style: AppText.body.copyWith(color: colors.textPrimary))),
          if (revealed && i == correct)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1),
              duration: motionOf(context, Motion.base),
              curve: Motion.enter,
              builder: (_, s, child) => Transform.scale(scale: s, child: child),
              child: Icon(LucideIcons.circleCheck,
                  color: colors.success, size: 22),
            ),
          if (revealed && i == selected && i != correct)
            Icon(LucideIcons.circleX, color: colors.danger, size: 22),
        ],
      ),
    );

    // Two short horizontal shakes on the wrong pick.
    if (revealed && i == selected && i != correct) {
      row = AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          final dx =
              math.sin(_shake.value * math.pi * 4) * 6 * (1 - _shake.value);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: row,
      );
    }

    return Semantics(
      button: !revealed,
      label: text,
      child: GestureDetector(
        onTap: revealed ? null : () => _select(i, correct),
        behavior: HitTestBehavior.opaque,
        child: row,
      ),
    );
  }
}
