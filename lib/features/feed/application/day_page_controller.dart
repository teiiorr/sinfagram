import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/async/loadable.dart';
import '../../../core/storage/prefs.dart';
import '../../auth/application/session_controller.dart';
import '../domain/post.dart';

/// The current day page. Mock in-memory data (client-first, docs/14); the real
/// repository + drift cache slot in behind this provider unchanged.
final dayPageProvider = NotifierProvider<DayPageController, Loadable<DayPage>>(
    DayPageController.new);

/// All currently-loaded posts (ready or held-through-a-load), unfiltered.
List<Post> _postsOf(Loadable<DayPage> s) => switch (s) {
      Ready(:final value) => value.posts,
      Loading(:final previous) => previous?.posts ?? const [],
      Failed(:final previous) => previous?.posts ?? const [],
    };

/// Media posts for the Lenta feed — photos/videos only (Instagram-style).
final feedPhotoPostsProvider = Provider<List<Post>>(
    (ref) => _postsOf(ref.watch(dayPageProvider)).where((p) => p.hasMedia).toList());

/// Text-only posts for Munozara (threads-style discussions).
final munozaraPostsProvider = Provider<List<Post>>(
    (ref) => _postsOf(ref.watch(dayPageProvider)).where((p) => !p.hasMedia).toList());

/// Posts the viewer has reposted (profile Reposts tab).
final repostedPostsProvider = Provider<List<Post>>((ref) =>
    _postsOf(ref.watch(dayPageProvider)).where((p) => p.repostedByMe).toList());

class DayPageController extends Notifier<Loadable<DayPage>> {
  // Namespaced per active account so each account keeps its own local posts,
  // private thanks and reposts.
  String _postsKey = 'feed.posts';
  String _thanksKey = 'feed.thanks';
  String _repostKey = 'feed.reposts';

  @override
  Loadable<DayPage> build() {
    final session = ref.watch(sessionProvider);
    final classLabel = session?.classLabel ?? '7-B';
    final ns = (session?.displayName ?? 'me').replaceAll(' ', '_');
    _postsKey = 'feed.posts.$ns';
    _thanksKey = 'feed.thanks.$ns';
    _repostKey = 'feed.reposts.$ns';
    final seed = _seed(classLabel);
    // Hydrate locally-composed posts and the viewer's private thanks set.
    final hydrated = DayPage(
      dateLabel: seed.dateLabel,
      classLabel: seed.classLabel,
      isComplete: seed.isComplete,
      posts: _applyViewerState([...seed.posts, ..._savedPosts()]),
    );
    return Ready(hydrated);
  }

  // --- persistence ---------------------------------------------------------

  List<Post> _savedPosts() {
    final raw = ref.read(sharedPrefsProvider).getString(_postsKey);
    if (raw == null) return const [];
    try {
      final author = ref.read(sessionProvider)?.displayName ?? 'Siz';
      return [
        for (final e in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
          Post(
            id: e['id'] as String,
            authorName: author,
            timeLabel: e['time'] as String? ?? 'hozir',
            body: e['body'] as String? ?? '',
            hasPhoto: (e['photo'] as String?) != null,
            photoPath: e['photo'] as String?,
            videoPath: e['video'] as String?,
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  void _persistPost(Post p) {
    final raw = ref.read(sharedPrefsProvider).getString(_postsKey);
    final list = <Map<String, dynamic>>[];
    if (raw != null) {
      try {
        list.addAll((jsonDecode(raw) as List).cast<Map<String, dynamic>>());
      } catch (_) {}
    }
    list.add({
      'id': p.id,
      'time': p.timeLabel,
      'body': p.body,
      'photo': p.photoPath,
      'video': p.videoPath,
    });
    ref.read(sharedPrefsProvider).setString(_postsKey, jsonEncode(list));
  }

  Set<String> _thankedIds() {
    final raw = ref.read(sharedPrefsProvider).getString(_thanksKey);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).cast<String>().toSet();
    } catch (_) {
      return {};
    }
  }

  Set<String> _repostedIds() {
    final raw = ref.read(sharedPrefsProvider).getString(_repostKey);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).cast<String>().toSet();
    } catch (_) {
      return {};
    }
  }

  /// Overlays the persisted like (thanks) and repost sets onto posts. Once the
  /// viewer has toggled a like, that set is the source of truth for likes; the
  /// repost set is likewise authoritative.
  List<Post> _applyViewerState(List<Post> posts) {
    final thanksRaw = ref.read(sharedPrefsProvider).getString(_thanksKey);
    final thanked = _thankedIds();
    final reposted = _repostedIds();
    return [
      for (final p in posts)
        p.copyWith(
          // If the viewer has never toggled a like, keep the seed default.
          thankedByMe: thanksRaw == null ? p.thankedByMe : thanked.contains(p.id),
          repostedByMe: reposted.contains(p.id),
        ),
    ];
  }

  DayPage _seed(String classLabel) => DayPage(
        dateLabel: '14-sentabr, dushanba',
        classLabel: classLabel,
        isComplete: true,
        posts: const [
          // Text posts → surfaced in Munozara (no media).
          Post(
            id: 'p1',
            authorName: 'Nodir Sobirov',
            timeLabel: '08:40',
            body:
                'Bugun matematikadan yangi mavzu — kvadrat tenglamalar. Kim tushunmadi, tushlikda tushuntiraman.',
            commentCount: 3,
            likeCount: 18,
          ),
          // Photo posts → surfaced in Lenta (media).
          Post(
            id: 'p2',
            authorName: 'Malika Yusupova',
            timeLabel: '10:15',
            body:
                'Biologiya laboratoriyasidan suratlar. Juda qiziqarli tajriba boʻldi!',
            hasPhoto: true,
            commentCount: 5,
            likeCount: 42,
            thankedByMe: true,
          ),
          Post(
            id: 'p3',
            authorName: 'Bekzod Aliyev',
            timeLabel: '13:20',
            body:
                'Ertaga jismoniy tarbiya darsiga sport kiyim olib kelishni unutmang.',
            commentCount: 1,
            likeCount: 7,
          ),
          Post(
            id: 'p4',
            authorName: 'Dilnoza Rahimova',
            timeLabel: '11:05',
            body: 'Sinf devoriy gazetasi tayyor boʻldi! 🎨',
            hasPhoto: true,
            commentCount: 2,
            likeCount: 25,
          ),
          Post(
            id: 'p5',
            authorName: 'Jasur Toshmatov',
            timeLabel: '12:30',
            body: 'Robototexnika toʻgaragidan ishlarimiz.',
            hasPhoto: true,
            commentCount: 4,
            likeCount: 33,
          ),
          Post(
            id: 'p6',
            authorName: 'Sevara Qodirova',
            timeLabel: '14:10',
            body:
                'Kim ertangi adabiyot uchun sheʼr yodladi? Keling, birga takrorlaymiz.',
            commentCount: 6,
            likeCount: 11,
          ),
        ],
      );

  DayPage? get _current => switch (state) {
        Ready(:final value) => value,
        Loading(:final previous) => previous,
        Failed(:final previous) => previous,
      };

  void toggleThanks(String postId) {
    final day = _current;
    if (day == null) return;
    final posts = [
      for (final p in day.posts)
        if (p.id == postId) p.copyWith(thankedByMe: !p.thankedByMe) else p,
    ];
    state = Ready(
      DayPage(
        dateLabel: day.dateLabel,
        classLabel: day.classLabel,
        isComplete: day.isComplete,
        posts: posts,
      ),
    );
    // Persist the private thanks set (ids the viewer currently thanks).
    final thanked = [for (final p in posts) if (p.thankedByMe) p.id];
    ref.read(sharedPrefsProvider).setString(_thanksKey, jsonEncode(thanked));
  }

  /// Toggles a repost (Instagram-style re-share to the viewer's own profile).
  /// Returns true if the post is now reposted, false if it was un-reposted.
  bool toggleRepost(String postId) {
    final day = _current;
    if (day == null) return false;
    var nowReposted = false;
    final posts = [
      for (final p in day.posts)
        if (p.id == postId)
          () {
            final t = p.copyWith(repostedByMe: !p.repostedByMe);
            nowReposted = t.repostedByMe;
            return t;
          }()
        else
          p,
    ];
    state = Ready(
      DayPage(
        dateLabel: day.dateLabel,
        classLabel: day.classLabel,
        isComplete: day.isComplete,
        posts: posts,
      ),
    );
    final reposted = [for (final p in posts) if (p.repostedByMe) p.id];
    ref.read(sharedPrefsProvider).setString(_repostKey, jsonEncode(reposted));
    return nowReposted;
  }

  /// Composer submit (mock). Appends chronologically; a real post goes through
  /// the filter, may come back CONTENT_HELD, and is cached in the outbox offline.
  void addPost(String body, {String? photoPath, String? videoPath}) {
    final day = _current;
    if (day == null || body.trim().isEmpty) return;
    final post = Post(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      authorName: ref.read(sessionProvider)?.displayName ?? 'Siz',
      timeLabel: 'hozir',
      body: body.trim(),
      hasPhoto: photoPath != null,
      photoPath: photoPath,
      videoPath: videoPath,
    );
    state = Ready(
      DayPage(
        dateLabel: day.dateLabel,
        classLabel: day.classLabel,
        isComplete: day.isComplete,
        posts: [...day.posts, post],
      ),
    );
    _persistPost(post);
  }
}
