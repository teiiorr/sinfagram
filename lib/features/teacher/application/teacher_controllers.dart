import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/teacher.dart';

/// Classes owned by the teacher (docs/07 T01). Mock (client-first).
final teacherClassesProvider = Provider<List<TeacherClass>>((ref) {
  final open = ref.watch(openCaseCountProvider);
  return [
    TeacherClass(
        id: '7b', label: '7-B', joined: 26, rosterSize: 28, openCases: open),
    const TeacherClass(
        id: '8a', label: '8-A', joined: 30, rosterSize: 30, openCases: 0),
  ];
});

/// Number of still-open cases, surfaced as the T01 badge and the Men-tab dot.
final openCaseCountProvider = Provider<int>((ref) {
  return ref
      .watch(casesProvider)
      .where((c) => c.status == CaseStatus.open)
      .length;
});

/// A class roster (T02/T03). Mock names.
final teacherRosterProvider = Provider<List<String>>((ref) => const [
      'Aziza Karimova',
      'Bekzod Aliyev',
      'Dilnoza Rahimova',
      'Jasur Toshmatov',
      'Kamola Yoʻldosheva',
      'Malika Yusupova',
      'Nodir Sobirov',
      'Otabek Rashidov',
      'Sardor Umarov',
      'Sevara Qodirova',
    ]);

/// The moderation inbox (docs/07 T05/T06). Mock; actions resolve a case in place.
final casesProvider = NotifierProvider<CasesController, List<ModerationCase>>(
    CasesController.new);

class CasesController extends Notifier<List<ModerationCase>> {
  @override
  List<ModerationCase> build() => const [
        ModerationCase(
          id: 'c1',
          targetSummary: 'Post · 7-B',
          reason: 'Ogʻzaki haqorat',
          dueLabel: '2 soat',
          overdue: false,
          evidence: '“Sen hech narsani uddalay olmaysan” — izohda yozilgan.',
        ),
        ModerationCase(
          id: 'c2',
          targetSummary: 'Izoh · 7-B',
          reason: 'Bulling / kamsitish',
          dueLabel: '30 daqiqa',
          overdue: true,
          evidence: 'Bir necha oʻquvchi bir xil xabarni takrorlagan.',
        ),
      ];

  static String _label(CaseAction a) => switch (a) {
        CaseAction.hide => 'Yashirildi',
        CaseAction.mute => '24 soatga ovozsiz qilindi',
        CaseAction.escalate => 'Yuqoriga uzatildi',
        CaseAction.dismiss => 'Rad etildi',
      };

  /// Apply one of the four actions with a required note; the case leaves the
  /// open inbox (escalate keeps it recorded, resolved for this teacher).
  void act(String caseId, CaseAction action, String note) {
    if (note.trim().isEmpty) return;
    state = [
      for (final c in state)
        if (c.id == caseId)
          c.copyWith(
            status: CaseStatus.resolved,
            history: [...c.history, '${_label(action)}: ${note.trim()}'],
          )
        else
          c,
    ];
  }

  ModerationCase? byId(String id) {
    for (final c in state) {
      if (c.id == id) return c;
    }
    return null;
  }
}
