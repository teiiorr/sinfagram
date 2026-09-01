import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/feed/application/comments_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/comment.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/features/moderation/presentation/report_sheet.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/empty_state.dart';
import 'package:sinfagram/shared/widgets/post_card.dart';

/// S11 — a single post with its comment thread (docs/07 §7.4). Comments load
/// whole (a class post never has hundreds); the composer is pinned above the
/// keyboard. The post is resolved by id from the live feed so the thanks toggle
/// stays in sync and a vanished post degrades to an [EmptyState].
class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _controller = TextEditingController();
  var _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final can = _controller.text.trim().isNotEmpty;
      if (can != _canSend) setState(() => _canSend = can);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Post? _postFrom(Loadable<DayPage> state) {
    final DayPage? day = switch (state) {
      Ready(:final value) => value,
      Loading(:final previous) => previous,
      Failed(:final previous) => previous,
    };
    if (day == null) return null;
    for (final post in day.posts) {
      if (post.id == widget.postId) return post;
    }
    return null;
  }

  void _send() {
    ref
        .read(commentsProvider.notifier)
        .addComment(widget.postId, _controller.text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final post = _postFrom(ref.watch(dayPageProvider));

    if (post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: EmptyState(
                icon: LucideIcons.fileQuestion,
                title: l.emptyTitle,
                message: l.emptyBody)),
      );
    }

    final comments =
        ref.watch(commentsProvider)[widget.postId] ?? const <Comment>[];

    return Scaffold(
      appBar: AppBar(title: Text(l.commentsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.lg, Space.gutter, Space.lg),
                children: [
                  PostCard(
                    authorName: post.authorName,
                    timeLabel: post.timeLabel,
                    body: post.body,
                    hasPhoto: post.hasPhoto,
                    thanksLabel: l.thanks,
                    thankedByMe: post.thankedByMe,
                    onThanks: () => ref
                        .read(dayPageProvider.notifier)
                        .toggleThanks(post.id),
                    commentLabel: l.comments(comments.length),
                    onReport: () => showReportSheet(context,
                        targetKind: 'post', targetId: post.id),
                    heldForReview: post.heldForReview,
                    waitingLabel: l.composeReview,
                  ),
                  const SizedBox(height: Space.lg),
                  if (comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.lg),
                      child: Text(l.commentEmpty,
                          style: AppText.bodySm
                              .copyWith(color: colors.textSecondary)),
                    )
                  else
                    for (var i = 0; i < comments.length; i++)
                      Reveal(index: i, child: _CommentRow(comments[i])),
                ],
              ),
            ),
            _composer(context, l, colors),
          ],
        ),
      ),
    );
  }

  /// Pinned bottom composer: a soft pill input on the page ground and a circular
  /// gradient send button. The button carries the brand gradient once there is
  /// text to send, and drops to a flat recessive fill while empty.
  Widget _composer(BuildContext context, AppL10n l, AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
            top: BorderSide(color: colors.border, width: Stroke.hairline)),
      ),
      padding:
          const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Space.md, vertical: Space.sm),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: colors.primary,
                style: AppText.body.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: l.commentHint,
                  hintStyle:
                      AppText.body.copyWith(color: colors.textTertiary),
                ),
                onSubmitted: (_) {
                  if (_canSend) _send();
                },
              ),
            ),
          ),
          const SizedBox(width: Space.sm),
          Semantics(
            button: true,
            enabled: _canSend,
            label: l.actionSend,
            child: TapScale(
              onTap: _canSend ? _send : null,
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _canSend ? AppGradients.primary : null,
                  color: _canSend ? null : colors.border,
                  boxShadow: _canSend ? Shadows.card : null,
                ),
                child: Icon(
                  LucideIcons.send,
                  size: 20,
                  color: _canSend ? colors.textOnPrimary : colors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow(this.comment);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(name: comment.author, size: 38),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                        child: Text(comment.author,
                            style: AppText.bodyStrong
                                .copyWith(color: colors.textPrimary),
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: Space.sm),
                    Text(comment.timeLabel,
                        style: AppText.caption
                            .copyWith(color: colors.textTertiary)),
                  ],
                ),
                const SizedBox(height: Space.xs),
                Text(comment.body,
                    style: AppText.body.copyWith(color: colors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
