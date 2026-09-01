import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ---------------- Class roles (S16) ----------------
@immutable
class ClassRole {
  const ClassRole({required this.role, required this.holder});
  final String role; // content label
  final String holder;
}

/// Current week's roles + the rotation order (docs/07 S16). Mock content.
final classRolesProvider =
    Provider<({List<ClassRole> current, List<String> rotation})>((ref) {
  return (
    current: const [
      ClassRole(role: 'Sardor', holder: 'Nodir Sobirov'),
      ClassRole(role: 'Kutubxonachi', holder: 'Malika Yusupova'),
      ClassRole(role: 'Navbatchi', holder: 'Bekzod Aliyev'),
      ClassRole(role: 'Sport rahbari', holder: 'Sardor Umarov'),
    ],
    rotation: const [
      'Aziza Karimova',
      'Dilnoza Rahimova',
      'Jasur Toshmatov',
      'Sevara Qodirova'
    ],
  );
});

// ---------------- Shared wall (S17) ----------------
@immutable
class WallState {
  const WallState({required this.contributors, required this.mine});
  final int contributors;
  final bool mine;
}

final wallProvider =
    NotifierProvider<WallController, WallState>(WallController.new);

class WallController extends Notifier<WallState> {
  @override
  WallState build() => const WallState(contributors: 18, mine: false);

  void contribute() {
    if (state.mine) return;
    state = WallState(contributors: state.contributors + 1, mine: true);
  }
}

// ---------------- Weekly challenge (S25) ----------------
@immutable
class ChallengeState {
  const ChallengeState(
      {required this.theme,
      required this.deadline,
      required this.entries,
      required this.submitted});
  final String theme; // content
  final String deadline; // content
  final List<String> entries; // content
  final bool submitted;
}

final challengeProvider = NotifierProvider<ChallengeController, ChallengeState>(
    ChallengeController.new);

class ChallengeController extends Notifier<ChallengeState> {
  @override
  ChallengeState build() => const ChallengeState(
        theme: 'Kuz fasli — eng chiroyli surat',
        deadline: 'Yakshanba',
        entries: ['Dilnoza R.', 'Bekzod A.', 'Sevara Q.'],
        submitted: false,
      );

  void submit() {
    if (state.submitted) return;
    state = ChallengeState(
        theme: state.theme,
        deadline: state.deadline,
        entries: [...state.entries, 'Siz'],
        submitted: true);
  }
}

// ---------------- Time capsule (S32) ----------------
@immutable
class CapsuleState {
  const CapsuleState(
      {required this.isOpen,
      required this.sealDate,
      required this.openDate,
      required this.notes,
      required this.written});
  final bool isOpen;
  final String sealDate;
  final String openDate;
  final int notes;
  final bool written;
}

final capsuleProvider =
    NotifierProvider<CapsuleController, CapsuleState>(CapsuleController.new);

class CapsuleController extends Notifier<CapsuleState> {
  @override
  CapsuleState build() => const CapsuleState(
      isOpen: true,
      sealDate: '31-may',
      openDate: 'kelasi yil 1-sentabr',
      notes: 12,
      written: false);

  void write() {
    if (state.written) return;
    state = CapsuleState(
        isOpen: state.isOpen,
        sealDate: state.sealDate,
        openDate: state.openDate,
        notes: state.notes + 1,
        written: true);
  }
}
