import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/class_extras/application/class_extras_controllers.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';

/// S32 — time capsule (docs/07). When open, the class can drop a note in; when
/// sealed, only the seal/open dates and the count show — the contents stay
/// hidden until the open date. Flat, centred, and safe up to 1.6x text scale.
class CapsuleScreen extends ConsumerWidget {
  const CapsuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final cap = ref.watch(capsuleProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.capsuleTitle)),
      body: SafeArea(
        // Centre when it fits, scroll when scaled text overflows.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.mailbox,
                            size: 48, color: colors.textTertiary),
                        const SizedBox(height: Space.lg),
                        if (cap.isOpen)
                          ..._open(context, ref, l, colors, cap)
                        else
                          ..._sealed(l, colors, cap),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Open state: invitation, seal date, note count, and the write action.
  List<Widget> _open(
    BuildContext context,
    WidgetRef ref,
    AppL10n l,
    AppColors colors,
    CapsuleState cap,
  ) {
    return [
      Text(
        l.capsuleOpenHint,
        textAlign: TextAlign.center,
        style: AppText.h3.copyWith(color: colors.textPrimary),
      ),
      const SizedBox(height: Space.sm),
      Text(
        l.capsuleSeals(cap.sealDate),
        textAlign: TextAlign.center,
        style: AppText.bodySm.copyWith(color: colors.textSecondary),
      ),
      const SizedBox(height: Space.xs),
      Text(
        l.capsuleNotes(cap.notes),
        textAlign: TextAlign.center,
        style: AppText.caption.copyWith(color: colors.textTertiary),
      ),
      const SizedBox(height: Space.xl),
      AppButton(
        l.capsuleWrite,
        variant: AppButtonVariant.primary,
        size: AppButtonSize.lg,
        icon: LucideIcons.send,
        // Once this device has left a note, the action rests (disabled) but
        // keeps its label so the state reads clearly.
        onPressed: cap.written ? null : () => _openWriteSheet(context, ref, l),
      ),
    ];
  }

  /// Sealed state: dates and count only — the notes themselves stay hidden.
  List<Widget> _sealed(AppL10n l, AppColors colors, CapsuleState cap) {
    return [
      Text(
        l.capsuleSealedOn(cap.sealDate),
        textAlign: TextAlign.center,
        style: AppText.h3.copyWith(color: colors.textPrimary),
      ),
      const SizedBox(height: Space.sm),
      Text(
        l.capsuleOpensOn(cap.openDate),
        textAlign: TextAlign.center,
        style: AppText.bodySm.copyWith(color: colors.textSecondary),
      ),
      const SizedBox(height: Space.xs),
      Text(
        l.capsuleNotes(cap.notes),
        textAlign: TextAlign.center,
        style: AppText.caption.copyWith(color: colors.textTertiary),
      ),
    ];
  }

  void _openWriteSheet(BuildContext context, WidgetRef ref, AppL10n l) {
    showAppBottomSheet<void>(
      context: context,
      child: Padding(
        // Lift the content above the keyboard, and give the sheet its gutter.
        padding: EdgeInsets.only(
          left: Space.gutter,
          right: Space.gutter,
          top: Space.md,
          bottom: Space.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(hintText: l.capsuleOpenHint),
            ),
            const SizedBox(height: Space.md),
            AppButton(
              l.actionSend,
              variant: AppButtonVariant.primary,
              size: AppButtonSize.lg,
              icon: LucideIcons.send,
              onPressed: () {
                ref.read(capsuleProvider.notifier).write();
                // Capture the messenger before the sheet context is torn down.
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                messenger.showSnackBar(
                  SnackBar(content: Text(l.capsuleSaved)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
