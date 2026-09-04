import 'package:flutter/foundation.dart';

/// A hardcoded pupil account for the mock backend. The app can be "signed in as"
/// any of these via the account switcher; each carries its own identity and a
/// seeded profile so switching shows a different person. All per-account
/// user-generated data (posts, likes, reposts, story slides, profile edits) is
/// persisted under a key namespaced by [displayName].
@immutable
class Account {
  const Account({
    required this.id,
    required this.displayName,
    required this.username,
    required this.classLabel,
    required this.bio,
    required this.reading,
    required this.listening,
    required this.interests,
  });

  final String id;
  final String displayName;
  final String username; // @handle, shown in the switcher
  final String classLabel;
  final String bio;
  final String reading;
  final String listening;
  final List<String> interests;
}
