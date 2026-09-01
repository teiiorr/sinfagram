import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's single [SharedPreferences] handle. It is created asynchronously in
/// `main()` and injected via a ProviderScope override, so every controller can
/// read/write local persistence synchronously.
///
/// Until the real backend + drift cache land (docs/11), this is how
/// user-generated content — the pupil's own profile, story slides, composed
/// posts and private thanks — survives an app restart.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
      'sharedPrefsProvider must be overridden in main() with the resolved instance'),
);
