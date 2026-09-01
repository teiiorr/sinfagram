import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// A single rapid-quiz question. Local, offline demo content only.
class _QuizQuestion {
  const _QuizQuestion(this.stem, this.options, this.correctIndex);
  final String stem;
  final List<String> options;
  final int correctIndex;
}

/// The 10 questions. These are inline DEMO/seed content (like the mock providers
/// in games_controllers.dart), so the Uzbek Latin literals live here rather than
/// in the ARB files — a real quiz would fetch them per session.
const List<_QuizQuestion> _kQuestions = [
  _QuizQuestion('Oʻzbekiston poytaxti qaysi shahar?',
      ['Samarqand', 'Toshkent', 'Buxoro', 'Namangan'], 1),
  _QuizQuestion('7 × 8 nechaga teng?', ['54', '56', '48', '64'], 1),
  _QuizQuestion(
      'Suvning kimyoviy formulasi qanday?', ['CO₂', 'O₂', 'H₂O', 'NaCl'], 2),
  _QuizQuestion('Bir yilda nechta oy bor?', ['10', '11', '12', '13'], 2),
  _QuizQuestion('Quyosh sistemasidagi eng katta sayyora qaysi?',
      ['Yer', 'Mars', 'Yupiter', 'Venera'], 2),
  _QuizQuestion('15 + 27 nechaga teng?', ['42', '32', '41', '52'], 0),
  _QuizQuestion('Fransiya poytaxti qaysi shahar?',
      ['London', 'Berlin', 'Parij', 'Rim'], 2),
  _QuizQuestion('Magnit strelkasi doim qaysi tomonni koʻrsatadi?',
      ['Shimol', 'Janub', 'Sharq', 'Gʻarb'], 0),
  _QuizQuestion('Oʻsimliklar kislorodni qaysi jarayonda ishlab chiqaradi?',
      ['Fotosintez', 'Nafas olish', 'Bugʻlanish', 'Erish'], 0),
  _QuizQuestion('100 ni 4 ga boʻlsak nechaga teng?', ['20', '25', '40', '24'], 1),
];

enum _Phase { intro, playing, result }

/// A solo, offline, 10-question rapid quiz (docs/07 §7.5 — variety alongside the
/// class battle and league). No network, no images, class-neutral: it is a warm-
/// up, not a graded score. Colourful cards with a green/red answer flash.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  _Phase _phase = _Phase.intro;
  int _index = 0;
  int _score = 0;
  int? _selected; // chosen option for the current question, null until answered

  int get _total => _kQuestions.length;
  bool get _answered => _selected != null;

  void _start() => setState(() {
        _phase = _Phase.playing;
        _index = 0;
        _score = 0;
        _selected = null;
      });

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      if (i == _kQuestions[_index].correctIndex) _score++;
    });
  }

  void _next() {
    if (!_answered) return;
    setState(() {
      if (_index >= _total - 1) {
        _phase = _Phase.result;
      } else {
        _index++;
        _selected = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.gamesQuiz)),
      body: SafeArea(
        child: switch (_phase) {
          _Phase.intro => _intro(context, l),
          _Phase.playing => _playing(context, l),
          _Phase.result => _result(context, l),
        },
      ),
    );
  }

  // ---------------- Intro ----------------

  Widget _intro(BuildContext context, AppL10n l) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Space.gutter),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Reveal(
                index: 0,
                child: const IconTile(LucideIcons.brain,
                    color: AppAccents.violet, size: 96)),
            const SizedBox(height: Space.lg),
            Reveal(
              index: 1,
              child: Text(l.gamesQuiz,
                  textAlign: TextAlign.center,
                  style: AppText.h1.copyWith(color: colors.textPrimary)),
            ),
            const SizedBox(height: Space.xs),
            Reveal(
              index: 2,
              child: Text(l.gamesQuizDesc,
                  textAlign: TextAlign.center,
                  style: AppText.body.copyWith(color: colors.textSecondary)),
            ),
            const SizedBox(height: Space.xl),
            Reveal(
              index: 3,
              child: AppButton(l.gamesQuizStart,
                  size: AppButtonSize.lg,
                  icon: LucideIcons.zap,
                  onPressed: _start),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Playing ----------------

  Widget _playing(BuildContext context, AppL10n l) {
    final colors = context.colors;
    final q = _kQuestions[_index];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.md, Space.gutter, Space.xxl),
      children: [
        // Progress + running score.
        Row(
          children: [
            Text('${_index + 1} / $_total',
                style: AppText.numeric.copyWith(color: colors.textSecondary)),
            const Spacer(),
            AppChip('${l.gamesScore}: $_score',
                variant: AppChipVariant.primary, icon: LucideIcons.target),
          ],
        ),
        const SizedBox(height: Space.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.chip),
          child: LinearProgressIndicator(
            value: (_index + 1) / _total,
            minHeight: 8,
            backgroundColor: colors.border,
            valueColor: AlwaysStoppedAnimation(colors.primary),
          ),
        ),
        const SizedBox(height: Space.lg),

        // Question stem.
        Reveal(
          key: ValueKey('stem-$_index'),
          index: 0,
          child: AppCard(
            padding: const EdgeInsets.all(Space.lg),
            child: Text(q.stem,
                style: AppText.h1.copyWith(color: colors.textPrimary)),
          ),
        ),
        const SizedBox(height: Space.lg),

        // Options.
        for (var i = 0; i < q.options.length; i++) ...[
          Reveal(
            key: ValueKey('opt-$_index-$i'),
            index: i + 1,
            child: _OptionTile(
              letter: String.fromCharCode(65 + i), // A, B, C, D
              label: q.options[i],
              status: _statusFor(i, q.correctIndex),
              onTap: _answered ? null : () => _select(i),
            ),
          ),
          const SizedBox(height: Space.sm),
        ],

        // Advance.
        if (_answered) ...[
          const SizedBox(height: Space.sm),
          Reveal(
            key: ValueKey('next-$_index'),
            child: AppButton(l.gamesQuizNext,
                size: AppButtonSize.lg,
                icon: LucideIcons.arrowRight,
                onPressed: _next),
          ),
        ],
      ],
    );
  }

  _OptStatus _statusFor(int i, int correctIndex) {
    if (!_answered) return _OptStatus.idle;
    if (i == correctIndex) return _OptStatus.correct;
    if (i == _selected) return _OptStatus.wrong;
    return _OptStatus.muted;
  }

  // ---------------- Result ----------------

  Widget _result(BuildContext context, AppL10n l) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(Space.gutter),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Reveal(
                index: 0,
                child: const IconTile(LucideIcons.partyPopper,
                    color: AppAccents.amber, size: 96)),
            const SizedBox(height: Space.lg),
            Reveal(
              index: 1,
              child: Text(l.gamesQuizResult,
                  textAlign: TextAlign.center,
                  style: AppText.h1.copyWith(color: colors.textPrimary)),
            ),
            const SizedBox(height: Space.md),
            Reveal(
              index: 2,
              child: Text('$_score / $_total',
                  style: AppText.display
                      .copyWith(color: colors.primary, fontSize: 44)),
            ),
            const SizedBox(height: Space.xs),
            Reveal(
              index: 3,
              child: Text(l.gamesScore,
                  style: AppText.bodySm.copyWith(color: colors.textSecondary)),
            ),
            const SizedBox(height: Space.xl),
            Reveal(
              index: 4,
              child: AppButton(l.gamesQuizAgain,
                  size: AppButtonSize.lg,
                  icon: LucideIcons.rotateCcw,
                  onPressed: _start),
            ),
          ],
        ),
      ),
    );
  }
}

/// Visual state of an option tile after (or before) the answer is locked.
enum _OptStatus { idle, correct, wrong, muted }

/// A big, tappable answer tile with a lettered badge. On lock it flashes green
/// (correct) or red (the wrong choice); untouched options fade back.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.label,
    required this.status,
    required this.onTap,
  });

  final String letter;
  final String label;
  final _OptStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (Color bg, Color border, Color fg, IconData? trailing) =
        switch (status) {
      _OptStatus.idle => (
          colors.surface,
          colors.border,
          colors.textPrimary,
          null
        ),
      _OptStatus.correct => (
          colors.success,
          colors.success,
          colors.textOnPrimary,
          LucideIcons.check
        ),
      _OptStatus.wrong => (
          colors.danger,
          colors.danger,
          colors.textOnPrimary,
          LucideIcons.x
        ),
      _OptStatus.muted => (
          colors.surface,
          colors.border,
          colors.textTertiary,
          null
        ),
    };

    final filled = status == _OptStatus.correct || status == _OptStatus.wrong;

    final tile = AnimatedContainer(
      duration: motionOf(context, Motion.fast),
      curve: Motion.enter,
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: border, width: Stroke.hairline),
        boxShadow: status == _OptStatus.idle ? Shadows.card : null,
      ),
      child: Row(
        children: [
          // Lettered badge (hidden once the tile is filled — the icon takes over).
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filled
                  ? colors.textOnPrimary.withValues(alpha: 0.22)
                  : colors.primarySubtle,
              borderRadius: BorderRadius.circular(Radii.chip),
            ),
            child: Text(letter,
                style: AppText.label
                    .copyWith(color: filled ? colors.textOnPrimary : colors.primary)),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(label,
                style: AppText.bodyStrong.copyWith(color: fg)),
          ),
          if (trailing != null) ...[
            const SizedBox(width: Space.sm),
            Icon(trailing, size: 22, color: fg),
          ],
        ],
      ),
    );

    // Opacity(mute) is compositing-only; keeps untouched options recessive.
    final content = status == _OptStatus.muted
        ? Opacity(opacity: 0.55, child: tile)
        : tile;

    return TapScale(onTap: onTap, child: content);
  }
}
