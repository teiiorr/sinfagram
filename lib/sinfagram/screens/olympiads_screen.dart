import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Olimpiada va tanlovlar" — tanlovlar taqvimi, daraja boʻyicha ranglangan.
class OlympiadsScreen extends StatelessWidget {
  const OlympiadsScreen({Key? key}) : super(key: key);

  Color _levelColor(String level) {
    switch (level) {
      case 'Maktab':
        return SinfColors.blue;
      case 'Tuman':
        return Colors.orange.shade800;
      case 'Respublika':
        return SinfColors.purple;
      default:
        return SinfColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Olimpiada va tanlovlar'),
      body: ListView(
        children: [
          const SinfHero(
            title: 'Oʻzingni sinab koʻr',
            subtitle: 'Maktab, tuman va respublika bosqichidagi tanlovlar.',
            icon: AppIcons.trophy,
          ),
          const SizedBox(height: 6),
          ...List.generate(contests.length, (i) => FadeInUp(index: i, child: _contestCard(context, contests[i]))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _contestCard(BuildContext context, Contest c) {
    final levelColor = _levelColor(c.level);
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.title, style: metro(size: 17, weight: FontWeight.w800, spacing: -0.3)),
          const SizedBox(height: 10),
          Pill(c.subject, color: SinfColors.deepPurple, icon: AppIcons.book),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(AppIcons.events, size: 16, color: SinfColors.muted),
                  const SizedBox(width: 6),
                  Text(c.date, style: metro(size: 13, weight: FontWeight.w600)),
                ],
              ),
              Pill(c.level, color: levelColor, icon: AppIcons.flag),
            ],
          ),
          const SizedBox(height: 8),
          Text('Muddat: ${c.deadline}', style: metro(size: 12, color: SinfColors.muted, weight: FontWeight.w500)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Ariza berish',
              icon: AppIcons.send,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ariza yordamchisi tez orada', style: metro(color: Colors.white))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
