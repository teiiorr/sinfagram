import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';

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
                  Space.xxl,
                  Space.gutter,
                  Space.lg,
                ),
                child: Column(
                  children: [
                    // Brand hero tile — a soft-cornered gradient block with a big
                    // white wordmark initial.
                    Reveal(
                      index: 0,
                      child: Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppGradients.hero,
                          borderRadius: BorderRadius.circular(Radii.card),
                          boxShadow: Shadows.lift,
                        ),
                        child: Text(
                          'S',
                          style: AppText.display.copyWith(
                            color: Colors.white,
                            fontSize: 46,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Space.lg),
                    Reveal(
                      index: 1,
                      child: Text(
                        l.appTitle,
                        textAlign: TextAlign.center,
                        style: AppText.h1.copyWith(color: colors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: Space.xs),
                    Reveal(
                      index: 2,
                      child: Text(
                        '${l.aboutVersion} 2.0.0',
                        textAlign: TextAlign.center,
                        style: AppText.body
                            .copyWith(color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: Space.sm),
                    Reveal(
                      index: 3,
                      child: Text(
                        // Product tagline — school social network. Inline: no
                        // dedicated l10n key exists yet (see report).
                        'Maktab ijtimoiy tarmogʻi',
                        textAlign: TextAlign.center,
                        style: AppText.bodySm
                            .copyWith(color: colors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: Space.lg),
                    Reveal(
                      index: 4,
                      child: Text(
                        l.aboutMinistry,
                        textAlign: TextAlign.center,
                        style: AppText.caption
                            .copyWith(color: colors.textTertiary),
                      ),
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
