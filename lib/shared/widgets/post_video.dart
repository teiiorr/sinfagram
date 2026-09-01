import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import 'package:sinfagram/core/theme/colors.dart';

/// Inline player for a locally-attached post video. It never autoplays (this is
/// a children's app): it shows the first frame with a play badge and toggles
/// play/pause on tap. The controller is initialised lazily and disposed with the
/// widget.
///
/// Media is always a real file from the device — never a remote or AI video.
class PostVideo extends StatefulWidget {
  const PostVideo({super.key, required this.path});
  final String path;

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final c = VideoPlayerController.file(File(widget.path));
    try {
      await c.initialize();
      await c.setLooping(true);
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _ready = true;
      });
    } catch (_) {
      c.dispose();
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggle() {
    final c = _controller;
    if (c == null) return;
    setState(() => c.value.isPlaying ? c.pause() : c.play());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (_failed) {
      // Fall back to a neutral tile if the file can't be read/decoded.
      return ColoredBox(
        color: colors.skeleton,
        child: const Center(child: Icon(LucideIcons.video, size: 28)),
      );
    }
    final c = _controller;
    if (!_ready || c == null) {
      return ColoredBox(
        color: Colors.black,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        ),
      );
    }
    final playing = c.value.isPlaying;
    return GestureDetector(
      onTap: _toggle,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: c.value.size.width,
              height: c.value.size.height,
              child: VideoPlayer(c),
            ),
          ),
          // Play badge — hidden while playing.
          AnimatedOpacity(
            opacity: playing ? 0 : 1,
            duration: const Duration(milliseconds: 160),
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.play, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
