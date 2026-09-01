import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_text_field.dart';

/// S06 — the pupil sets a 6-digit PIN and repeats it to confirm.
///
/// Owns two controllers and a single mismatch flag, so it is a
/// [ConsumerStatefulWidget]. Continue enables only when both entries are exactly
/// six digits; on a match it hands off to [SessionController.completePupilSignIn]
/// and lets the router redirect carry the user to /join/visibility — this screen
/// never navigates by hand. On a mismatch the second field turns red with
/// [AppL10n.pinMismatch]; the flag is derived into an error string at build time
/// rather than stored, so a mid-flow locale change still reads correctly.
class JoinPinScreen extends ConsumerStatefulWidget {
  const JoinPinScreen({super.key});

  @override
  ConsumerState<JoinPinScreen> createState() => _JoinPinScreenState();
}

class _JoinPinScreenState extends ConsumerState<JoinPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  // Set when the two entries differ on submit; cleared the moment either field
  // is edited so the field is never stuck red while the user retypes.
  bool _mismatch = false;

  // Exactly six digits — the field caps length at 6, this also rejects any
  // stray non-digit the platform keyboard might let through.
  static final RegExp _sixDigits = RegExp(r'^\d{6}$');

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_handleChanged);
    _repeatController.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  bool _isComplete(String value) => _sixDigits.hasMatch(value);

  // Every keystroke rebuilds so Continue can re-evaluate; clearing the mismatch
  // is the only state that actually changes.
  void _handleChanged() {
    if (_mismatch) {
      setState(() => _mismatch = false);
    } else {
      setState(() {});
    }
  }

  void _submit() {
    if (_pinController.text == _repeatController.text) {
      // Router redirect advances to /join/visibility once the session exists.
      ref.read(sessionProvider.notifier).completePupilSignIn();
    } else {
      setState(() => _mismatch = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = AppL10n.of(context);

    final bool canContinue =
        _isComplete(_pinController.text) && _isComplete(_repeatController.text);

    return Scaffold(
      appBar: AppBar(title: Text(l.pinTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.lg,
            Space.gutter,
            Space.xxl,
          ),
          children: [
            AppTextField(
              controller: _pinController,
              label: l.pinTitle,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: Space.md),
            AppTextField(
              controller: _repeatController,
              label: l.pinRepeat,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              errorText: _mismatch ? l.pinMismatch : null,
            ),
            const SizedBox(height: Space.sm),
            Text(
              l.pinHint,
              style: AppText.bodySm.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: Space.xl),
            AppButton(
              l.actionContinue,
              onPressed: canContinue ? _submit : null,
              size: AppButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
