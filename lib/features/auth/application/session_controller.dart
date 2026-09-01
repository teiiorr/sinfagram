import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/session.dart';

/// Signed-in session, or null while onboarding. Backed by a mock in-memory flow
/// (no backend yet, docs/14 client-first). The real repository swaps in behind
/// the same provider without touching the UI.
final sessionProvider =
    NotifierProvider<SessionController, AppSession?>(SessionController.new);

class SessionController extends Notifier<AppSession?> {
  // Transient onboarding choices, not part of the exposed session state.
  AppRole _chosenRole = AppRole.pupil;
  String? _chosenName;
  String _classLabel = '7-B';

  @override
  AppSession? build() => null;

  AppRole get chosenRole => _chosenRole;
  String get classLabel => _classLabel;

  /// Mock roster for S05 — unclaimed names only (a real roster comes from the API).
  final List<String> roster = const [
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
  ];

  void chooseRole(AppRole role) => _chosenRole = role;

  /// Mock: any 6-digit code succeeds; the real endpoint validates server-side.
  bool submitClassCode(String code) => RegExp(r'^\d{6}$').hasMatch(code);

  void claimRoster(String name) => _chosenName = name;

  /// Mock PIN set completes the pupil sign-in. Consent is pre-granted so the
  /// happy path is visible; flip to pending to exercise S07.
  void completePupilSignIn() {
    state = AppSession(
      role: AppRole.pupil,
      displayName: _chosenName ?? roster.first,
      classLabel: _classLabel,
      consent: ConsentState.granted,
      seenVisibility: false,
    );
  }

  /// Mock staff sign-in. A teacher skips the pupil consent/visibility gates.
  void completeTeacherSignIn() {
    state = const AppSession(
      role: AppRole.teacher,
      displayName: 'Nigora Karimova',
      classLabel: '7-B',
      consent: ConsentState.granted,
      seenVisibility: true,
    );
  }

  /// Mock parent sign-in (OTP flow is P00 in the real app). classLabel is the
  /// linked child's class. displayName carries the child's name for the digest.
  void completeParentSignIn() {
    state = const AppSession(
      role: AppRole.parent,
      displayName: 'Dilnoza Rahimova',
      classLabel: '7-B',
      consent: ConsentState.granted,
      seenVisibility: true,
    );
  }

  void grantConsent() {
    final s = state;
    if (s != null) state = s.copyWith(consent: ConsentState.granted);
  }

  void markVisibilitySeen() {
    final s = state;
    if (s != null) state = s.copyWith(seenVisibility: true);
  }

  void signOut() {
    _chosenName = null;
    state = null;
  }
}
