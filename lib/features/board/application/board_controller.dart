import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/board.dart';

/// School board content. Mock (client-first); the real repository serves this
/// from cache-first drift so the board works fully offline (docs/11 §11.2).
/// Content strings are teacher-authored data (they arrive from the API), not UI
/// chrome — the localized labels are the section headers in the screen.
final boardProvider = Provider<SchoolBoard>((ref) {
  return const SchoolBoard(
    schedule: [
      Lesson(time: '08:30', subject: 'Matematika', room: '204'),
      Lesson(time: '09:20', subject: 'Ona tili', room: '108'),
      Lesson(time: '10:20', subject: 'Fizika', room: '301', isCurrent: true),
      Lesson(time: '11:10', subject: 'Ingliz tili', room: '115'),
      Lesson(time: '12:00', subject: 'Tarix', room: '106'),
    ],
    homework: [
      Homework(
          subject: 'Matematika',
          title: '48-bet, 5-mashq masalalarini yeching',
          due: 'Ertaga'),
      Homework(
          subject: 'Fizika',
          title: 'Laboratoriya ishi hisobotini tayyorlang',
          due: '2 kun'),
      Homework(
          subject: 'Ona tili', title: 'Insho: "Mening maktabim"', due: '3 kun'),
    ],
    announcements: [
      Announcement(
          title: 'Ota-onalar yigʻilishi',
          body: '15-sentabr, soat 17:00 da 204-xonada.',
          pinned: true),
      Announcement(
          title: 'Kutubxona yangi ish vaqti',
          body: 'Dushanba–juma, 09:00–17:00.'),
    ],
    lostFound: [
      LostItem(
          title: 'Koʻk rangli atlas',
          note: 'Sport zalida topildi. Sinf rahbaridan soʻrang.'),
    ],
  );
});
