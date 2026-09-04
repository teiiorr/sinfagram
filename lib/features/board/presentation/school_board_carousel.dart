import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/motion.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/board/application/board_controller.dart';
import 'package:sinfagram/features/board/domain/board.dart';
import 'package:sinfagram/shared/motion/motion_widgets.dart';

/// One card of the school-board carousel — a single board item flattened into a
/// category + title + body, so announcements, homework and the current lesson
/// can share one auto-advancing strip.
class _BoardSlide {
  const _BoardSlide(this.category, this.title, this.body);
  final String category;
  final String title;
  final String body;
}

/// A swipeable, auto-advancing carousel of the SCHOOL board for the top of the
/// feed (product-owner: "the school board should be a slide too"). Rotates every
/// 3s, honours reduce-motion by staying purely swipeable, and taps through to the
/// full board. Each slide is a flat card — white surface, one hairline border,
/// no gradient, no shadow. All motion is compositing-only.
class SchoolBoardCarousel extends ConsumerStatefulWidget {
  const SchoolBoardCarousel({super.key});

  @override
  ConsumerState<SchoolBoardCarousel> createState() =>
      _SchoolBoardCarouselState();
}

class _SchoolBoardCarouselState extends ConsumerState<SchoolBoardCarousel> {
  static const _cardHeight = 120.0;
  static const _interval = Duration(seconds: 3);

  final PageController _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _syncTimer() {
    final wantTimer = !reduceMotion(context);
    if (wantTimer && _timer == null) {
      _timer = Timer.periodic(_interval, (_) => _advance());
    } else if (!wantTimer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _advance() {
    if (!mounted || !_controller.hasClients) return;
    final count = _slides(ref.read(boardProvider), AppL10n.of(context)).length;
    if (count < 2) return;
    final next = (_index + 1) % count;
    _controller.animateToPage(
      next,
      duration: Motion.base,
      curve: Curves.easeOutCubic,
    );
  }

  /// Flattens the board into slides: the current lesson, pinned-first
  /// announcements, then homework — a compact "what's on the board now" strip.
  List<_BoardSlide> _slides(SchoolBoard board, AppL10n l) {
    final slides = <_BoardSlide>[];
    for (final lesson in board.schedule.where((s) => s.isCurrent)) {
      slides.add(_BoardSlide(
        l.boardNow,
        lesson.subject,
        '${lesson.time} · ${lesson.room}',
      ));
    }
    final pinnedFirst = [
      ...board.announcements.where((a) => a.pinned),
      ...board.announcements.where((a) => !a.pinned),
    ];
    for (final a in pinnedFirst) {
      slides.add(_BoardSlide(
        l.boardAnnouncements,
        a.title,
        a.body,
      ));
    }
    for (final h in board.homework) {
      slides.add(_BoardSlide(
        l.boardHomework,
        h.subject,
        '${h.title} · ${h.due}',
      ));
    }
    return slides;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final slides = _slides(ref.watch(boardProvider), l);
    if (slides.isEmpty) return const SizedBox.shrink();

    final active = _index.clamp(0, slides.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Text(
            l.boardTitle,
            style: AppText.h3.copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: Space.sm),
        SizedBox(
          height: _cardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => _card(context, slides[i]),
          ),
        ),
        const SizedBox(height: Space.sm),
        _dots(colors, slides.length, active),
      ],
    );
  }

  Widget _card(BuildContext context, _BoardSlide slide) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.xs),
      child: TapScale(
        onTap: () => context.push('/board'),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border, width: Stroke.hairline),
            borderRadius: BorderRadius.circular(Radii.hero),
          ),
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slide.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: Space.xs),
              Text(
                slide.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyStrong.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: Space.xs),
              Expanded(
                child: Text(
                  slide.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(color: colors.textSecondary),
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
              color: i == active ? colors.primary : colors.textTertiary,
              borderRadius: BorderRadius.circular(Radii.avatar),
            ),
          ),
      ],
    );
  }
}
