import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';

/// S04 — join a class by its six-digit code (docs/07).
///
/// A pupil reaches this from the role picker. The heading carries the full
/// instruction; a single numeric field takes the code. A valid code advances to
/// the roster; a rejected one surfaces inline on the field — never a dialog
/// (docs/05 §5.6). Stateful because it owns the text controller and the
/// rejected-code flag.
class JoinCodeScreen extends ConsumerStatefulWidget {
  const JoinCodeScreen({super.key});

  @override
  ConsumerState<JoinCodeScreen> createState() => _JoinCodeScreenState();
}

class _JoinCodeScreenState extends ConsumerState<JoinCodeScreen> {
  /// The class code is exactly six digits (docs/07 §S04).
  static const int _codeLength = 6;

  final TextEditingController _controller = TextEditingController();

  /// Raised only by a rejected submit and cleared the instant the pupil edits,
  /// so a stale "wrong code" never lingers over a code they are already fixing.
  /// Kept as a flag rather than the message string so the error re-resolves
  /// through [AppL10n] if the locale changes while it is showing.
  bool _rejected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Six characters entered. The button gates on length only; digit validity is
  /// left to [SessionController.submitClassCode] so a mistyped code still reaches
  /// the inline error path rather than being silently un-submittable.
  bool get _complete => _controller.text.length == _codeLength;

  void _onChanged(String _) {
    // Rebuild so the button tracks the length, and drop any prior rejection.
    setState(() => _rejected = false);
  }

  void _submit() {
    final accepted =
        ref.read(sessionProvider.notifier).submitClassCode(_controller.text);
    if (accepted) {
      context.go('/join/roster');
    } else {
      setState(() => _rejected = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = AppL10n.of(context);

    return Scaffold(
      // Back-only bar; the code prompt is the h2 heading in the body below.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          // Framework-localised label — spoken by a11y, no hardcoded string.
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/role'),
        ),
      ),
      body: SafeArea(
        // Scrolls rather than clips at text scale 1.6.
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.md,
            Space.gutter,
            Space.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.codeTitle,
                style: AppText.h2.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: Space.lg),
              AppTextField(
                controller: _controller,
                label: l.codeTitle,
                keyboardType: TextInputType.number,
                maxLength: _codeLength,
                errorText: _rejected ? l.codeError : null,
                onChanged: _onChanged,
              ),
              const SizedBox(height: Space.sm),
              Text(
                l.codeHelp,
                style: AppText.bodySm.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: Space.lg),
              AppButton(
                l.actionContinue,
                size: AppButtonSize.lg,
                onPressed: _complete ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
