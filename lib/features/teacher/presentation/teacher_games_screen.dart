import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// Teacher games tab — battle scheduling (docs/07 T08) lands here. Placeholder
/// for now; nothing fabricated.
class TeacherGamesScreen extends ConsumerWidget {
  const TeacherGamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(title: Text(l.navGames)),
      body: SafeArea(
          child: EmptyState(
              icon: LucideIcons.swords,
              title: l.tGamesSchedule,
              message: l.tGamesSoon)),
    );
  }
}
