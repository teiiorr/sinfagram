import 'package:flutter/foundation.dart';

/// Weekly digest — the parent's default view (docs/07 P01). Aggregates only;
/// there is deliberately no live activity feed and no "online" indicator.
@immutable
class ParentDigest {
  const ParentDigest({
    required this.childName,
    required this.activeDays,
    required this.minutes,
    required this.published,
    required this.thanks,
  });
  final String childName;
  final int activeDays;
  final int minutes;
  final int published;
  final int thanks; // visible to the child and their parent only (docs/01 §1.4)
}

/// One thing the child published publicly (docs/07 P02).
@immutable
class ChildPost {
  const ChildPost(
      {required this.id, required this.body, required this.timeLabel});
  final String id;
  final String body;
  final String timeLabel;
}

/// A complaint involving the child and its outcome (docs/07 P03).
@immutable
class ParentCase {
  const ParentCase(
      {required this.id, required this.summary, required this.outcome});
  final String id;
  final String summary;
  final String outcome;
}
