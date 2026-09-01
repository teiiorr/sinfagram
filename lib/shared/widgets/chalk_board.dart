import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';

/// A green wooden classroom chalkboard shown at the top of the class feed.
///
/// DELIBERATE DEVIATION from docs/05 (flat, Inter-only, "nothing decorative"):
/// this skeuomorphic board is an explicit product decision — a warm, familiar
/// header for pupils. Its wood/chalk colours are intentionally local and NOT in
/// the token system; the chalk face uses the bundled `Caveat` handwriting font.
/// Everything else in the app stays flat and on-token.
class ChalkBoard extends StatelessWidget {
  const ChalkBoard({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.classLabel,
    required this.note,
  });

  final String title;
  final String dateLabel;
  final String classLabel;
  final String note;

  // Local decorative palette (see class doc).
  static const _woodDark = Color(0xFF5B3A21);
  static const _woodLight = Color(0xFF7A5230);
  static const _board = Color(0xFF2C4636);
  static const _chalk = Color(0xFFEDF1E8);

  TextStyle _chalkStyle(double size, {double opacity = 1}) => TextStyle(
        fontFamily: 'Caveat',
        fontSize: size,
        height: 1.1,
        color: _chalk.withValues(alpha: opacity),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Space.gutter, Space.md, Space.gutter, Space.sm),
      child: DecoratedBox(
        // Wooden frame.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.card),
          border: Border.all(color: _woodLight, width: 10),
          color: _woodDark,
          boxShadow: Shadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.control),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Board face.
              Container(
                color: _board,
                padding: const EdgeInsets.fromLTRB(
                    Space.lg, Space.md, Space.lg, Space.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(title, style: _chalkStyle(22, opacity: 0.92)),
                        Text(classLabel, style: _chalkStyle(22, opacity: 0.8)),
                      ],
                    ),
                    const SizedBox(height: Space.xs),
                    Text(dateLabel, style: _chalkStyle(34)),
                    const SizedBox(height: Space.sm),
                    // Hand-drawn chalk underline.
                    SizedBox(
                      height: 8,
                      child: CustomPaint(
                          painter:
                              _ChalkUnderline(_chalk.withValues(alpha: 0.8)),
                          size: Size.infinite),
                    ),
                    const SizedBox(height: Space.sm),
                    Text('“$note”', style: _chalkStyle(20, opacity: 0.82)),
                  ],
                ),
              ),
              // Chalk tray with a couple of chalk sticks.
              Container(
                height: 14,
                color: _woodLight,
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                child: Row(
                  children: [
                    _chalkStick(const Color(0xFFF2F2EA), 20),
                    const SizedBox(width: 6),
                    _chalkStick(const Color(0xFFF3C6C6), 14),
                    const Spacer(),
                    _chalkStick(const Color(0xFFC6E0F3), 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chalkStick(Color color, double width) => Container(
        width: width,
        height: 5,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(2.5)),
      );
}

/// A slightly irregular chalk line — two overlapping strokes so it reads as
/// hand-drawn rather than a ruler-straight divider.
class _ChalkUnderline extends CustomPainter {
  const _ChalkUnderline(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final w = size.width * 0.62;
    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(w * 0.3, size.height * 0.1, w * 0.6, size.height, w,
          size.height * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChalkUnderline oldDelegate) =>
      oldDelegate.color != color;
}
