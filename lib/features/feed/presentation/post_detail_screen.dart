import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
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
  final _composerFocus = FocusNode();
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
    _composerFocus.dispose();
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
                      Reveal(
                        index: i,
                        child: _CommentRow(
                          comments[i],
                          onReply: () => _composerFocus.requestFocus(),
                        ),
                      ),
                ],
              ),
            ),
            _composer(context, l, colors),
          ],
        ),
      ),
    );
  }

  /// Pinned bottom composer (Instagram-style): the current user's 24px avatar, a
  /// flat bordered text field (radius 4, hairline border that goes grey on focus)
  /// and a plain text "Yuborish" action that is blue when there is something to
  /// send and recedes to tertiary grey while empty. Flat — the only line is the
  /// hairline that separates the composer from the thread above it.
  Widget _composer(BuildContext context, AppL10n l, AppColors colors) {
    final me = ref.watch(sessionProvider)?.displayName ?? 'Siz';
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
            top: BorderSide(color: colors.border, width: Stroke.hairline)),
      ),
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(name: me, size: 24),
          const SizedBox(width: Space.sm),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _composerFocus,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: colors.primary,
              style: AppText.body.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Space.md, vertical: Space.sm),
                hintText: l.commentHint,
                hintStyle: AppText.body.copyWith(color: colors.textTertiary),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide:
                      BorderSide(color: colors.border, width: Stroke.hairline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: BorderSide(
                      color: colors.borderStrong, width: Stroke.hairline),
                ),
              ),
              onSubmitted: (_) {
                if (_canSend) _send();
              },
            ),
          ),
          const SizedBox(width: Space.sm),
          Semantics(
            button: true,
            enabled: _canSend,
            label: l.actionSend,
            child: TapScale(
              onTap: _canSend ? _send : null,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: 44, minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      l.actionSend,
                      style: AppText.label.copyWith(
                        color:
                            _canSend ? colors.primary : colors.textTertiary,
                      ),
                    ),
                  ),
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
  const _CommentRow(this.comment, {this.onReply});

  final Comment comment;

  /// Focuses the composer so the person can answer this comment.
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(name: comment.author, size: 32),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First line: name + comment as one flowing paragraph, with a
                // small heart pinned to the right (no bubble, no count).
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: comment.author,
                            style: AppText.bodyStrong
                                .copyWith(color: colors.textPrimary),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: comment.body,
                            style: AppText.body
                                .copyWith(color: colors.textPrimary),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: Space.sm),
                    // Decorative private heart (count-less); no like model on
                    // comments, so it carries no tap and stays out of the a11y tree.
                    ExcludeSemantics(
                      child: Icon(LucideIcons.heart,
                          size: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: Space.xs),
                // Meta line: time then a "reply" action, 12px apart (8 + 4).
                Row(
                  children: [
                    Text(comment.timeLabel,
                        style: AppText.caption
                            .copyWith(color: colors.textSecondary)),
                    const SizedBox(width: Space.sm + Space.xs),
                    Semantics(
                      button: true,
                      label: l.munozaraReply,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onReply,
                        child: Text(
                          l.munozaraReply,
                          style: AppText.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
