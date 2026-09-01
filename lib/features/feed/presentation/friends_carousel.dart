import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/async/loadable.dart';
import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/features/feed/domain/post.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// A swipeable, auto-advancing carousel of friends' posts for the top of the
/// class board (product-owner request: "which friend wrote what and when").
///
/// Reads the day page and shows each post as a colourful, per-author gradient
/// card that peeks its neighbours. It rotates itself every few seconds and
/// honours reduce-motion by staying purely swipeable. Renders nothing when the
/// day has no posts. All motion is compositing-only (Transform/Opacity/
/// AnimatedContainer) — no layout thrash.
class FriendsCarousel extends ConsumerStatefulWidget {
  const FriendsCarousel({super.key});

  @override
  ConsumerState<FriendsCarousel> createState() => _FriendsCarouselState();
}

class _FriendsCarouselState extends ConsumerState<FriendsCarousel> {
  static const _cardHeight = 150.0;
  static const _interval = Duration(seconds: 3);

  final PageController _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // reduce-motion can flip at runtime, and MediaQuery is guaranteed here —
    // so (re)decide whether the auto-advance timer should be running.
    _syncTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Start the ticker when motion is allowed, stop it otherwise.
  void _syncTimer() {
    final wantTimer = !reduceMotion(context);
    if (wantTimer && _timer == null) {
      _timer = Timer.periodic(_interval, (_) => _advance());
    } else if (!wantTimer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Advance to the next card, wrapping back to the first at the end. Reads the
  /// live post count so it stays correct as the day grows.
  void _advance() {
    if (!mounted || !_controller.hasClients) return;
    final count = _postsOf(ref.read(dayPageProvider)).length;
    if (count < 2) return;
    final next = (_index + 1) % count;
    _controller.animateToPage(
      next,
      duration: Motion.base,
      curve: Curves.easeOutCubic,
    );
  }

  /// The posts to show across every [Loadable] branch: the ready day, or the
  /// stale day held through a load/failure so the strip never blinks empty.
  List<Post> _postsOf(Loadable<DayPage> state) => switch (state) {
        Ready(:final value) => value.posts,
        Loading(:final previous) => previous?.posts ?? const [],
        Failed(:final previous) => previous?.posts ?? const [],
      };

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final posts = _postsOf(ref.watch(dayPageProvider));
    if (posts.isEmpty) return const SizedBox.shrink();

    final active = _index.clamp(0, posts.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Row(
            children: [
              Icon(LucideIcons.sparkles, size: 18, color: colors.primary),
              const SizedBox(width: Space.xs),
              Text(
                l.feedFriendsNow,
                style: AppText.h3.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.sm),
        SizedBox(
          height: _cardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: posts.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => _card(context, posts[i]),
          ),
        ),
        const SizedBox(height: Space.sm),
        _dots(colors, posts.length, active),
      ],
    );
  }

  Widget _card(BuildContext context, Post post) {
    final accent = AppAccents.forSeed(post.authorName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.xs),
      child: TapScale(
        onTap: () => context.push('/post/${post.id}'),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.of(accent),
            borderRadius: BorderRadius.circular(Radii.hero),
            boxShadow: Shadows.lift,
          ),
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Avatar(name: post.authorName, size: 36),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodyStrong.copyWith(color: Colors.white),
                        ),
                        Text(
                          post.timeLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppText.caption.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.sm),
              Expanded(
                child: Text(
                  post.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dots(AppColors colors, int count, int active) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: Motion.fast,
            curve: Motion.standard,
            margin: const EdgeInsets.symmetric(horizontal: Space.xs / 2),
            width: i == active ? Space.lg : Space.sm,
            height: Space.sm,
            decoration: BoxDecoration(
              color: i == active ? colors.primary : colors.border,
              borderRadius: BorderRadius.circular(Radii.avatar),
            ),
          ),
      ],
    );
  }
}
