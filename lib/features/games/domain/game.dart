import 'package:flutter/foundation.dart';

/// One quiz question. Delivered one at a time; the correct index is used only to
/// reveal correctness after a lock (docs/07 S22). A real battle fetches these
/// per session and discards them (docs/11 §11.2).
@immutable
class Question {
  const Question(
      {required this.id,
      required this.stem,
      required this.options,
      required this.correctIndex});
  final String id;
  final String stem;
  final List<String> options;
  final int correctIndex;
}

/// A class-vs-class battle (docs/07 S21–S23). Scores are always the CLASS's —
/// no per-pupil score is ever surfaced (docs/01, docs/14 Phase 4 DoD).
@immutable
class Battle {
  const Battle({
    required this.id,
    required this.opponentClass,
    required this.subject,
    required this.playedCount,
    required this.classSize,
    required this.questions,
  });
  final String id;
  final String opponentClass;
  final String subject;
  final int playedCount;
  final int classSize;
  final List<Question> questions;
}

enum BattleStatus { win, lose, draw }

/// A row in the league table (docs/07 S24). Class-level only.
@immutable
class LeagueRow {
  const LeagueRow({
    required this.rank,
    required this.classLabel,
    required this.played,
    required this.points,
    this.isOwn = false,
    this.delta = 0,
  });
  final int rank;
  final String classLabel;
  final int played;
  final int points;
  final bool isOwn;
  final int delta; // rank change: +up / -down / 0
}

enum LeagueScope { parallel, school, district, region }
