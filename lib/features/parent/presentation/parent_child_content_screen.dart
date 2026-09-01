import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/parent/application/parent_controllers.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';

/// P02 — child's published content (docs/07 §7.10). Chronological, and nothing
/// else: no read history, no drafts, no private messages (there are none).
class ParentChildContentScreen extends ConsumerWidget {
  const ParentChildContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final posts = ref.watch(childContentProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.pChildContent)),
      body: SafeArea(
        child: posts.isEmpty
            ? EmptyState(
                icon: LucideIcons.messageSquare,
                title: l.pChildContentEmpty,
                message: '')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.md, Space.gutter, Space.xxl),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: Space.sm),
                itemBuilder: (context, i) {
                  final p = posts[i];
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.timeLabel,
                            style: AppText.caption
                                .copyWith(color: colors.textTertiary)),
                        const SizedBox(height: Space.xs),
                        Text(p.body,
                            style: AppText.body
                                .copyWith(color: colors.textPrimary)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
