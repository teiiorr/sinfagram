import 'package:flutter/foundation.dart';

/// School board content (docs/07 S15). Teacher/admin-published, read-only for
/// pupils, and fully cacheable offline.
@immutable
class Lesson {
  const Lesson(
      {required this.time,
      required this.subject,
      required this.room,
      this.isCurrent = false});
  final String time;
  final String subject;
  final String room;
  final bool isCurrent;
}

@immutable
class Homework {
  const Homework(
      {required this.subject, required this.title, required this.due});
  final String subject;
  final String title;
  final String due;
}

@immutable
class Announcement {
  const Announcement(
      {required this.title, required this.body, this.pinned = false});
  final String title;
  final String body;
  final bool pinned;
}

@immutable
class LostItem {
  const LostItem({required this.title, required this.note});
  final String title;
  final String note;
}

@immutable
class SchoolBoard {
  const SchoolBoard({
    required this.schedule,
    required this.homework,
    required this.announcements,
    required this.lostFound,
  });
  final List<Lesson> schedule;
  final List<Homework> homework;
  final List<Announcement> announcements;
  final List<LostItem> lostFound;
}
