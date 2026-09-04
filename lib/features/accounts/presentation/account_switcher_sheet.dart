import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/accounts/application/accounts_controller.dart';
import 'package:sinfagram/features/accounts/domain/account.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// Instagram-style account switcher (mock backend): a plain list of the hardcoded
/// accounts with the active one checked. Tapping one switches the whole app —
/// identity, profile, feed likes/reposts and story slides all follow, because
/// they are namespaced by the active account.
class AccountSwitcherSheet extends ConsumerWidget {
  const AccountSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final accounts = ref.watch(accountsProvider);
    final currentName = ref.watch(sessionProvider)?.displayName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Text(l.accountsTitle,
              style: AppText.h2.copyWith(color: colors.textPrimary)),
        ),
        for (final a in accounts)
          _AccountRow(
            account: a,
            selected: a.displayName == currentName,
            onTap: () => _switch(context, ref, a, l),
          ),
        const SizedBox(height: Space.sm),
      ],
    );
  }

  void _switch(BuildContext context, WidgetRef ref, Account a, AppL10n l) {
    if (ref.read(sessionProvider)?.displayName != a.displayName) {
      ref.read(sessionProvider.notifier).switchAccount(
            displayName: a.displayName,
            classLabel: a.classLabel,
          );
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.accountSwitched)));
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow(
      {required this.account, required this.selected, required this.onTap});

  final Account account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TapScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Row(
          children: [
            Avatar(name: account.displayName, size: 44),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppText.bodyStrong.copyWith(color: colors.textPrimary)),
                  Text(account.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySm
                          .copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
            if (selected)
              Icon(LucideIcons.check, size: 22, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
