import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/session_controller.dart';
import '../domain/help.dart';

/// Help board questions (docs/07 S13/S14). Mock in-memory (client-first).
final helpBoardProvider =
    NotifierProvider<HelpController, List<HelpQuestion>>(HelpController.new);

class HelpController extends Notifier<List<HelpQuestion>> {
  var _seq = 0;

  @override
  List<HelpQuestion> build() => const [
        HelpQuestion(
          id: 'q1',
          subject: 'Matematika',
          title:
              'Kvadrat tenglamani diskriminant orqali yechishni kim tushuntira oladi?',
          timeLabel: '2 soat oldin',
          answers: [
            HelpAnswer(
                id: 'a1',
                author: 'Nodir Sobirov',
                body:
                    'Diskriminant D = b² − 4ac. Agar D > 0 boʻlsa ikkita ildiz boʻladi, keyin x = (−b ± √D) / 2a formulaga qoʻyasan.',
                timeLabel: '1 soat oldin',
                isBest: true),
          ],
        ),
        HelpQuestion(
          id: 'q2',
          subject: 'Ingliz tili',
          title: 'Present Perfect va Past Simple orasidagi farq nima?',
          timeLabel: '4 soat oldin',
        ),
        HelpQuestion(
          id: 'q3',
          subject: 'Fizika',
          title:
              'Nyutonning ikkinchi qonuni boʻyicha masala yechishga yordam kerak.',
          timeLabel: 'kecha',
        ),
      ];

  HelpQuestion? byId(String id) {
    for (final q in state) {
      if (q.id == id) return q;
    }
    return null;
  }

  void addQuestion(String subject, String title) {
    if (title.trim().isEmpty) return;
    state = [
      HelpQuestion(
          id: 'local_q${_seq++}',
          subject: subject,
          title: title.trim(),
          timeLabel: 'hozir'),
      ...state,
    ];
  }

  void addAnswer(String questionId, String body) {
    if (body.trim().length < kHelpAnswerMinChars) return;
    final author = ref.read(sessionProvider)?.displayName ?? 'Siz';
    final answer = HelpAnswer(
        id: 'local_a${_seq++}',
        author: author,
        body: body.trim(),
        timeLabel: 'hozir');
    state = [
      for (final q in state)
        if (q.id == questionId)
          q.copyWith(answers: [...q.answers, answer])
        else
          q,
    ];
  }

  void markBest(String questionId, String answerId) {
    state = [
      for (final q in state)
        if (q.id == questionId)
          q.copyWith(answers: [
            for (final a in q.answers) a.copyWith(isBest: a.id == answerId)
          ])
        else
          q,
    ];
  }
}
