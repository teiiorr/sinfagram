import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/app/ui_prefs.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/app_banner.dart';
import 'package:sinfagram/shared/widgets/app_bottom_sheet.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/app_chip.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/post_card.dart';
import 'package:sinfagram/shared/widgets/skeleton_block.dart';

/// Phase 0 demo (docs/14): every component in every state, switchable across the
/// two themes and four locales. Not a shipping screen — the section labels are
/// intentionally plain ASCII (dev-only) so they need no localization.
class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l = AppL10n.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Component gallery')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Space.gutter, Space.md, Space.gutter, Space.xxl),
        children: [
          _switchers(context, ref),
          const SizedBox(height: Space.lg),
          _section(colors, 'Buttons'),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(l.actionSend, onPressed: () {}, icon: LucideIcons.send),
              AppButton('Secondary',
                  onPressed: () {}, variant: AppButtonVariant.secondary),
              AppButton('Ghost',
                  onPressed: () {}, variant: AppButtonVariant.ghost),
              AppButton('Danger',
                  onPressed: () {}, variant: AppButtonVariant.danger),
              const AppButton('Disabled', onPressed: null),
              AppButton('Loading', onPressed: () {}, loading: true),
              AppButton('Large', onPressed: () {}, size: AppButtonSize.lg),
            ],
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Text fields'),
          const AppTextField(label: 'Ism', hint: 'Ismingizni kiriting'),
          const SizedBox(height: Space.md),
          const AppTextField(label: 'Email', errorText: 'Notoʻgʻri format'),
          const SizedBox(height: Space.md),
          const AppTextField(
              label: 'Bio', maxLength: 20, maxLines: 2, hint: 'Qisqa bio'),
          const SizedBox(height: Space.lg),
          _section(colors, 'Chips'),
          const Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              AppChip('Neutral'),
              AppChip('Primary', variant: AppChipVariant.primary),
              AppChip('Success',
                  variant: AppChipVariant.success, icon: LucideIcons.check),
              AppChip('Warning', variant: AppChipVariant.warning),
              AppChip('Accent',
                  variant: AppChipVariant.accent, icon: LucideIcons.award),
            ],
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Card'),
          AppCard(
            onTap: () {},
            child: Text('Tappable card',
                style: AppText.body.copyWith(color: colors.textPrimary)),
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Post card'),
          PostCard(
            authorName: 'Dilnoza Rahimova',
            timeLabel: '2 soat oldin',
            body:
                'Bugungi biologiya darsi juda qiziqarli oʻtdi. Ertaga laboratoriya ishi bor.',
            hasPhoto: true,
            thanksLabel: l.thanks,
            thankedByMe: false,
            onThanks: () {},
            commentLabel: 'Izoh 4',
            onComment: () {},
            onReport: () {},
            onMore: () {},
          ),
          const SizedBox(height: Space.sm),
          PostCard(
            authorName: 'Jasur Toshmatov',
            timeLabel: 'hozir',
            body: 'Bu post koʻrib chiqilmoqda.',
            thanksLabel: l.thanks,
            thankedByMe: true,
            commentLabel: 'Izoh 0',
            heldForReview: true,
            waitingLabel: 'Tekshiruvda',
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Empty state'),
          AppCard(
            child: EmptyState(
              icon: LucideIcons.inbox,
              title: l.emptyTitle,
              message: l.emptyBody,
              action: AppButton(l.actionRetry,
                  onPressed: () {},
                  variant: AppButtonVariant.ghost,
                  icon: LucideIcons.refreshCw),
            ),
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Skeletons'),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBlock(width: 160, height: 16),
                SizedBox(height: Space.sm),
                SkeletonBlock(height: 12),
                SizedBox(height: Space.xs),
                SkeletonBlock(width: 220, height: 12),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),
          _section(colors, 'Banner'),
          AppBanner(l.bannerOffline, onDismiss: () {}),
          const SizedBox(height: Space.lg),
          _section(colors, 'Bottom sheet'),
          AppButton(
            'Open sheet',
            variant: AppButtonVariant.secondary,
            icon: LucideIcons.panelBottom,
            onPressed: () => _openSheet(context, l),
          ),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context, AppL10n l) {
    showAppBottomSheet<void>(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(Space.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bottom sheet',
                style: AppText.h2.copyWith(color: context.colors.textPrimary)),
            const SizedBox(height: Space.sm),
            Text(l.composeReview,
                style:
                    AppText.body.copyWith(color: context.colors.textSecondary)),
            const SizedBox(height: Space.lg),
            AppButton(l.actionCancel,
                onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }

  Widget _section(AppColors colors, String title) => Padding(
        padding: const EdgeInsets.only(bottom: Space.sm),
        child: Text(title.toUpperCase(),
            style: AppText.label
                .copyWith(color: colors.textTertiary, letterSpacing: 0.6)),
      );

  Widget _switchers(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final colors = context.colors;

    Widget seg<T>(String label, T value, T current, ValueChanged<T> onTap) {
      final selected = value == current;
      return Padding(
        padding: const EdgeInsets.only(right: Space.xs, bottom: Space.xs),
        child: AppButton(
          label,
          variant:
              selected ? AppButtonVariant.primary : AppButtonVariant.secondary,
          onPressed: () => onTap(value),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(colors, 'Theme'),
          Wrap(children: [
            seg('System', ThemeMode.system, mode,
                (v) => ref.read(themeModeProvider.notifier).state = v),
            seg('Light', ThemeMode.light, mode,
                (v) => ref.read(themeModeProvider.notifier).state = v),
            seg('Dark', ThemeMode.dark, mode,
                (v) => ref.read(themeModeProvider.notifier).state = v),
          ]),
          const SizedBox(height: Space.sm),
          _section(colors, 'Locale'),
          Wrap(children: [
            seg('System', null, locale,
                (v) => ref.read(localeProvider.notifier).state = v),
            seg('uz', const Locale('uz'), locale,
                (v) => ref.read(localeProvider.notifier).state = v),
            seg(
                'uz-Cyrl',
                const Locale.fromSubtags(
                    languageCode: 'uz', scriptCode: 'Cyrl'),
                locale,
                (v) => ref.read(localeProvider.notifier).state = v),
            seg('ru', const Locale('ru'), locale,
                (v) => ref.read(localeProvider.notifier).state = v),
            seg('kaa', const Locale('kaa'), locale,
                (v) => ref.read(localeProvider.notifier).state = v),
          ]),
        ],
      ),
    );
  }
}
