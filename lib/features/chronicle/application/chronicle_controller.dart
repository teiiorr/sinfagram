import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/chronicle.dart';

/// Month chapters, newest first (docs/07 §7.6). Mock (client-first); captions are
/// server content, so their strings live here rather than in the ARB.
final chronicleProvider = Provider<List<Chapter>>((ref) {
  return const [
    Chapter(
      id: 'sentabr',
      monthLabel: 'Sentabr',
      sealed: false,
      daysToSeal: 12,
      items: [
        ChronicleItem(id: 's1', caption: 'Bilimlar kuni'),
        ChronicleItem(id: 's2', caption: 'Birinchi dars'),
        ChronicleItem(id: 's3', caption: 'Sinf sayohati'),
        ChronicleItem(id: 's4', caption: 'Kutubxonada'),
        ChronicleItem(id: 's5', caption: 'Futbol darsi'),
        ChronicleItem(id: 's6', caption: 'Guruh loyihasi'),
      ],
    ),
    Chapter(
      id: 'avgust',
      monthLabel: 'Avgust',
      sealed: true,
      items: [
        ChronicleItem(id: 'a1', caption: 'Yozgi lager'),
        ChronicleItem(id: 'a2', caption: 'Tayyorgarlik'),
        ChronicleItem(id: 'a3', caption: 'Yangi sinfxona'),
        ChronicleItem(id: 'a4', caption: 'Ustozlar bilan'),
      ],
    ),
  ];
});

Chapter? chapterById(WidgetRef ref, String id) {
  for (final c in ref.read(chronicleProvider)) {
    if (c.id == id) return c;
  }
  return null;
}
