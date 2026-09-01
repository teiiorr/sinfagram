import 'package:flutter/foundation.dart';

/// A comment on a class post (docs/07 S11). Loaded whole — a class post never
/// has hundreds of comments.
@immutable
class Comment {
  const Comment(
      {required this.id,
      required this.author,
      required this.body,
      required this.timeLabel});

  final String id;
  final String author;
  final String body;
  final String timeLabel;
}
