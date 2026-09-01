import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Tugʻilgan kunlar — sinfdoshlarni tabriklash (tabrik lentaga tushadi).
class BirthdaysScreen extends StatelessWidget {
  const BirthdaysScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Tugʻilgan kunlar'),
      body: ListView(
        children: [
          for (int i = 0; i < app.birthdays.length; i++) _tile(context, app, app.birthdays[i], i),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, AppState app, Birthday b, int i) {
    final today = b.daysLeft == 0;
    final color = today ? const Color(0xFFEB4D8C) : SinfColors.purple;
    return FadeInUp(
      index: i < 6 ? i : 0,
      child: SinfCard(
        child: Row(
          children: [
            Stack(
              children: [
                Avatar(b.name, radius: 26, ring: today),
                if (today)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: const Icon(AppIcons.birthday, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.name, style: metro(size: 14.5, weight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Row(children: [
                    Icon(AppIcons.birthday, size: 14, color: color),
                    const SizedBox(width: 6),
                    Text(today ? 'Bugun tugʻilgan kuni! 🎉' : b.date, style: metro(size: 12.5, color: today ? color : SinfColors.muted, weight: today ? FontWeight.w700 : FontWeight.w500)),
                  ]),
                ],
              ),
            ),
            b.greeted
                ? Row(children: [
                    const Icon(AppIcons.check, size: 18, color: Color(0xFF27AE60)),
                    const SizedBox(width: 5),
                    Text('Tabriklandi', style: metro(size: 12, color: const Color(0xFF27AE60), weight: FontWeight.w600)),
                  ])
                : Pressable(
                    onTap: () {
                      app.greet(b);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${b.name} tabriklandi — tabrik lentaga qoʻyildi'), duration: const Duration(milliseconds: 1100)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.25)!]), borderRadius: BorderRadius.circular(16)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(AppIcons.gift, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Tabriklash', style: metro(size: 12.5, weight: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
