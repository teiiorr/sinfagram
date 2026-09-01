import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// UI preferences that the theme/locale respond to. Persistence lands in a later
/// phase; for now these drive the runtime switch (system by default).
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

/// null = follow the system locale.
final localeProvider = StateProvider<Locale?>((_) => null);
