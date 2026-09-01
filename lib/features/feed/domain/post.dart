import 'package:flutter/foundation.dart';

/// A class post (docs/08 §Day page). No public counters: [thankedByMe] is the
/// viewer's own state; there is no thanks total on a post.
@immutable
class Post {
  const Post({
    required this.id,
    required this.authorName,
    required this.timeLabel,
    required this.body,
    this.hasPhoto = false,
    this.photoPath,
    this.videoPath,
    this.thankedByMe = false,
    this.repostedByMe = false,
    this.repostedFromAuthor,
    this.commentCount = 0,
    this.heldForReview = false,
  });

  final String id;
  final String authorName;
  final String timeLabel;
  final String body;
  final bool hasPhoto;

  /// Local file path of an attached image, when the post carries a real photo
  /// (picked from the device). Null for mock/seed posts, which fall back to the
  /// neutral placeholder. Never a remote/AI image.
  final String? photoPath;

  /// Local file path of an attached video, when the post carries one. Null
  /// otherwise. Never a remote/AI video.
  final String? videoPath;
  final bool thankedByMe;

  /// The viewer has re-shared this post to their own profile (Instagram-style
  /// repost). Count-less by design.
  final bool repostedByMe;

  /// When this post is itself a repost surfaced on a profile, the original
  /// author's name (for the "reblog" attribution line). Null for normal posts.
  final String? repostedFromAuthor;
  final int commentCount;
  final bool heldForReview;

  /// True when the post carries real media (photo or video) — the Lenta feed
  /// shows these; text-only posts go to Munozara.
  bool get hasMedia =>
      (photoPath != null && photoPath!.isNotEmpty) ||
      (videoPath != null && videoPath!.isNotEmpty) ||
      hasPhoto;

  Post copyWith({bool? thankedByMe, bool? repostedByMe}) => Post(
        id: id,
        authorName: authorName,
        timeLabel: timeLabel,
        body: body,
        hasPhoto: hasPhoto,
        photoPath: photoPath,
        videoPath: videoPath,
        thankedByMe: thankedByMe ?? this.thankedByMe,
        repostedByMe: repostedByMe ?? this.repostedByMe,
        repostedFromAuthor: repostedFromAuthor,
        commentCount: commentCount,
        heldForReview: heldForReview,
      );
}

/// One finite day (docs/08). [isComplete] drives the terminal card; the page is
/// chronological ascending and never ranked.
@immutable
class DayPage {
  const DayPage({
    required this.dateLabel,
    required this.classLabel,
    required this.posts,
    required this.isComplete,
  });

  final String dateLabel; // "14-sentabr, dushanba"
  final String classLabel; // "7-B"
  final List<Post> posts;
  final bool isComplete;
}
