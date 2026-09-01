import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// Initials avatar. No network image in this phase — the initials on a
/// deterministic subtle tint stand in for a photo, so a person keeps a stable
/// colour everywhere they appear (feed, member lists, mentions).
class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.name, this.size = 36});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Five subtle tints. hashCode can be negative and Dart's % preserves the
    // sign, so take the magnitude before indexing.
    final tints = <Color>[
      colors.primarySubtle,
      colors.successSubtle,
      colors.warningSubtle,
      colors.accentSubtle,
      colors.surfaceRaised,
    ];
    final tint = tints[name.hashCode.abs() % tints.length];

    return Semantics(
      label: name,
      // Decorative once labelled — hide the initials glyphs from the reader.
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(Radii.avatar),
          ),
          child: Text(
            _initials(name),
            // The avatar is a fixed geometric element sized by [size], like an
            // icon — scaling the glyphs with the user's text setting would burst
            // the circle, so pin the initials to the diameter instead.
            textScaler: TextScaler.noScaling,
            maxLines: 1,
            style: AppText.label.copyWith(
              fontSize: size * 0.4,
              height: 1,
              color: colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// First letters of up to two words, uppercased. Empty when there is nothing
  /// to derive from, so the tinted circle still renders.
  static String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.take(2).map((w) => w.characters.first.toUpperCase()).join();
  }
}
