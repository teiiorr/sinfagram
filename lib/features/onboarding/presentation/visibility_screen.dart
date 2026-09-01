import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// S08 — the visibility gate (docs/09). A mandatory, no-back step that spells out
/// exactly what a pupil's parent can and cannot see before the app opens. The
/// reader must scroll to the bottom before the acknowledge button unlocks, so the
/// whole page is genuinely put in front of them; content that already fits the
/// viewport counts as read. Pressing the button records [markVisibilitySeen] and
/// the router's redirect advances to `/class` — this screen never navigates itself.
class VisibilityScreen extends ConsumerStatefulWidget {
  const VisibilityScreen({super.key});

  @override
  ConsumerState<VisibilityScreen> createState() => _VisibilityScreenState();
}

class _VisibilityScreenState extends ConsumerState<VisibilityScreen> {
  // Pixel slack when comparing against maxScrollExtent — a fling can stop a
  // hair short of the exact bottom, and content that only just overflows should
  // still count as fully seen. docs/09 (S08).
  static const double _endTolerance = 8;

  final ScrollController _scrollController = ScrollController();

  // Latches true once the reader has reached the end (or the content fit without
  // scrolling); never flips back, so the button stays unlocked.
  bool _reachedEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // First layout: if everything already fits, there is nothing to scroll and
    // the reader has effectively seen all of it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reevaluateEnd());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_reachedEnd || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _endTolerance) {
      setState(() => _reachedEnd = true);
    }
  }

  // Safe to call from any phase: reads the live metrics and unlocks when the
  // content fits (or all but a tolerance of it) within the viewport.
  void _reevaluateEnd() {
    if (_reachedEnd || !mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent <= _endTolerance) {
      setState(() => _reachedEnd = true);
    }
  }

  void _acknowledge() {
    // The router watches seenVisibility and redirects to /class; no push here.
    ref.read(sessionProvider.notifier).markVisibilitySeen();
  }

  static List<String> _bullets(String raw) => raw
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = AppL10n.of(context);

    // No AppBar and canPop:false: this gate has no way back — the reader either
    // acknowledges it or stays on it.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.lg,
                  Space.gutter,
                  Space.md,
                ),
                child: Text(
                  l.visibilityTitle,
                  style: AppText.h1.copyWith(color: colors.textPrimary),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollMetricsNotification>(
                  // Metrics can change under a live text-scale or locale switch;
                  // re-check after the frame settles (never setState mid-layout).
                  onNotification: (_) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _reevaluateEnd());
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      Space.gutter,
                      0,
                      Space.gutter,
                      Space.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _VisibilitySection(
                          icon: LucideIcons.check,
                          iconColor: AppAccents.green,
                          heading: l.visibilitySees,
                          items: _bullets(l.visibilitySeesItems),
                          bulletColor: colors.success,
                          textColor: colors.textPrimary,
                        ),
                        const SizedBox(height: Space.md),
                        _VisibilitySection(
                          icon: LucideIcons.x,
                          iconColor: AppAccents.blue,
                          heading: l.visibilityNotSees,
                          items: _bullets(l.visibilityNotItems),
                          bulletColor: colors.textTertiary,
                          textColor: colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Pinned footer: a slightly raised surface with a single hairline
              // separates the action from the scrolling content beneath it.
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.border,
                      width: Stroke.hairline,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.md,
                  Space.gutter,
                  Space.md,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    l.actionUnderstood,
                    size: AppButtonSize.lg,
                    onPressed: _reachedEnd ? _acknowledge : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One labelled block of the gate: an icon-led heading and a list of bullet rows,
/// each row prefixed by a small status icon. Both the affirmative ("sees") and
/// the reassuring ("does not see") blocks share this layout, differing only in
/// icon and colour. Icons are decorative — the heading and bullet text carry the
/// meaning for a screen reader.
class _VisibilitySection extends StatelessWidget {
  const _VisibilitySection({
    required this.icon,
    required this.iconColor,
    required this.heading,
    required this.items,
    required this.bulletColor,
    required this.textColor,
  });

  final IconData icon;
  final Color iconColor;
  final String heading;
  final List<String> items;
  final Color bulletColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTile(icon, color: iconColor, size: 44),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  heading,
                  style: AppText.h3.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? Space.md : Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: bulletColor),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      items[i],
                      style: AppText.body.copyWith(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
