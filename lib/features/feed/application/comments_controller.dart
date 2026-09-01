import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/session_controller.dart';
import '../domain/comment.dart';

/// Comments per post, keyed by postId. Mock in-memory (client-first); the real
/// repository + drift cache slot in behind this provider unchanged.
final commentsProvider =
    NotifierProvider<CommentsController, Map<String, List<Comment>>>(
        CommentsController.new);

class CommentsController extends Notifier<Map<String, List<Comment>>> {
  var _seq = 0;

  @override
  Map<String, List<Comment>> build() => {
        'p1': const [
          Comment(
              id: 'c1',
              author: 'Malika Yusupova',
              body: 'Rahmat, tushuntirib berganingiz uchun!',
              timeLabel: '09:05'),
          Comment(
              id: 'c2',
              author: 'Bekzod Aliyev',
              body: 'Men ham qatnashaman.',
              timeLabel: '09:12'),
        ],
        'p2': const [
          Comment(
              id: 'c3',
              author: 'Sardor Umarov',
              body: 'Juda chiroyli chiqibdi 👏',
              timeLabel: '10:40'),
        ],
      };

  List<Comment> forPost(String postId) => state[postId] ?? const [];

  void addComment(String postId, String body) {
    final text = body.trim();
    if (text.isEmpty) return;
    final author = ref.read(sessionProvider)?.displayName ?? 'Siz';
    final comment = Comment(
        id: 'local_c${_seq++}', author: author, body: text, timeLabel: 'hozir');
    state = {
      ...state,
      postId: [...(state[postId] ?? const []), comment],
    };
  }
}
