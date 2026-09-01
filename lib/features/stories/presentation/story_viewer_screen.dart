import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/stories/application/stories_controller.dart';
import 'package:sinfagram/features/stories/domain/story.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// Full-screen story viewer (Instagram-style): per-slide progress bars, tap
/// right/left to move, hold to pause, swipe down to close. Media is a coloured
/// gradient placeholder until the media layer lands.
class StoryViewerScreen extends ConsumerStatefulWidget {
  const StoryViewerScreen({super.key, required this.initialIndex});
  final int initialIndex;

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen> with SingleTickerProviderStateMixin {
  static const _slideDuration = Duration(milliseconds: 4500);

  late final PageController _pages = PageController(initialPage: widget.initialIndex);
  late final AnimationController _progress = AnimationController(vsync: this, duration: _slideDuration)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) _advance();
    });

  late int _story = widget.initialIndex;
  int _slide = 0;

  List<Story> get _stories => ref.read(storiesProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markSeen();
      _progress.forward();
    });
  }

  @override
  void dispose() {
    _pages.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _markSeen() {
    final list = _stories;
    if (_story < list.length) ref.read(storiesProvider.notifier).markSeen(list[_story].id);
  }

  Story get _current => _stories[_story];

  void _advance() {
    final slides = _current.slides.length;
    if (_slide < slides - 1) {
      setState(() => _slide++);
      _progress.forward(from: 0);
    } else if (_story < _stories.length - 1) {
      _pages.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _prev() {
    if (_slide > 0) {
      setState(() => _slide--);
      _progress.forward(from: 0);
    } else if (_story > 0) {
      _pages.previousPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
    } else {
      _progress.forward(from: 0);
    }
  }

  void _onPageChanged(int i) {
    setState(() {
      _story = i;
      _slide = 0;
    });
    _markSeen();
    _progress.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storiesProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (d) {
          final w = MediaQuery.sizeOf(context).width;
          if (d.globalPosition.dx < w * 0.32) {
            _prev();
          } else {
            _advance();
          }
        },
        onLongPressStart: (_) => _progress.stop(),
        onLongPressEnd: (_) => _progress.forward(),
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 200) Navigator.of(context).maybePop();
        },
        child: PageView.builder(
          controller: _pages,
          onPageChanged: _onPageChanged,
          itemCount: stories.length,
          itemBuilder: (context, i) {
            final story = stories[i];
            final slideIndex = i == _story ? _slide.clamp(0, story.slides.length - 1) : 0;
            final slide = story.slides.isEmpty ? null : story.slides[slideIndex];
            return _StorySlideView(
              story: story,
              slide: slide,
              slideCount: story.slides.length,
              currentSlide: slideIndex,
              progress: _progress,
              isActive: i == _story,
              onClose: () => Navigator.of(context).maybePop(),
            );
          },
        ),
      ),
    );
  }
}

class _StorySlideView extends StatelessWidget {
  const _StorySlideView({
    required this.story,
    required this.slide,
    required this.slideCount,
    required this.currentSlide,
    required this.progress,
    required this.isActive,
    required this.onClose,
  });

  final Story story;
  final StorySlide? slide;
  final int slideCount;
  final int currentSlide;
  final AnimationController progress;
  final bool isActive;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final accent = AppAccents.forSeed(story.author);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Placeholder media — a vivid gradient per author.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.lerp(accent, Colors.black, 0.1)!, Color.lerp(accent, Colors.black, 0.55)!],
            ),
          ),
        ),
        if (slide != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.xl),
              child: Text(
                slide!.caption,
                textAlign: TextAlign.center,
                style: AppText.h1.copyWith(color: Colors.white, height: 1.3),
              ),
            ),
          ),
        // Top gradient scrim for legibility.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 140,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black54, Colors.transparent]),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            child: Column(
              children: [
                // Progress bars.
                Row(
                  children: [
                    for (var s = 0; s < slideCount; s++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: Space.sm),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              height: 3,
                              child: s < currentSlide
                                  ? const ColoredBox(color: Colors.white)
                                  : s > currentSlide
                                      ? ColoredBox(color: Colors.white.withValues(alpha: 0.35))
                                      : (isActive
                                          ? AnimatedBuilder(
                                              animation: progress,
                                              builder: (_, __) => LinearProgressIndicator(
                                                value: progress.value,
                                                backgroundColor: Colors.white.withValues(alpha: 0.35),
                                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                              ),
                                            )
                                          : ColoredBox(color: Colors.white.withValues(alpha: 0.35))),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: Space.xs),
                    Avatar(name: story.author, size: 34),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Text(
                        story.isMine ? 'Siz' : story.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong.copyWith(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(LucideIcons.x, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
