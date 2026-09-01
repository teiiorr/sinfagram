import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Ustoz-shogird" — tengdoshlar oʻrtasida oʻzaro yordam (peer mentoring).
class MentoringScreen extends StatelessWidget {
  const MentoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Ustoz-shogird'),
      body: ListView(
        children: [
          FadeInUp(child: _introCard()),
          const SectionHeader('Ustozlar'),
          ...List.generate(mentors.length, (i) => FadeInUp(index: i + 1, child: _mentorCard(context, mentors[i]))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _introCard() {
    return SinfCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SinfColors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(AppIcons.kudos, color: SinfColors.purple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bir-biringizga yordam bering', style: metro(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  'Katta sinf oʻquvchilari fanlardan kichiklarga yordam beradi. Oʻzingizga mos ustozni tanlab, bemalol soʻrov yuboring — har bir yordam soati portfolioga qoʻshiladi.',
                  style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mentorCard(BuildContext context, Mentor m) {
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(m.name, radius: 26, ring: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name, style: metro(size: 15, weight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Pill(m.grade, color: SinfColors.deepPurple, icon: AppIcons.book),
                  ],
                ),
              ),
              Pill('${m.hours} soat', color: SinfColors.primary, icon: AppIcons.clock),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(AppIcons.book, size: 16, color: SinfColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(m.subjects.join(' · '), style: metro(size: 13, weight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Yordam soʻrash',
              icon: AppIcons.chat,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Soʻrovingiz yuborildi', style: metro(color: Colors.white))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
