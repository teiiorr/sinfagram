import 'package:flutter/foundation.dart';

/// Roles (docs/01 §1.3). Moderator/analyst are web-only; the app rejects them.
enum AppRole { pupil, teacher, parent, alumnus, webOnly }

/// Parental consent gate (docs/01, docs/04 §4.1 CONSENT_REQUIRED).
enum ConsentState { pending, granted, denied }

/// The authenticated session. Role comes from the session, never a stored
/// preference (docs/02 §2.2) — a device can pass between a pupil and a parent.
@immutable
class AppSession {
  const AppSession({
    required this.role,
    required this.displayName,
    required this.classLabel,
    required this.consent,
    required this.seenVisibility,
  });

  final AppRole role;
  final String displayName;
  final String classLabel; // "7-B"
  final ConsentState consent;
  final bool seenVisibility;

  AppSession copyWith({ConsentState? consent, bool? seenVisibility}) =>
      AppSession(
        role: role,
        displayName: displayName,
        classLabel: classLabel,
        consent: consent ?? this.consent,
        seenVisibility: seenVisibility ?? this.seenVisibility,
      );
}
