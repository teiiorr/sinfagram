import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/remote_config.dart';

/// Night mode / lesson mode gate content but never the board, settings or about
/// (docs/07 §7.1 redirect rules 5–6). Enforced server-side in production; here it
/// is computed from time + config, with a settings override so the interstitials
/// are reachable for review at any hour.
enum AppMode { normal, night, lesson }

/// Settings/debug override; null = compute from the clock and config.
final modeOverrideProvider = StateProvider<AppMode?>((_) => null);

final appModeProvider = Provider<AppMode>((ref) {
  final override = ref.watch(modeOverrideProvider);
  if (override != null) return override;

  const cfg = RemoteConfig.defaults;
  final startH = int.tryParse(cfg.nightModeStart.split(':').first) ?? 22;
  final endH = int.tryParse(cfg.nightModeEnd.split(':').first) ?? 6;
  final h = TimeOfDay.fromDateTime(DateTime.now()).hour;
  // Night wraps midnight (22:00 → 06:00).
  final isNight =
      startH > endH ? (h >= startH || h < endH) : (h >= startH && h < endH);
  return isNight ? AppMode.night : AppMode.normal;
});

/// Reopen time shown on the night screen.
String nightReopenTime(WidgetRef ref) => RemoteConfig.defaults.nightModeEnd;
