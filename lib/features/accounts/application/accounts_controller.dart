import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/features/accounts/domain/account.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';

/// The hardcoded set of accounts you can switch between (mock backend). Names
/// match seeded feed authors so each account's profile grid shows their posts.
final accountsProvider = Provider<List<Account>>((ref) {
  return const [
    Account(
      id: 'malika',
      displayName: 'Malika Yusupova',
      username: '@malika',
      classLabel: '7-B',
      bio: 'Biologiyani yaxshi koʻraman 🌿 laboratoriya — eng zoʻr joy.',
      reading: 'Alisa moʻjizalar mamlakatida',
      listening: 'Coldplay',
      interests: ['Rasm', 'Musiqa', 'Tabiat'],
    ),
    Account(
      id: 'dilnoza',
      displayName: 'Dilnoza Rahimova',
      username: '@dilnoza',
      classLabel: '7-B',
      bio: 'Devoriy gazeta muharriri. Raqs toʻgaragi.',
      reading: 'Kichik shahzoda',
      listening: 'Sevara Nazarxon',
      interests: ['Raqs', 'Kitob', 'Tabiat'],
    ),
    Account(
      id: 'jasur',
      displayName: 'Jasur Toshmatov',
      username: '@jasur',
      classLabel: '7-B',
      bio: 'Robototexnika va kod. Olimpiadaga tayyorlanaman.',
      reading: 'Vaqt mashinasi',
      listening: 'Daft Punk',
      interests: ['Robototexnika', 'Kod', 'Fan'],
    ),
    Account(
      id: 'bekzod',
      displayName: 'Bekzod Aliyev',
      username: '@bekzod',
      classLabel: '7-B',
      bio: 'Futbol sardori ⚽ Tarix ixlosmandi.',
      reading: 'Uch musheketyor',
      listening: 'Queen',
      interests: ['Futbol', 'Tarix'],
    ),
  ];
});

/// The currently active account, derived from the session identity (the account
/// switcher updates the session). Falls back to the first account.
final currentAccountProvider = Provider<Account>((ref) {
  final name = ref.watch(sessionProvider)?.displayName;
  final list = ref.watch(accountsProvider);
  for (final a in list) {
    if (a.displayName == name) return a;
  }
  return list.first;
});

/// Look up the seeded [Account] for a display name, if it is one of the mock
/// accounts (used to seed a fresh profile before any local edits).
Account? accountForName(Ref ref, String name) {
  for (final a in ref.read(accountsProvider)) {
    if (a.displayName == name) return a;
  }
  return null;
}
