import 'package:flutter/foundation.dart';

/// Minimum answer length enforced client-side and again server-side (docs/07 S14).
const int kHelpAnswerMinChars = 40;

@immutable
class HelpAnswer {
  const HelpAnswer(
      {required this.id,
      required this.author,
      required this.body,
      required this.timeLabel,
      this.isBest = false});

  final String id;
  final String author;
  final String body;
  final String timeLabel;
  final bool isBest;

  HelpAnswer copyWith({bool? isBest}) => HelpAnswer(
      id: id,
      author: author,
      body: body,
      timeLabel: timeLabel,
      isBest: isBest ?? this.isBest);
}

@immutable
class HelpQuestion {
  const HelpQuestion({
    required this.id,
    required this.subject,
    required this.title,
    required this.timeLabel,
    this.answers = const [],
  });

  final String id;
  final String subject;
  final String title;
  final String timeLabel;
  final List<HelpAnswer> answers;

  int get answerCount => answers.length;
  bool get isResolved => answers.any((a) => a.isBest);

  HelpQuestion copyWith({List<HelpAnswer>? answers}) => HelpQuestion(
      id: id,
      subject: subject,
      title: title,
      timeLabel: timeLabel,
      answers: answers ?? this.answers);
}
