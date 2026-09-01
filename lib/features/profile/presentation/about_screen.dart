import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// S42 — About. App identity, version and the commissioning ministry, with the
/// author credit pinned to the bottom of the viewport. The credit sits outside
/// the scroll view so it stays anchored while the copy above it scrolls at a
/// large text scale.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.xl,
                  Space.gutter,
                  Space.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.appTitle,
                      style: AppText.h2.copyWith(color: colors.textPrimary),
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      '${l.aboutVersion} 1.0.0',
                      style: AppText.body.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: Space.md),
                    Text(
                      l.aboutMinistry,
                      style:
                          AppText.bodySm.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.gutter,
                Space.md,
                Space.gutter,
                Space.lg,
              ),
              // Author credit — kept verbatim.
              child: Text(
                'Designed & Developed by teiior',
                textAlign: TextAlign.center,
                style: AppText.caption.copyWith(color: colors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
