import 'package:flutter/foundation.dart';

/// A person profile — the viewer's own (editable) or a classmate's (read-only).
/// "Now reading / now listening / interests" give the profile personality
/// (product-owner direction).
@immutable
class Person {
  const Person({
    required this.id,
    required this.name,
    required this.className,
    required this.bio,
    required this.reading,
    required this.listening,
    required this.interests,
  });

  final String id;
  final String name;
  final String className;
  final String bio;
  final String reading; // "now reading" — a book
  final String listening; // "now listening" — a song/artist
  final List<String> interests;

  Person copyWith({String? bio, String? reading, String? listening, List<String>? interests}) => Person(
        id: id,
        name: name,
        className: className,
        bio: bio ?? this.bio,
        reading: reading ?? this.reading,
        listening: listening ?? this.listening,
        interests: interests ?? this.interests,
      );
}
