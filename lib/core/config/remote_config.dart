import 'package:flutter/foundation.dart';

/// Runtime config served by `GET /v1/config` (docs/02 §2.8, docs/04 §4.3),
/// cached 15 min. The compiled-in [defaults] are IDENTICAL to the documented
/// defaults so the app works correctly if `/config` is unreachable.
@immutable
class RemoteConfig {
  const RemoteConfig({
    required this.nightModeStart,
    required this.nightModeEnd,
    required this.timezone,
    required this.lessonModeEnabled,
    required this.dailyThanks,
    required this.postsPerHour,
    required this.commentsPerHour,
    required this.answersPerHour,
    required this.minGrade,
    required this.lowDataDefault,
    required this.flags,
  });

  final String nightModeStart; // "22:00"
  final String nightModeEnd; // "06:00"
  final String timezone; // "Asia/Tashkent"
  final bool lessonModeEnabled;
  final int dailyThanks;
  final int postsPerHour;
  final int commentsPerHour;
  final int answersPerHour;
  final int minGrade;
  final bool lowDataDefault;
  final Map<String, bool> flags;

  bool flag(String key) => flags[key] ?? false;

  static const defaults = RemoteConfig(
    nightModeStart: '22:00',
    nightModeEnd: '06:00',
    timezone: 'Asia/Tashkent',
    lessonModeEnabled: true,
    dailyThanks: 5,
    postsPerHour: 6,
    commentsPerHour: 30,
    answersPerHour: 10,
    minGrade: 5,
    lowDataDefault: false,
    flags: {'challenges': true, 'treasury': false, 'capsule': true},
  );

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    final night =
        (json['nightMode'] as Map?)?.cast<String, dynamic>() ?? const {};
    final lesson =
        (json['lessonMode'] as Map?)?.cast<String, dynamic>() ?? const {};
    final limits =
        (json['limits'] as Map?)?.cast<String, dynamic>() ?? const {};
    final flags = (json['flags'] as Map?)?.cast<String, dynamic>() ?? const {};
    const d = defaults;
    return RemoteConfig(
      nightModeStart: night['start'] as String? ?? d.nightModeStart,
      nightModeEnd: night['end'] as String? ?? d.nightModeEnd,
      timezone: night['timezone'] as String? ?? d.timezone,
      lessonModeEnabled: lesson['enabled'] as bool? ?? d.lessonModeEnabled,
      dailyThanks: (limits['dailyThanks'] as num?)?.toInt() ?? d.dailyThanks,
      postsPerHour: (limits['postsPerHour'] as num?)?.toInt() ?? d.postsPerHour,
      commentsPerHour:
          (limits['commentsPerHour'] as num?)?.toInt() ?? d.commentsPerHour,
      answersPerHour:
          (limits['answersPerHour'] as num?)?.toInt() ?? d.answersPerHour,
      minGrade: (json['minGrade'] as num?)?.toInt() ?? d.minGrade,
      lowDataDefault: json['lowDataDefault'] as bool? ?? d.lowDataDefault,
      flags: flags.map((k, v) => MapEntry(k, v == true)),
    );
  }
}
