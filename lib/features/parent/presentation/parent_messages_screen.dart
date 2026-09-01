import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// Parent messages (docs/01 §1.4: a parent may message a teacher — the one
/// permitted channel). Mock; the compose flow lands with the messaging layer.
class ParentMessagesScreen extends ConsumerWidget {
  const ParentMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.pNavMessages)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: EmptyState(
                    icon: LucideIcons.messageCircle,
                    title: l.pMessagesEmpty,
                    message: '')),
            Padding(
              padding: const EdgeInsets.all(Space.gutter),
              child: AppButton(
                l.pMessageTeacher,
                size: AppButtonSize.lg,
                icon: LucideIcons.send,
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l.pMessageTeacher))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
