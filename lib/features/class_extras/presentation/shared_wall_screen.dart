import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/class_extras/application/class_extras_controllers.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// S17 — shared wall (docs/07). A collaborative pixel canvas placeholder:
/// a grid of tiles, a running contributor count, and one action to add your
/// mark. The count is a number, never a list of names.
class SharedWallScreen extends ConsumerWidget {
  const SharedWallScreen({super.key});

  static const int _tileCount = 25;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final w = ref.watch(wallProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.wallTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: Space.sm,
                    crossAxisSpacing: Space.sm,
                  ),
                  itemCount: _tileCount,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(Radii.control),
                      border: Border.all(
                        color: colors.border,
                        width: Stroke.hairline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              Text(
                l.wallContributors(w.contributors),
                style: AppText.bodySm.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: Space.sm),
              SizedBox(
                width: double.infinity,
                child: w.mine
                    ? AppButton(
                        l.wallDone,
                        onPressed: null,
                        icon: LucideIcons.plus,
                      )
                    : AppButton(
                        l.wallAdd,
                        onPressed: () =>
                            ref.read(wallProvider.notifier).contribute(),
                        icon: LucideIcons.plus,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
