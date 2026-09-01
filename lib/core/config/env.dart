/// Build flavours (docs/02 §2.7). Selected at build time via --dart-define=FLAVOR.
enum Flavor { local, staging, pilot, prod }

abstract final class Env {
  static const _raw = String.fromEnvironment('FLAVOR', defaultValue: 'local');

  static Flavor get flavor => switch (_raw) {
        'prod' => Flavor.prod,
        'pilot' => Flavor.pilot,
        'staging' => Flavor.staging,
        _ => Flavor.local,
      };

  /// REST base URL. Everything runs inside Uzbekistan (docs/02 §2.5).
  static String get apiBaseUrl => switch (flavor) {
        Flavor.prod => 'https://api.sinfagram.uz/v1',
        Flavor.pilot => 'https://pilot.sinfagram.uz/v1',
        Flavor.staging => 'https://staging.sinfagram.uz/v1',
        Flavor.local =>
          'http://10.0.2.2:3000/v1', // Android emulator → host localhost
      };

  static bool get isProdLike => flavor == Flavor.prod || flavor == Flavor.pilot;
}
