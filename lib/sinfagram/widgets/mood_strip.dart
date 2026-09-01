import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../app_state.dart';
import '../sinf_theme.dart';

/// Bugungi kayfiyat — sinfning kayfiyat pulsi (jonli, tanlanadi).
class MoodStrip extends StatelessWidget {
  const MoodStrip({Key? key}) : super(key: key);

  static const _icons = {
    'Ajoyib': IconsaxPlusBold.lovely,
    'Yaxshi': IconsaxPlusBold.emoji_happy,
    'Oʻrtacha': IconsaxPlusBold.emoji_normal,
    'Charchadim': IconsaxPlusBold.coffee,
    'Xafa': IconsaxPlusBold.emoji_sad,
  };
  static const _colors = {
    'Ajoyib': Color(0xFF27AE60),
    'Yaxshi': Color(0xFF12B39B),
    'Oʻrtacha': Color(0xFFF2994A),
    'Charchadim': Color(0xFF8B6F4E),
    'Xafa': Color(0xFF5B7C99),
  };

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(app.myMood == null ? 'Bugun kayfiyating qanday?' : 'Kayfiyating: ${app.myMood}',
                  style: metro(size: 14, weight: FontWeight.w700)),
              const Spacer(),
              Text('${app.moodTotal} javob', style: metro(size: 11.5, color: SinfColors.muted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final m in kMoods) _moodBtn(context, app, m),
            ],
          ),
        ],
      ),
    );
  }

  Widget _moodBtn(BuildContext context, AppState app, String mood) {
    final selected = app.myMood == mood;
    final color = _colors[mood]!;
    return Pressable(
      onTap: () {
        app.setMood(mood);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayfiyating saqlandi: $mood'), duration: const Duration(milliseconds: 900)),
        );
      },
      scale: 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.3)!]) : null,
              color: selected ? null : color.withOpacity(0.10),
              boxShadow: selected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 5))] : null,
            ),
            child: Icon(_icons[mood], color: selected ? Colors.white : color, size: 25),
          ),
          const SizedBox(height: 5),
          Text(mood, style: metro(size: 9.5, weight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? color : SinfColors.muted)),
        ],
      ),
    );
  }
}
