import 'package:flutter/foundation.dart';

/// One frame of a story. Media is a coloured placeholder in the client
/// (real photo/video attaches through the media layer later).
@immutable
class StorySlide {
  const StorySlide({required this.id, required this.caption});
  final String id;
  final String caption;
}

/// A class-mate's story ring (docs — Instagram-style, product-owner direction).
@immutable
class Story {
  const Story({
    required this.id,
    required this.author,
    required this.slides,
    this.seen = false,
    this.isMine = false,
  });

  final String id;
  final String author;
  final List<StorySlide> slides;
  final bool seen;
  final bool isMine;

  bool get hasSlides => slides.isNotEmpty;

  Story copyWith({bool? seen, List<StorySlide>? slides}) => Story(
        id: id,
        author: author,
        slides: slides ?? this.slides,
        seen: seen ?? this.seen,
        isMine: isMine,
      );
}
