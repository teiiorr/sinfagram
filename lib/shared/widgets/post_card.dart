import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/post_video.dart';

/// A single feed post. docs/05 §5.5.
///
/// Self-contained by design: it renders its own initials avatar and its own
/// "waiting for review" chip inline rather than importing sibling components,
/// so the feed can drop it in without pulling the rest of the widget library.
///
/// The thanks control reflects the *viewer's own* state ([thankedByMe]) — it is
/// a private toggle, never a public tally, so no count is ever shown.
///
/// Double-tapping the card expresses thanks (Instagram-style) with a heart-burst
/// animation: it only ever *adds* thanks (never removes), and it replays the
/// burst even when already thanked. The explicit heart control still toggles.
class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.authorName,
    required this.timeLabel,
    required this.body,
    this.hasPhoto = false,
    this.photoPath,
    this.videoPath,
    required this.thanksLabel,
    required this.thankedByMe,
    this.onThanks,
    required this.commentLabel,
    this.onComment,
    this.onReport,
    this.onMore,
    this.onRepost,
    this.repostedByMe = false,
    this.repostLabel = '',
    this.repostedMarker,
    this.heldForReview = false,
    this.waitingLabel,
  });

  final String authorName;
  final String timeLabel;
  final String body;
  final bool hasPhoto;

  /// Local file path of an attached image; when present it is rendered, else the
  /// neutral placeholder is shown.
  final String? photoPath;

  /// Local file path of an attached video; when present it plays inline (takes
  /// precedence over a photo).
  final String? videoPath;

  final String thanksLabel;
  final bool thankedByMe;
  final VoidCallback? onThanks;

  final String commentLabel;
  final VoidCallback? onComment;
  final VoidCallback? onReport;
  final VoidCallback? onMore;

  /// Repost (re-share) — Instagram/Threads style, count-less.
  final VoidCallback? onRepost;
  final bool repostedByMe;
  final String repostLabel;

  /// Optional "You reposted" marker shown above the header (when this card is a
  /// repost surfaced on a profile).
  final String? repostedMarker;

  final bool heldForReview;
  final String? waitingLabel;

  /// Instagram like red.
  static const Color _likeRed = Color(0xFFED4956);
  static const String _repostSemantics = 'repost';

  // Icon-only affordance semantics. The public signature is fixed by the gallery
  // and carries no parameter for these, and the spec pins the literals — so they
  // live here as constants rather than as constructor params.
  static const String _moreSemantics = 'more';
  static const String _reportSemantics = 'report';

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 680),
  );

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  /// Double-tap always *expresses* thanks: it adds thanks if not already given,
  /// and replays the heart burst either way. Never removes thanks.
  void _onDoubleTap() {
    if (widget.heldForReview) return;
    HapticFeedback.selectionClick();
    if (!widget.thankedByMe) widget.onThanks?.call();
    if (!reduceMotion(context)) _burst.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Stroke.hairline),
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: Shadows.card,
      ),
      // Material hosts the ink for the inner controls and clips their splash to
      // the card radius; the separation itself is carried by the border, not lift.
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.repostedMarker != null &&
                  widget.repostedMarker!.isNotEmpty) ...[
                _buildRepostMarker(context, widget.repostedMarker!),
                const SizedBox(height: Space.sm),
              ],
              _buildHeader(context),
              if (widget.body.isNotEmpty) ...[
                const SizedBox(height: Space.sm),
                Text(
                  widget.body,
                  style: AppText.body.copyWith(color: colors.textPrimary),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (widget.videoPath != null && widget.videoPath!.isNotEmpty) ...[
                const SizedBox(height: Space.sm),
                _buildVideo(context),
              ] else if (widget.hasPhoto) ...[
                const SizedBox(height: Space.sm),
                _buildPhoto(context),
              ],
              // A post awaiting moderation shows no way to act on it yet.
              if (!widget.heldForReview) ...[
                const SizedBox(height: Space.sm),
                _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );

    // Double-tap-to-thank sits over the whole card; single taps on the inner
    // controls still win the gesture arena, so nothing existing is blocked.
    card = GestureDetector(
      onDoubleTap: _onDoubleTap,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          card,
          Positioned.fill(child: _burstOverlay()),
        ],
      ),
    );

    // A held post is dimmed whole so it reads as present-but-pending, not broken.
    if (widget.heldForReview) {
      card = Opacity(opacity: 0.6, child: card);
    }

    // The card repaints independently of the scrolling feed around it.
    return RepaintBoundary(child: card);
  }

  /// The centered heart that scales up with a soft overshoot and fades out.
  /// Non-interactive, and renders nothing while at rest.
  Widget _burstOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _burst,
        builder: (context, _) {
          final t = _burst.value;
          if (t == 0) return const SizedBox.shrink();
          // Fade in fast, hold, then out.
          final opacity = t < 0.15
              ? t / 0.15
              : (t > 0.6 ? (1 - (t - 0.6) / 0.4).clamp(0.0, 1.0) : 1.0);
          // Scale with a gentle overshoot via easeOutBack.
          final scale = 0.4 + Curves.easeOutBack.transform(t.clamp(0.0, 1.0)) * 0.75;
          return Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: const Icon(
                  Icons.favorite,
                  size: 96,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Color(0x8CED4956), blurRadius: 24),
                    Shadow(color: Colors.black26, blurRadius: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final showWaiting = widget.heldForReview && widget.waitingLabel != null;
    return Row(
      children: [
        Expanded(
          // Identity (avatar + name + time) collapses to one semantics node so a
          // screen reader announces the author once; the trailing controls stay
          // separate and keep their own tap semantics.
          child: MergeSemantics(
            child: Row(
              children: [
                _buildAvatar(context),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.authorName,
                        style: AppText.bodyStrong
                            .copyWith(color: context.colors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.timeLabel,
                        style: AppText.caption
                            .copyWith(color: context.colors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showWaiting) ...[
          _buildWaitingChip(context, widget.waitingLabel!),
          const SizedBox(width: Space.sm),
        ],
        _iconButton(
          context,
          icon: LucideIcons.moreHorizontal,
          semanticsLabel: PostCard._moreSemantics,
          onTap: widget.onMore,
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials(widget.authorName),
        style: AppText.label.copyWith(color: colors.primary),
      ),
    );
  }

  Widget _buildWaitingChip(BuildContext context, String label) {
    final colors = context.colors;
    return ConstrainedBox(
      // Min-height floor, not a fixed height, so the label survives text scaling.
      constraints: const BoxConstraints(minHeight: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.sm,
          vertical: Space.xs,
        ),
        decoration: BoxDecoration(
          color: colors.warningSubtle,
          borderRadius: BorderRadius.circular(Radii.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.clock, size: 14, color: colors.warning),
            const SizedBox(width: Space.xs),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: colors.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(BuildContext context) {
    final path = widget.photoPath;
    if (path != null && path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Radii.control),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            // If the file went away (cache cleared), fall back to the placeholder.
            errorBuilder: (context, _, __) => _photoPlaceholder(context),
          ),
        ),
      );
    }
    return _photoPlaceholder(context);
  }

  Widget _buildVideo(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.control),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: PostVideo(path: widget.videoPath!),
      ),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.skeleton,
          borderRadius: BorderRadius.circular(Radii.control),
        ),
      ),
    );
  }

  Widget _buildRepostMarker(BuildContext context, String label) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.repeat2, size: 14, color: colors.textTertiary),
        const SizedBox(width: Space.xs),
        Flexible(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.textTertiary)),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        // Like — a filled red heart when liked (Instagram), outline otherwise.
        _labelledControl(
          context,
          icon: widget.thankedByMe ? Icons.favorite : LucideIcons.heart,
          label: widget.thanksLabel,
          active: widget.thankedByMe,
          activeColor: PostCard._likeRed,
          onTap: widget.onThanks,
        ),
        _labelledControl(
          context,
          icon: LucideIcons.messageCircle,
          label: widget.commentLabel,
          active: false,
          onTap: widget.onComment,
        ),
        // Repost — green when active (Threads/Instagram repost).
        if (widget.onRepost != null)
          _labelledControl(
            context,
            icon: LucideIcons.repeat2,
            label: widget.repostLabel,
            active: widget.repostedByMe,
            activeColor: colors.success,
            onTap: widget.onRepost,
          ),
        const Spacer(),
        _iconButton(
          context,
          icon: LucideIcons.flag,
          semanticsLabel: PostCard._reportSemantics,
          onTap: widget.onReport,
        ),
      ],
    );
  }

  /// Icon + label control with a 44px-tall touch target. Its label supplies the
  /// accessible name, so no extra Semantics label is needed.
  Widget _labelledControl(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool active,
    Color? activeColor,
    VoidCallback? onTap,
  }) {
    final colors = context.colors;
    final Color tint =
        active ? (activeColor ?? colors.primary) : colors.textSecondary;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.control),
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: tint),
                if (label.isNotEmpty) ...[
                  const SizedBox(width: Space.xs),
                  Text(label, style: AppText.label.copyWith(color: tint)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Icon-only control sized to a 44x44 target with a required Semantics label.
  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required String semanticsLabel,
    VoidCallback? onTap,
  }) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(icon, size: 20, color: colors.textSecondary),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
