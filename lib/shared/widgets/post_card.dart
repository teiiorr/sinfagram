import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/post_video.dart';

/// A single feed post — Instagram layout. docs/05 §5.5.
///
/// A post is NOT a card: no radius, no shadow, no border on the block itself.
/// Consecutive posts are separated by a single hairline divider. The media is
/// full-bleed (edge to edge, radius 0); everything else (header, actions,
/// caption) sits on the 16px content gutter.
///
/// Self-contained by design: it renders its own initials avatar and its own
/// "waiting for review" chip inline rather than importing sibling components,
/// so the feed can drop it in without pulling the rest of the widget library.
///
/// The thanks control reflects the *viewer's own* state ([thankedByMe]) — it is
/// a private toggle, never a public tally, so no count is ever shown.
///
/// Double-tapping the post expresses thanks (Instagram-style) with a heart-burst
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

  /// Report is anonymous and reached from the "more" menu; the param is kept for
  /// API stability even though the feed post no longer shows a report control.
  final VoidCallback? onReport;
  final VoidCallback? onMore;

  /// Repost (re-share) — Instagram/Threads style, count-less and icon-only.
  final VoidCallback? onRepost;
  final bool repostedByMe;

  /// Kept for API stability; the repost control is icon-only, so no label shows.
  final String repostLabel;

  /// Kept for API stability; the "You reposted" marker is no longer rendered.
  final String? repostedMarker;

  final bool heldForReview;
  final String? waitingLabel;

  // Icon-only affordance semantics. The public signature is fixed by the gallery
  // and carries no parameter for these, and the spec pins the literals — so they
  // live here as constants rather than as constructor params.
  static const String _moreSemantics = 'more';
  static const String _shareSemantics = 'share';
  static const String _saveSemantics = 'save';

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

    final hasVideo = widget.videoPath != null && widget.videoPath!.isNotEmpty;
    final hasMedia = hasVideo || widget.hasPhoto;

    Widget post = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        if (hasMedia) ...[
          if (hasVideo) _buildVideo(context) else _buildPhoto(context),
        ],
        // A post awaiting moderation shows no way to act on it yet.
        if (!widget.heldForReview) _buildActions(context),
        if (widget.body.isNotEmpty) _buildCaption(context),
        if (widget.commentLabel.isNotEmpty) _buildCommentLink(context),
        _buildTime(context),
        const SizedBox(height: Space.sm),
      ],
    );

    // A hairline divider separates one post from the next — the only stroke on
    // the block (a post is not a card, so no radius/shadow/enclosing border).
    post = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: Stroke.hairline),
        ),
      ),
      // Material hosts the ink for the inner controls.
      child: Material(type: MaterialType.transparency, child: post),
    );

    // Double-tap-to-thank sits over the whole post; single taps on the inner
    // controls still win the gesture arena, so nothing existing is blocked.
    post = GestureDetector(
      onDoubleTap: _onDoubleTap,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          post,
          Positioned.fill(child: _burstOverlay()),
        ],
      ),
    );

    // A held post is dimmed whole so it reads as present-but-pending, not broken.
    if (widget.heldForReview) {
      post = Opacity(opacity: 0.6, child: post);
    }

    // The post repaints independently of the scrolling feed around it.
    return RepaintBoundary(child: post);
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
          final scale =
              0.4 + Curves.easeOutBack.transform(t.clamp(0.0, 1.0)) * 0.75;
          return Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: const Icon(
                  Icons.favorite,
                  size: 90,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Color(0x8C000000), blurRadius: 16),
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
    final colors = context.colors;
    final showWaiting = widget.heldForReview && widget.waitingLabel != null;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Space.gutter, vertical: Space.sm),
      child: Row(
        children: [
          Expanded(
            // Identity (avatar + name + time) collapses to one semantics node so
            // a screen reader announces the author once; the trailing controls
            // stay separate and keep their own tap semantics.
            child: MergeSemantics(
              child: Row(
                children: [
                  _buildAvatar(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: widget.authorName,
                            style: AppText.bodyStrong
                                .copyWith(color: colors.textPrimary),
                          ),
                          TextSpan(
                            text: ' · ',
                            style: AppText.bodySm
                                .copyWith(color: colors.textSecondary),
                          ),
                          TextSpan(
                            text: widget.timeLabel,
                            style: AppText.bodySm
                                .copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          _headerIconButton(
            context,
            icon: LucideIcons.moreHorizontal,
            semanticsLabel: PostCard._moreSemantics,
            onTap: widget.onMore,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        shape: BoxShape.circle,
        border: Border.all(color: colors.border, width: Stroke.hairline),
      ),
      child: Text(
        _initials(widget.authorName),
        textScaler: TextScaler.noScaling,
        style: AppText.caption.copyWith(color: colors.textSecondary),
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
      return AspectRatio(
        aspectRatio: 1,
        child: Image.file(
          File(path),
          width: double.infinity,
          fit: BoxFit.cover,
          // If the file went away (cache cleared), fall back to the placeholder.
          errorBuilder: (context, _, __) => _photoPlaceholder(context),
        ),
      );
    }
    return _photoPlaceholder(context);
  }

  Widget _buildVideo(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PostVideo(path: widget.videoPath!),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ColoredBox(color: context.colors.skeleton),
    );
  }

  Widget _buildActions(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      child: Row(
        children: [
          // Like — a filled red heart when liked (Instagram), outline otherwise.
          _actionIcon(
            context,
            icon: widget.thankedByMe ? Icons.favorite : LucideIcons.heart,
            semanticsLabel: widget.thanksLabel,
            color: widget.thankedByMe ? colors.danger : colors.textPrimary,
            onTap: widget.onThanks,
          ),
          _actionIcon(
            context,
            icon: LucideIcons.messageCircle,
            semanticsLabel: widget.commentLabel,
            onTap: widget.onComment,
          ),
          _actionIcon(
            context,
            icon: LucideIcons.send,
            semanticsLabel: PostCard._shareSemantics,
          ),
          const Spacer(),
          // Repost — count-less and icon-only; active reads as solid black, never
          // green, and carries no label.
          if (widget.onRepost != null)
            _actionIcon(
              context,
              icon: LucideIcons.repeat2,
              semanticsLabel:
                  widget.repostLabel.isEmpty ? 'repost' : widget.repostLabel,
              color: colors.textPrimary,
              onTap: widget.onRepost,
            ),
          _actionIcon(
            context,
            icon: LucideIcons.bookmark,
            semanticsLabel: PostCard._saveSemantics,
          ),
        ],
      ),
    );
  }

  /// Icon-only action sized to a 44x44 touch target with an accessible name.
  /// The 44px targets sit adjacent, which reads as the Instagram action bar
  /// while keeping every control above the minimum tap size.
  Widget _actionIcon(
    BuildContext context, {
    required IconData icon,
    required String semanticsLabel,
    Color? color,
    VoidCallback? onTap,
  }) {
    final colors = context.colors;
    return Semantics(
      button: onTap != null,
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
            child: Icon(icon, size: 24, color: color ?? colors.textPrimary),
          ),
        ),
      ),
    );
  }

  /// The header overflow control: a 20px glyph in a 44x44 tap target (the
  /// accessibility floor holds even for this compact control).
  Widget _headerIconButton(
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
        radius: 22,
        splashColor: colors.primary.withValues(alpha: 0.06),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(icon, size: 20, color: colors.textPrimary),
          ),
        ),
      ),
    );
  }

  /// Caption: author (600) then the body (14/400) on the same run, clamped to
  /// two lines with an ellipsis standing in for the inline "more".
  Widget _buildCaption(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.xs),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.authorName,
              style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: widget.body,
              style: AppText.body.copyWith(color: colors.textPrimary),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCommentLink(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Semantics(
        button: widget.onComment != null,
        child: InkWell(
          onTap: widget.onComment,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Text(
              widget.commentLabel,
              style: AppText.body.copyWith(color: colors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.xs, Space.gutter, 0),
      child: Text(
        widget.timeLabel,
        style: AppText.caption.copyWith(color: context.colors.textSecondary),
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
