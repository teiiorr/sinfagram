import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/storage/prefs.dart';
import '../../auth/application/session_controller.dart';
import '../domain/story.dart';

/// Class stories. Mock friend data (client-first); the first entry is the
/// viewer's own story. Slides the pupil adds with [addMySlide] persist locally
/// (key [_key]) so they survive a restart. Captions are content.
final storiesProvider =
    NotifierProvider<StoriesController, List<Story>>(StoriesController.new);

class StoriesController extends Notifier<List<Story>> {
  static const _key = 'me.stories.captions';
  var _seq = 0;

  @override
  List<Story> build() {
    final me = ref.watch(sessionProvider)?.displayName ?? 'Siz';

    // The viewer's own story: a default slide plus any locally-saved slides.
    final mine = <StorySlide>[
      const StorySlide(id: 'm1', caption: 'Bugungi kayfiyat 🌤️'),
    ];
    for (final caption in _savedCaptions()) {
      mine.add(StorySlide(id: 'mine${_seq++}', caption: caption));
    }

    return [
      Story(id: 'me', author: me, isMine: true, slides: mine),
      const Story(id: 's1', author: 'Dilnoza Rahimova', slides: [
        StorySlide(id: 'd1', caption: 'Biologiya laboratoriyasi 🔬'),
        StorySlide(id: 'd2', caption: 'Guruh bilan tayyorgarlik'),
      ]),
      const Story(id: 's2', author: 'Bekzod Aliyev', slides: [
        StorySlide(id: 'b1', caption: 'Futbol mashgʻuloti ⚽'),
      ]),
      const Story(id: 's3', author: 'Malika Yusupova', slides: [
        StorySlide(id: 'ml1', caption: 'Rasm chizdim 🎨'),
        StorySlide(id: 'ml2', caption: 'Kutubxonada'),
      ]),
      const Story(id: 's4', author: 'Jasur Toshmatov', slides: [
        StorySlide(id: 'j1', caption: 'Matematika olimpiadasi 🧮'),
      ]),
      const Story(id: 's5', author: 'Sevara Qodirova', slides: [
        StorySlide(id: 'sv1', caption: 'Geografiya sayohati 🌍'),
      ]),
    ];
  }

  List<String> _savedCaptions() {
    final raw = ref.read(sharedPrefsProvider).getString(_key);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return const [];
    }
  }

  void _saveCaption(String caption) {
    final list = [..._savedCaptions(), caption];
    ref.read(sharedPrefsProvider).setString(_key, jsonEncode(list));
  }

  void markSeen(String id) {
    state = [
      for (final s in state)
        if (s.id == id && !s.seen) s.copyWith(seen: true) else s,
    ];
  }

  /// Adds a frame to the viewer's own story and persists it.
  void addMySlide(String caption) {
    final text = caption.trim();
    if (text.isEmpty) return;
    _saveCaption(text);
    state = [
      for (final s in state)
        if (s.isMine)
          s.copyWith(
              slides: [...s.slides, StorySlide(id: 'mine${_seq++}', caption: text)])
        else
          s,
    ];
  }
}
