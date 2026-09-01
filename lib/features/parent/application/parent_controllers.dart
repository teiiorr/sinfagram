import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/session_controller.dart';
import '../domain/parent.dart';

/// The linked child's weekly digest (mock; client-first).
final parentDigestProvider = Provider<ParentDigest>((ref) {
  final child = ref.watch(sessionProvider)?.displayName ?? '';
  return ParentDigest(
      childName: child, activeDays: 4, minutes: 82, published: 3, thanks: 12);
});

/// What the child published publicly, newest first (docs/07 P02).
final childContentProvider = Provider<List<ChildPost>>((ref) {
  return const [
    ChildPost(
        id: 'cp1',
        body:
            'Biologiya laboratoriyasidan suratlar. Juda qiziqarli tajriba boʻldi!',
        timeLabel: 'Dushanba'),
    ChildPost(
        id: 'cp2',
        body: 'Ertaga jismoniy tarbiya darsiga sport kiyim kerak.',
        timeLabel: 'Seshanba'),
    ChildPost(
        id: 'cp3',
        body: 'Matematikadan yangi mavzuni tushundim 👍',
        timeLabel: 'Chorshanba'),
  ];
});

/// Complaints involving the child (docs/07 P03). Empty is the common, good state.
final parentCasesProvider = Provider<List<ParentCase>>((ref) => const []);

/// Compliance transparency (docs/12 §12.1). Content data, mirrored for the
/// parent's data screen (docs/07 P05).
final collectedDataProvider = Provider<List<String>>((ref) => const [
      'Ism va sinf',
      'Postlar va izohlar',
      'Rahmatlar (faqat siz va farzandingiz koʻradi)',
      'Davomat va baholar',
    ]);

final notCollectedDataProvider = Provider<List<String>>((ref) => const [
      'Telefon raqami',
      'Uy manzili',
      'PINFL / passport',
      'Biometrika',
      'Kontaktlar',
      'Reklama identifikatori',
      'Daromad, din, millat, sogʻliq',
    ]);
