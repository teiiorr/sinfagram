import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/teacher/application/teacher_controllers.dart';
import 'package:sinfagram/features/teacher/domain/teacher.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// T02 — teacher class detail (docs/07 §7.9). The header states how many of the
/// roster have joined; a stack of action cards fans out to the class tools; the
/// roster lists every enrolled name. Flat throughout: cards carry a hairline
/// border, no elevation lift, and each row is a plain tappable surface.
class TeacherClassDetailScreen extends ConsumerWidget {
  const TeacherClassDetailScreen({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final classes = ref.watch(teacherClassesProvider);

    // Resolve the class by id. Fall back to the first class when the id is
    // unknown, and guard the empty list so the screen still renders a Scaffold.
    TeacherClass? cls;
    for (final c in classes) {
      if (c.id == classId) {
        cls = c;
        break;
      }
    }
    cls ??= classes.isNotEmpty ? classes.first : null;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.tClassDetail)),
      body: SafeArea(
        child: cls == null
            ? const SizedBox.shrink()
            : _body(context, ref, l, colors, cls),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    AppColors colors,
    TeacherClass cls,
  ) {
    final roster = ref.watch(teacherRosterProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.md, Space.gutter, Space.xxl),
      children: [
        // Header — class label and joined / roster count.
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cls.label,
                  style: AppText.h2.copyWith(color: colors.textPrimary)),
              const SizedBox(height: Space.xs),
              Text(l.tClassJoined(cls.joined, cls.rosterSize),
                  style: AppText.bodySm.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),

        // Class tools — each row navigates to a dedicated flow.
        _actionRow(
          context,
          colors,
          icon: LucideIcons.userPlus,
          accent: AppAccents.violet,
          label: l.tGenerateCode,
          onTap: () => context.push('/teacher/code'),
        ),
        const SizedBox(height: Space.sm),
        _actionRow(
          context,
          colors,
          icon: LucideIcons.upload,
          accent: AppAccents.blue,
          label: l.tImportTitle,
          onTap: () => context.push('/teacher/import'),
        ),
        const SizedBox(height: Space.sm),
        _actionRow(
          context,
          colors,
          icon: LucideIcons.megaphone,
          accent: AppAccents.teal,
          label: l.tAnnounceTitle,
          onTap: () => context.push('/teacher/announce'),
        ),
        const SizedBox(height: Space.sm),
        _actionRow(
          context,
          colors,
          icon: LucideIcons.calendarClock,
          accent: AppAccents.green,
          label: l.tScheduleTitle,
          onTap: () => context.push('/teacher/schedule'),
        ),
        const SizedBox(height: Space.sm),
        _actionRow(
          context,
          colors,
          icon: LucideIcons.messagesSquare,
          accent: AppAccents.amber,
          label: l.tChannelTitle,
          onTap: () => context.push('/teacher/channel'),
        ),
        const SizedBox(height: Space.sm),
        _actionRow(
          context,
          colors,
          icon: LucideIcons.bookOpen,
          accent: AppAccents.orange,
          label: l.tChronicleAdmin,
          onTap: () => context.push('/teacher/chronicle-admin'),
        ),
        const SizedBox(height: Space.lg),

        // Roster — section label then one row per enrolled name.
        Text(l.tRoster,
            style: AppText.label.copyWith(color: colors.textTertiary)),
        const SizedBox(height: Space.sm),
        for (final name in roster) ...[
          AppCard(
            child: Row(
              children: [
                Avatar(name: name, size: 28),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Text(name,
                      style: AppText.body.copyWith(color: colors.textPrimary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.sm),
        ],
      ],
    );
  }

  Widget _actionRow(
    BuildContext context,
    AppColors colors, {
    required IconData icon,
    required Color accent,
    required String label,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon, color: accent, size: 44),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(label,
                style: AppText.body.copyWith(color: colors.textPrimary)),
          ),
          Icon(LucideIcons.chevronRight, size: 18, color: colors.textTertiary),
        ],
      ),
    );
  }
}
