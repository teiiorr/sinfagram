import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// Story ko'ruvchi — to'liq ekran, avtomatik progress, chapga/o'ngga bosish.
class StoryViewerScreen extends StatefulWidget {
  final int initialIndex;
  const StoryViewerScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin {
  late int _index = widget.initialIndex;
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500));

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) _next();
    });
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < stories.length - 1) {
      setState(() => _index++);
      _c.forward(from: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() => _index--);
    }
    _c.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final s = stories[_index];
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) => d.localPosition.dx < w * 0.32 ? _prev() : _next(),
        onLongPressStart: (_) => _c.stop(),
        onLongPressEnd: (_) => _c.forward(),
        child: Stack(
          children: [
            // Story mazmuni (silliq almashinuv)
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: PostMedia(s.name, s.cover, key: ValueKey(_index)),
              ),
            ),
            // Yuqori qorong'i gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 160,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.5), Colors.transparent]),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Progress barlar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                    child: Row(
                      children: List.generate(stories.length, (i) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: SizedBox(
                                height: 3,
                                child: i < _index
                                    ? Container(color: Colors.white)
                                    : i > _index
                                        ? Container(color: Colors.white24)
                                        : AnimatedBuilder(
                                            animation: _c,
                                            builder: (_, __) => LinearProgressIndicator(
                                              value: _c.value,
                                              backgroundColor: Colors.white24,
                                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Sarlavha
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 10, 0),
                    child: Row(
                      children: [
                        Avatar(s.avatar == currentUser.avatar ? currentUser.name : s.name, radius: 18, ring: true),
                        const SizedBox(width: 10),
                        Expanded(child: Text(s.name, style: metro(size: 14, weight: FontWeight.w700, color: Colors.white))),
                        IconButton(
                          icon: const Icon(AppIcons.close, color: Colors.white, size: 26),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Pastki nozik yozuv
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              child: Text(
                '${s.name}ning hikoyasi',
                style: metro(size: 15, weight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
