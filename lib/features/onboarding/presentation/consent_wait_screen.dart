import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// S07 — the parental-consent gate (docs/01, docs/04 §4.1 CONSENT_REQUIRED).
///
/// A quiet, empty-state-style hold screen. It is a gate, so there is no AppBar
/// and no way back — the router keeps a consent-pending session here until the
/// state flips. The real primary action is "resend the request" (a no-op toast
/// in this mock); the Phase 0 "Grant (mock)" button stands in for the parent
/// tapping approve, calling [SessionController.grantConsent]. This screen never
/// navigates by hand: once consent is granted the router redirect carries the
/// pupil on to /join/visibility.
///
/// Laid out to stay centered on tall screens yet scroll rather than overflow at
/// text scale 1.6 or in landscape (min-heights, never fixed heights).
class ConsentWaitScreen extends ConsumerWidget {
  const ConsentWaitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l = AppL10n.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(Space.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Decorative — the title carries the meaning.
                      Icon(
                        LucideIcons.clock,
                        size: Space.xl,
                        color: colors.textTertiary,
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        l.consentTitle,
                        textAlign: TextAlign.center,
                        style: AppText.h3.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: Space.xs),
                      Text(
                        l.consentBody,
                        textAlign: TextAlign.center,
                        style: AppText.bodySm
                            .copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: Space.xl),
                      // Mock affordance: stands in for the parent approving.
                      // Router redirect moves on once consent is granted.
                      AppButton(
                        'Grant (mock)',
                        onPressed: () =>
                            ref.read(sessionProvider.notifier).grantConsent(),
                        size: AppButtonSize.lg,
                      ),
                      const SizedBox(height: Space.sm),
                      AppButton(
                        l.consentResend,
                        onPressed: () => _showResent(context),
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.lg,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // No-op feedback for the resend action in Phase 0. ASCII, dev-only — there is
  // no request being sent yet, so this is intentionally not localized.
  void _showResent(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Sent')));
  }
}
