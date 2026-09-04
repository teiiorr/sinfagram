import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/storage/prefs.dart';
import 'package:sinfagram/features/accounts/application/accounts_controller.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/people/domain/person.dart';

/// The class roster as people (not just names): each classmate carries a small
/// personality — a bio, what they're reading, what they're listening to, and a
/// few interests. This powers the classmates grid and the profile screen.
///
/// No child media or contact data (docs/12): personality is text the pupil
/// chooses to share, nothing collected.
final classmatesProvider = Provider<List<Person>>((ref) {
  final session = ref.watch(sessionProvider);
  final className = session?.classLabel ?? '7-B';
  return _seed(className);
});

/// The viewer's own profile — editable "About me". Seeded from the session,
/// mutated locally (reading / listening / bio / interests) until the backend
/// lands. [MyProfileController] is intentionally simple: this is the one profile
/// the pupil owns and can change.
final myProfileProvider = NotifierProvider<MyProfileController, Person>(
  MyProfileController.new,
);

class MyProfileController extends Notifier<Person> {
  // Persistence key is namespaced by the active account so each account keeps
  // its own edited profile.
  String _key = 'me.profile';

  @override
  Person build() {
    final session = ref.watch(sessionProvider);
    final name = session?.displayName ?? 'Men';
    _key = 'me.profile.${name.replaceAll(' ', '_')}';

    // Defaults: if this identity is one of the mock accounts, seed its profile
    // so switching accounts shows a populated "About me" out of the box.
    final seed = accountForName(ref, name);
    var me = Person(
      id: 'me',
      name: name,
      className: session?.classLabel ?? '7-B',
      bio: seed?.bio ?? '',
      reading: seed?.reading ?? '',
      listening: seed?.listening ?? '',
      interests: seed?.interests ?? const [],
    );
    // Local edits override the seed.
    final raw = ref.read(sharedPrefsProvider).getString(_key);
    if (raw != null) {
      try {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        me = me.copyWith(
          bio: m['bio'] as String? ?? '',
          reading: m['reading'] as String? ?? '',
          listening: m['listening'] as String? ?? '',
          interests: (m['interests'] as List?)?.cast<String>() ?? const [],
        );
      } catch (_) {
        // Corrupt payload — fall back to the fresh profile.
      }
    }
    return me;
  }

  void _persist() {
    ref.read(sharedPrefsProvider).setString(
          _key,
          jsonEncode({
            'bio': state.bio,
            'reading': state.reading,
            'listening': state.listening,
            'interests': state.interests,
          }),
        );
  }

  void setBio(String value) {
    state = state.copyWith(bio: value.trim());
    _persist();
  }

  void setReading(String value) {
    state = state.copyWith(reading: value.trim());
    _persist();
  }

  void setListening(String value) {
    state = state.copyWith(listening: value.trim());
    _persist();
  }

  void setInterests(List<String> value) {
    state = state.copyWith(interests: value);
    _persist();
  }
}

/// Look up any person by id — a classmate from the roster, or the viewer.
final personByIdProvider = Provider.family<Person?, String>((ref, id) {
  if (id == 'me') return ref.watch(myProfileProvider);
  final all = ref.watch(classmatesProvider);
  for (final p in all) {
    if (p.id == id) return p;
  }
  return null;
});

// --- Seed roster -------------------------------------------------------------
// Names only (given names common in UZ classrooms); personality strings are
// deliberately light and age-appropriate. Interests reuse simple tags.
List<Person> _seed(String className) {
  final rows = <List<Object>>[
    ['Aziza Karimova', 'Sherlok Holms hikoyalari', 'Yulduz Usmonova', ['Kitob', 'Rasm', 'Shaxmat']],
    ['Bekzod Toshmatov', 'Robinzon Kruzo', 'Konstitutsiya marshi', ['Futbol', 'Robototexnika']],
    ['Dilnoza Rahimova', 'Kichik shahzoda', 'Sevara Nazarxon', ['Raqs', 'Kitob', 'Tabiat']],
    ['Eldor Yusupov', 'Garri Potter', 'Imagine Dragons', ['Geymer', 'Shaxmat', 'Kod']],
    ['Farida Ismoilova', 'Alisa mo\'jizalar mamlakatida', 'Coldplay', ['Rasm', 'Musiqa']],
    ['Gulnora Sobirova', 'Tom Soyer sarguzashtlari', 'Ozodbek Nazarbekov', ['Teatr', 'Kitob']],
    ['Husan Aliyev', 'Uch musheketyor', 'Queen', ['Futbol', 'Tarix']],
    ['Iroda Nazarova', 'Malika va no\'xat', 'Taylor Swift', ['Raqs', 'Rasm', 'Til']],
    ['Jasur Qodirov', 'Ali Baba', 'Daft Punk', ['Robototexnika', 'Kod']],
    ['Kamola Yodgorova', 'Momo', 'Adele', ['Kitob', 'Musiqa', 'Tabiat']],
    ['Laziz Umarov', 'Vaqt mashinasi', 'Linkin Park', ['Geymer', 'Fan']],
    ['Malika Sultonova', 'Kichkina malika', 'Sevara Nazarxon', ['Raqs', 'Rasm']],
  ];
  final out = <Person>[];
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    out.add(Person(
      id: 'c$i',
      name: r[0] as String,
      className: className,
      bio: '',
      reading: r[1] as String,
      listening: r[2] as String,
      interests: List<String>.from(r[3] as List),
    ));
  }
  return out;
}
