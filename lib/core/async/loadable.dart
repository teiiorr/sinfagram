import 'package:flutter/foundation.dart';

/// Error codes from docs/04 §4.1. The client maps [AppError.code] to a localized
/// message and NEVER shows the server `message` to a pupil.
abstract final class ApiCode {
  static const unauthenticated = 'UNAUTHENTICATED';
  static const consentRequired = 'CONSENT_REQUIRED';
  static const nightMode = 'NIGHT_MODE';
  static const lessonMode = 'LESSON_MODE';
  static const contentBlocked = 'CONTENT_BLOCKED';
  static const contentHeld = 'CONTENT_HELD';
  static const rateLimited = 'RATE_LIMITED';
  static const gradeNotEligible = 'GRADE_NOT_ELIGIBLE';
  static const rosterLineTaken = 'ROSTER_LINE_TAKEN';
  static const offline = 'OFFLINE';
  static const unknown = 'UNKNOWN';
}

/// App-level error mapped from the docs/04 §4.1 envelope.
@immutable
class AppError {
  const AppError(
      {required this.code, this.serverMessage, this.field, this.retryAfter});

  final String code;

  /// Raw server message — for logs only. Never rendered to a pupil.
  final String? serverMessage;
  final String? field;

  /// Seconds to wait before retrying (RATE_LIMITED); null otherwise.
  final int? retryAfter;

  bool get retryable =>
      code == ApiCode.offline ||
      code == ApiCode.unknown ||
      code == ApiCode.rateLimited;

  static const offline = AppError(code: ApiCode.offline);
  static const unknown = AppError(code: ApiCode.unknown);
}

/// Standard async state (docs/02 §2.3). Every screen renders all four branches.
/// `Loading` with a non-null `previous` renders the previous content dimmed,
/// never a spinner over an empty page.
@immutable
sealed class Loadable<T> {
  const Loadable();
}

final class Loading<T> extends Loadable<T> {
  const Loading({this.previous});

  /// Kept so the UI can show stale content while refreshing instead of a blank screen.
  final T? previous;
}

final class Ready<T> extends Loadable<T> {
  const Ready(this.value, {this.isStale = false});

  final T value;

  /// True when served from the offline cache and a refresh has not yet succeeded.
  final bool isStale;
}

final class Failed<T> extends Loadable<T> {
  const Failed(this.error, {this.previous});

  final AppError error;
  final T? previous;
}
