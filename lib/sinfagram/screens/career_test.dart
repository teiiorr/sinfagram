import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Kasb yoʻnalishi testi" — bir nechta savolga javob berib, oʻquvchiga
/// mos yoʻnalish va DTM fanlari boʻyicha ragʻbatlantiruvchi tavsiya beriladi.
class CareerTestScreen extends StatefulWidget {
  const CareerTestScreen({Key? key}) : super(key: key);

  @override
  State<CareerTestScreen> createState() => _CareerTestScreenState();
}

class _CareerTestScreenState extends State<CareerTestScreen> {
  int _index = 0;
  final List<int> _answers = [];

  // Har bir dominant tanlov indeksi uchun yoʻnalish tavsiyasi (soddalashtirilgan evristika).
  static const List<Map<String, dynamic>> _results = [
    {
      'title': 'IT / muhandislik yoʻnalishi',
      'desc': 'Sen mantiq va aniq masalalarni yaxshi koʻrasan. Muhandislik yoki dasturlash sohasi senga juda mos keladi!',
      'subjects': 'Matematika, Fizika',
      'icon': AppIcons.projects,
    },
    {
      'title': 'Tabiiy fanlar / tibbiyot yoʻnalishi',
      'desc': 'Sen tirik tabiat va tadqiqotga qiziqasan. Tibbiyot yoki biologiya sohasida oʻzingni topishing mumkin!',
      'subjects': 'Biologiya, Kimyo',
      'icon': AppIcons.science,
    },
    {
      'title': 'Ijtimoiy-gumanitar yoʻnalishi',
      'desc': 'Sen odamlar, tarix va soʻz bilan ishlashni yaxshi koʻrasan. Pedagogika yoki huquq sohasi senga mos!',
      'subjects': 'Tarix, Ona tili',
      'icon': AppIcons.book,
    },
    {
      'title': 'Ijod / tadbirkorlik yoʻnalishi',
      'desc': 'Sen ijodkor va tashabbuskorsan. Dizayn, media yoki biznes sohasida katta imkoniyatlaring bor!',
      'subjects': 'Matematika, Ingliz tili',
      'icon': AppIcons.idea,
    },
  ];

  Map<String, dynamic> get _result {
    // Eng koʻp tanlangan variant indeksini aniqlaymiz.
    final counts = <int, int>{};
    for (final a in _answers) {
      counts[a] = (counts[a] ?? 0) + 1;
    }
    var best = 0;
    var bestCount = -1;
    counts.forEach((k, v) {
      if (v > bestCount) {
        best = k;
        bestCount = v;
      }
    });
    return _results[best.clamp(0, _results.length - 1)];
  }

  void _pick(int optionIndex) {
    setState(() {
      _answers.add(optionIndex);
      _index++;
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final finished = _index >= careerTest.length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Kasb yoʻnalishi testi'),
      body: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 28),
        children: [
          if (!finished) _questionCard() else _resultCard(),
        ],
      ),
    );
  }

  Widget _questionCard() {
    final q = careerTest[_index];
    final progress = (_index + 1) / careerTest.length;
    return FadeInUp(
      key: ValueKey(_index),
      child: SinfCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Pill('Savol ${_index + 1} / ${careerTest.length}', icon: AppIcons.question),
                Text('${(progress * 100).round()}%', style: metro(size: 12, color: SinfColors.muted, weight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(SinfColors.purple),
              ),
            ),
            const SizedBox(height: 18),
            Text(q.question, style: metro(size: 18, weight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...List.generate(q.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Pressable(
                  onTap: () => _pick(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(q.options[i], style: metro(size: 14.5, weight: FontWeight.w600))),
                        Icon(AppIcons.arrowRight, color: SinfColors.muted, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _resultCard() {
    final r = _result;
    return Column(
      children: [
        FadeInUp(
          child: SinfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: sinfButtonGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(r['icon'] as IconData, color: Colors.white, size: 34),
                ),
                const SizedBox(height: 16),
                Text('Senga mos yoʻnalish:', style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(r['title'] as String, style: metro(size: 20, weight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(r['desc'] as String, style: metro(size: 14, weight: FontWeight.w500, color: SinfColors.text)),
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(AppIcons.book, color: SinfColors.purple, size: 20),
                    const SizedBox(width: 8),
                    Text('DTM fanlari', style: metro(size: 13, weight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(r['subjects'] as String, style: metro(size: 15, weight: FontWeight.w600, color: SinfColors.primary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeInUp(
          index: 1,
          child: SinfCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(AppIcons.info, color: SinfColors.blue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bu faqat tavsiya — asosiysi, oʻzingga yoqqan ishni tanlash. Yoʻnalishlar bilan tanishishda davom et!',
                    style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GradientButton(label: 'Qayta boshlash', icon: AppIcons.refresh, onTap: _restart),
        ),
      ],
    );
  }
}
