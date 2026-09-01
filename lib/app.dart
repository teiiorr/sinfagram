import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/app/ui_prefs.dart';
import 'core/localization/l10n/app_l10n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root of the single Flutter binary. Role-based shells (docs/02 §2.2) are wired
/// in later phases; Phase 0 boots straight into the component gallery.
class SinfagramApp extends ConsumerWidget {
  const SinfagramApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppL10n.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      routerConfig: router,
    );
  }
}
