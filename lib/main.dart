import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/storage/prefs.dart';

// Sinfagram — single Flutter binary (docs/02). Riverpod is the only state layer.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  // Resolve local persistence once, then inject it so controllers can hydrate
  // their state synchronously (profile, stories, composed posts, thanks).
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const SinfagramApp(),
    ),
  );
}
