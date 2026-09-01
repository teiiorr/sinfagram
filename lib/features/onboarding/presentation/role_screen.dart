import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/auth/domain/session.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S03 — role selection (docs/01 §1.3).
///
/// Three stacked option cards. Only the pupil path is wired for Phase 0: it
/// records the transient role choice and hands off to the class-code step, where
/// the router's onboarding allow-list lets a still-null session through. Teacher
/// and parent are stubbed — they record the choice (so the flow is ready to grow)
/// and surface a plain "coming soon" note without leaving this screen, keeping
/// the pupil path the only one that actually advances.
class RoleScreen extends ConsumerWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.roleTitle)),
      body: SafeArea(
        // A ListView (not a fixed Column) so the three cards keep scrolling into
        // reach at text scale 1.6 and in landscape.
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.lg,
            Space.gutter,
            Space.xxl,
          ),
          children: [
            _RoleOption(
              icon: LucideIcons.graduationCap,
              accent: AppAccents.violet,
              title: l.rolePupil,
              subtitle: l.rolePupilSub,
              onTap: () {
                ref.read(sessionProvider.notifier).chooseRole(AppRole.pupil);
                context.go('/join/code');
              },
            ),
            const SizedBox(height: Space.md),
            _RoleOption(
              icon: LucideIcons.presentation,
              accent: AppAccents.blue,
              title: l.roleTeacher,
              subtitle: l.roleTeacherSub,
              onTap: () {
                ref.read(sessionProvider.notifier).chooseRole(AppRole.teacher);
                // Mock staff sign-in; the router redirect lands on the teacher shell.
                ref.read(sessionProvider.notifier).completeTeacherSignIn();
              },
            ),
            const SizedBox(height: Space.md),
            _RoleOption(
              icon: LucideIcons.users,
              accent: AppAccents.teal,
              title: l.roleParent,
              subtitle: l.roleParentSub,
              onTap: () {
                ref.read(sessionProvider.notifier).chooseRole(AppRole.parent);
                // Mock OTP sign-in; the router redirect lands on the parent shell.
                ref.read(sessionProvider.notifier).completeParentSignIn();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// One large, tappable role card: a subtle icon chip, a title and a one-line
/// explanation, and a trailing affordance. The icon and chevron are purely
/// decorative — the title carries the meaning and the whole card is the button —
/// so they stay out of the accessibility tree.
class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // Fixed-size colourful icon tile (holds no text, so it never grows).
          IconTile(icon, color: accent, size: 44),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.h3.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: Space.xs),
                Text(
                  subtitle,
                  style: AppText.bodySm.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          Icon(LucideIcons.chevronRight, size: 20, color: colors.textTertiary),
        ],
      ),
    );
  }
}
