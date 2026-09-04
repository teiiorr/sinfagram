import 'package:flutter/widgets.dart';

import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';

/// Initials avatar — Instagram flat. No network image in this phase: the initials
/// sit on a single neutral circle ([AppColors.primarySubtle] fill,
/// [AppColors.textSecondary] glyphs), the same for everyone, with no accent
/// gradient. Fully round.
class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.name, this.size = 36});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: name,
      // Decorative once labelled — hide the initials glyphs from the reader.
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primarySubtle,
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
