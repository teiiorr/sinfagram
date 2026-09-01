import 'package:flutter/foundation.dart';

/// One collected moment in a chapter (docs/07 S31). The image is a thumbnail key
/// in the real app; here items carry only a caption placeholder.
@immutable
class ChronicleItem {
  const ChronicleItem({required this.id, required this.caption});
  final String id;
  final String caption;
}

/// A month chapter (docs/07 §7.6). Sealed chapters are read-only; the current
/// month shows how many days remain before it seals.
@immutable
class Chapter {
  const Chapter({
    required this.id,
    required this.monthLabel,
    required this.sealed,
    required this.items,
    this.daysToSeal,
  });

  final String id;
  final String monthLabel;
  final bool sealed;
  final List<ChronicleItem> items;
  final int? daysToSeal; // non-null only for the current, unsealed month

  int get itemCount => items.length;
}
