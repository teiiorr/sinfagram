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
/// up, not a graded score. Options flash green/red on lock, a trophy caps the run.
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
  bool get _isLast => _index >= _total - 1;

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
      if (_isLast) {
        _phase = _Phase.result;
      } else {
        _index++;
        _selected = null;
      }
    });
  }

  void _close() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: SafeArea(
        child: switch (_phase) {
          _Phase.intro => _intro(context, l),
          _Phase.playing => _playing(context, l),
          _Phase.result => _result(context, l),
        },
      ),
    );
  }

  // Close (X) + optional progress label ("Savol 3 / 10", tabular figures).
  Widget _header(BuildContext context, AppL10n l, {String? progress}) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Space.sm, Space.sm, Space.gutter, Space.sm),
      child: Row(
        children: [
          _CloseButton(onTap: _close, label: l.gamesQuizClose),
          const Spacer(),
          if (progress != null)
            Text(progress,
                style: AppText.numeric.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }

  // ---------------- Intro ----------------

  Widget _intro(BuildContext context, AppL10n l) {
    final colors = context.colors;
    return Column(
      children: [
        _header(context, l),
        Expanded(
          child: Padding(
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
                        style:
                            AppText.body.copyWith(color: colors.textSecondary)),
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
          ),
        ),
      ],
    );
  }

  // ---------------- Playing ----------------

  Widget _playing(BuildContext context, AppL10n l) {
    final colors = context.colors;
    final q = _kQuestions[_index];

    return Column(
      children: [
        _header(context, l,
            progress: '${l.gamesQuizQuestion} ${_index + 1} / $_total'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                Space.gutter, Space.sm, Space.gutter, Space.xxl),
            children: [
              // Question stem.
              Reveal(
                key: ValueKey('stem-$_index'),
                index: 0,
                child: Text(q.stem,
                    style: AppText.h1
                        .copyWith(fontSize: 24, color: colors.textPrimary)),
              ),
              const SizedBox(height: Space.lg),

              // Options.
              for (var i = 0; i < q.options.length; i++) ...[
                Reveal(
                  key: ValueKey('opt-$_index-$i'),
                  index: i + 1,
                  child: _OptionTile(
                    label: q.options[i],
                    status: _statusFor(i, q.correctIndex),
                    onTap: _answered ? null : () => _select(i),
                  ),
                ),
                const SizedBox(height: Space.sm),
              ],

              // Advance — "Keyingi" mid-run, "Natija" on the last question.
              if (_answered) ...[
                const SizedBox(height: Space.sm),
                Reveal(
                  key: ValueKey('next-$_index'),
                  child: AppButton(
                      _isLast ? l.gamesQuizResult : l.gamesQuizNext,
                      size: AppButtonSize.lg,
                      icon: _isLast ? LucideIcons.trophy : LucideIcons.arrowRight,
                      onPressed: _next),
                ),
              ],
            ],
          ),
        ),
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
    // Verdict is inline demo copy (like the question content) — a friendly line,
    // not a graded label.
    final verdict = _score >= 8
        ? 'Ajoyib natija!'
        : _score >= 4
            ? 'Yaxshi ish!'
            : 'Yana urinib koʻring';

    return Padding(
      padding: const EdgeInsets.all(Space.gutter),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient trophy tile — the reward moment.
            Reveal(
              index: 0,
              child: Container(
                width: 98,
                height: 98,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(Radii.card),
                  boxShadow: Shadows.lift,
                ),
                child: const Icon(LucideIcons.trophy,
                    color: Colors.white, size: 46),
              ),
            ),
            const SizedBox(height: Space.lg),
            Reveal(
              index: 1,
              child: Text(verdict,
                  textAlign: TextAlign.center,
                  style: AppText.h1.copyWith(color: colors.textPrimary)),
            ),
            const SizedBox(height: Space.sm),
            Reveal(
              index: 2,
              child: Text(l.gamesQuizResult,
                  textAlign: TextAlign.center,
                  style: AppText.bodySm.copyWith(color: colors.textSecondary)),
            ),
            const SizedBox(height: Space.xs),
            Reveal(
              index: 3,
              child: Text('$_score / $_total',
                  style: AppText.numeric
                      .copyWith(fontSize: 46, color: colors.primary)),
            ),
            const SizedBox(height: Space.xl),
            Reveal(
              index: 4,
              child: AppButton(l.gamesQuizAgain,
                  size: AppButtonSize.lg,
                  icon: LucideIcons.rotateCcw,
                  onPressed: _start),
            ),
            const SizedBox(height: Space.sm),
            Reveal(
              index: 5,
              child: AppButton(l.gamesQuizClose,
                  size: AppButtonSize.lg,
                  variant: AppButtonVariant.secondary,
                  onPressed: _close),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small rounded close (X) control — surface fill, hairline border, bouncy tap.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      child: TapScale(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(Radii.control),
            border:
                Border.all(color: colors.borderStrong, width: Stroke.hairline),
          ),
          child: Icon(LucideIcons.x, size: 20, color: colors.textSecondary),
        ),
      ),
    );
  }
}

/// Visual state of an option tile after (or before) the answer is locked.
enum _OptStatus { idle, correct, wrong, muted }

/// A full-width answer button. Rests on surface + a strong hairline; on lock the
/// correct choice fills solid green (white text) and a wrong pick fills red, both
/// over a 220 ms colour tween. Untouched options fade back to 55%.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.status,
    required this.onTap,
  });

  final String label;
  final _OptStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Deliberate 220 ms colour transition (design handoff); honours reduce-motion.
    final dur = motionOf(context, const Duration(milliseconds: 220));

    final (Color bg, Color border, Color fg, IconData? trailing) =
        switch (status) {
      _OptStatus.idle => (
          colors.surface,
          colors.borderStrong,
          colors.textPrimary,
          null,
        ),
      _OptStatus.correct => (
          colors.success,
          colors.success,
          colors.textOnPrimary,
          LucideIcons.check,
        ),
      _OptStatus.wrong => (
          colors.danger,
          colors.danger,
          colors.textOnPrimary,
          LucideIcons.x,
        ),
      // Muted keeps the resting look; the enclosing opacity recedes it.
      _OptStatus.muted => (
          colors.surface,
          colors.borderStrong,
          colors.textPrimary,
          null,
        ),
    };

    final tile = AnimatedContainer(
      duration: dur,
      curve: Motion.standard,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: Space.md, vertical: Space.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.control),
        border: Border.all(color: border, width: Stroke.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: dur,
              curve: Motion.standard,
              style: AppText.body.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600, color: fg),
              child: Text(label),
            ),
          ),
          const SizedBox(width: Space.sm),
          // Reserve the trailing slot so the label never shifts; the tick/cross
          // fades in only once the answer is locked.
          SizedBox(
            width: 22,
            height: 22,
            child: AnimatedOpacity(
              opacity: trailing == null ? 0 : 1,
              duration: dur,
              curve: Motion.standard,
              child: Icon(trailing ?? LucideIcons.check, size: 20, color: fg),
            ),
          ),
        ],
      ),
    );

    // AnimatedOpacity(mute) is compositing-only; keeps untouched options recessive.
    final content = AnimatedOpacity(
      opacity: status == _OptStatus.muted ? 0.55 : 1,
      duration: dur,
      curve: Motion.standard,
      child: tile,
    );

    return TapScale(onTap: onTap, child: content);
  }
}
