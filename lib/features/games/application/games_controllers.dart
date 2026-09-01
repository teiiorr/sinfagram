import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/game.dart';

/// The active battle, or null when none is scheduled. Mock (client-first);
/// content (stems/options) is server data, so its strings live here, not in ARB.
final activeBattleProvider = Provider<Battle?>((ref) {
  return const Battle(
    id: 'b1',
    opponentClass: '7-A',
    subject: 'Matematika',
    playedCount: 14,
    classSize: 28,
    questions: [
      Question(
        id: 'bq1',
        stem: '(x + 3)² ni yoying.',
        options: ['x² + 9', 'x² + 6x + 9', 'x² + 3x + 9', 'x² + 6x + 3'],
        correctIndex: 1,
      ),
      Question(
        id: 'bq2',
        stem: '2x − 5 = 11 tenglamada x nechaga teng?',
        options: ['6', '8', '3', '−3'],
        correctIndex: 1,
      ),
      Question(
        id: 'bq3',
        stem: 'Uchburchak burchaklari yigʻindisi necha gradus?',
        options: ['90°', '180°', '270°', '360°'],
        correctIndex: 1,
      ),
    ],
  );
});

/// Weekly challenge summary for the hub (mock).
final challengeDaysLeftProvider = Provider<int>((ref) => 3);

/// League standings by scope (docs/07 S24). Mock rows; own class flagged.
final leagueProvider =
    Provider.family<List<LeagueRow>, LeagueScope>((ref, scope) {
  return const [
    LeagueRow(rank: 1, classLabel: '7-A', played: 6, points: 148, delta: 1),
    LeagueRow(
        rank: 2,
        classLabel: '7-B',
        played: 6,
        points: 140,
        isOwn: true,
        delta: 2),
    LeagueRow(rank: 3, classLabel: '7-V', played: 6, points: 132, delta: -1),
    LeagueRow(rank: 4, classLabel: '7-G', played: 5, points: 119, delta: 0),
    LeagueRow(rank: 5, classLabel: '7-D', played: 6, points: 104, delta: -2),
  ];
});

// ---------------- Battle play session ----------------

@immutable
class BattleSessionState {
  const BattleSessionState(
      {required this.index,
      required this.answers,
      required this.revealed,
      required this.finished});

  final int index;
  final List<int?> answers; // selected option per question
  final bool revealed; // current question locked & correctness shown
  final bool finished;

  BattleSessionState copyWith(
          {int? index, List<int?>? answers, bool? revealed, bool? finished}) =>
      BattleSessionState(
        index: index ?? this.index,
        answers: answers ?? this.answers,
        revealed: revealed ?? this.revealed,
        finished: finished ?? this.finished,
      );
}

final battleSessionProvider =
    NotifierProvider<BattleSession, BattleSessionState>(BattleSession.new);

class BattleSession extends Notifier<BattleSessionState> {
  Battle? get _battle => ref.read(activeBattleProvider);

  @override
  BattleSessionState build() {
    final n = ref.watch(activeBattleProvider)?.questions.length ?? 0;
    return BattleSessionState(
        index: 0,
        answers: List<int?>.filled(n, null),
        revealed: false,
        finished: false);
  }

  Question? get current {
    final b = _battle;
    if (b == null || state.index >= b.questions.length) return null;
    return b.questions[state.index];
  }

  int get total => _battle?.questions.length ?? 0;

  int get correctCount {
    final b = _battle;
    if (b == null) return 0;
    var c = 0;
    for (var i = 0; i < b.questions.length; i++) {
      if (state.answers[i] == b.questions[i].correctIndex) c++;
    }
    return c;
  }

  /// Lock the current question on the chosen option and reveal correctness.
  /// No changing the answer once locked (docs/07 S22).
  void select(int optionIndex) {
    if (state.revealed) return;
    final answers = [...state.answers]..[state.index] = optionIndex;
    state = state.copyWith(answers: answers, revealed: true);
  }

  /// The question's timer ran out with no answer: lock it (counts as wrong) and
  /// reveal the correct option so the class does not lose the flow.
  void lockTimeout() {
    if (state.revealed) return;
    state = state.copyWith(revealed: true);
  }

  void advance() {
    if (!state.revealed) return;
    if (state.index >= total - 1) {
      state = state.copyWith(finished: true);
    } else {
      state = state.copyWith(index: state.index + 1, revealed: false);
    }
  }

  void restart() {
    state = BattleSessionState(
        index: 0,
        answers: List<int?>.filled(total, null),
        revealed: false,
        finished: false);
  }
}
