import 'package:flutter/foundation.dart';

/// A class a teacher owns (docs/07 T01).
@immutable
class TeacherClass {
  const TeacherClass(
      {required this.id,
      required this.label,
      required this.joined,
      required this.rosterSize,
      required this.openCases});
  final String id;
  final String label;
  final int joined;
  final int rosterSize;
  final int openCases;
}

enum CaseStatus { open, resolved }

/// The four level-1 teacher actions on a case (docs/07 T06). Each requires a
/// one-line note.
enum CaseAction { hide, mute, escalate, dismiss }

/// A moderation case in the teacher inbox (docs/07 T05/T06). The reporter is
/// never surfaced.
@immutable
class ModerationCase {
  const ModerationCase({
    required this.id,
    required this.targetSummary,
    required this.reason,
    required this.dueLabel,
    required this.overdue,
    required this.evidence,
    this.status = CaseStatus.open,
    this.history = const [],
  });

  final String id;
  final String targetSummary; // e.g. "Post · Jasur T."
  final String reason;
  final String dueLabel;
  final bool overdue;
  final String evidence;
  final CaseStatus status;
  final List<String> history;

  ModerationCase copyWith({CaseStatus? status, List<String>? history}) =>
      ModerationCase(
        id: id,
        targetSummary: targetSummary,
        reason: reason,
        dueLabel: dueLabel,
        overdue: overdue,
        evidence: evidence,
        status: status ?? this.status,
        history: history ?? this.history,
      );
}
