import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/storage/prefs.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';

/// The Instagram engagement layer over the mock backend: who the active account
/// follows, which posts it saved, and derived counts (followers / following /
/// posts). All per-account state is namespaced by the active display name and
/// persisted, so switching accounts changes the whole social graph.

/// Names followed by default on a fresh account (minus the account itself) — so
/// the following-feed has content out of the box.
const _defaultFollows = <String>[
  'Malika Yusupova',
  'Dilnoza Rahimova',
  'Jasur Toshmatov',
  'Bekzod Aliyev',
  'Nodir Sobirov',
  'Sevara Qodirova',
  'Aziza Karimova',
  'Kamola Yodgorova',
  'Iroda Nazarova',
];

String _ns(Ref ref) =>
    (ref.watch(sessionProvider)?.displayName ?? 'me').replaceAll(' ', '_');

/// The set of names the active account follows.
final followsProvider =
    NotifierProvider<FollowsController, Set<String>>(FollowsController.new);

class FollowsController extends Notifier<Set<String>> {
  String _key = 'social.follows';

  @override
  Set<String> build() {
    final me = ref.watch(sessionProvider)?.displayName;
    _key = 'social.follows.${(me ?? 'me').replaceAll(' ', '_')}';
    final raw = ref.read(sharedPrefsProvider).getString(_key);
    if (raw != null) {
      try {
        return (jsonDecode(raw) as List).cast<String>().toSet();
      } catch (_) {}
    }
    return {..._defaultFollows}..remove(me);
  }

  bool isFollowing(String name) => state.contains(name);

  void toggle(String name) {
    final next = {...state};
    if (!next.remove(name)) next.add(name);
    state = next;
    ref.read(sharedPrefsProvider).setString(_key, jsonEncode(next.toList()));
  }
}

/// Post ids the active account has saved (bookmarked).
final savedProvider =
    NotifierProvider<SavedController, Set<String>>(SavedController.new);

class SavedController extends Notifier<Set<String>> {
  String _key = 'social.saved';

  @override
  Set<String> build() {
    _key = 'social.saved.${_ns(ref)}';
    final raw = ref.read(sharedPrefsProvider).getString(_key);
    if (raw != null) {
      try {
        return (jsonDecode(raw) as List).cast<String>().toSet();
      } catch (_) {}
    }
    return {};
  }

  bool isSaved(String id) => state.contains(id);

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
    ref.read(sharedPrefsProvider).setString(_key, jsonEncode(next.toList()));
  }
}

// --- Derived counts ---------------------------------------------------------

/// A stable pseudo-random base count from a name, so every person has plausible,
/// consistent follower/following numbers without a hand-maintained table.
int _hash(String s) {
  var h = 0;
  for (final c in s.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return h;
}

int _baseFollowers(String name) => 60 + _hash(name) % 340; // 60..399
int _baseFollowing(String name) => 45 + _hash('$name#f') % 255; // 45..299

/// Followers of [name]. For someone the viewer follows, +1 (the viewer).
final followerCountProvider = Provider.family<int, String>((ref, name) {
  final me = ref.watch(sessionProvider)?.displayName;
  final base = _baseFollowers(name);
  if (name == me) return base; // own followers are just the base
  return base + (ref.watch(followsProvider).contains(name) ? 1 : 0);
});

/// Following count. For the viewer, it's the live size of their follow set.
final followingCountProvider = Provider.family<int, String>((ref, name) {
  final me = ref.watch(sessionProvider)?.displayName;
  if (name == me) return ref.watch(followsProvider).length;
  return _baseFollowing(name);
});

/// Number of grid posts (media) authored by [name].
final postsCountProvider = Provider.family<int, String>((ref, name) =>
    ref.watch(feedPhotoPostsProvider).where((p) => p.authorName == name).length);

/// Posts the active account has saved (for the profile Saved tab).
final savedPostsProvider = Provider<List<Post>>((ref) {
  final saved = ref.watch(savedProvider);
  return ref
      .watch(feedPhotoPostsProvider)
      .where((p) => saved.contains(p.id))
      .toList();
});

/// The Instagram home feed: media posts by people the viewer follows, plus their
/// own, newest first (seed order is chronological; reverse for recency).
final followingFeedProvider = Provider<List<Post>>((ref) {
  final me = ref.watch(sessionProvider)?.displayName;
  final follows = ref.watch(followsProvider);
  final posts = ref
      .watch(feedPhotoPostsProvider)
      .where((p) => p.authorName == me || follows.contains(p.authorName))
      .toList();
  return posts.reversed.toList();
});
