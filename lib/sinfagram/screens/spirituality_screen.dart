import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Maʼnaviyat va vatanparvarlik" — materiallar roʻyxati + interaktiv viktorina.
class SpiritualityScreen extends StatefulWidget {
  const SpiritualityScreen({Key? key}) : super(key: key);

  @override
  State<SpiritualityScreen> createState() => _SpiritualityScreenState();
}

class _SpiritualityScreenState extends State<SpiritualityScreen> {
  int _q = 0; // joriy savol indeksi
  int? _picked; // shu savol uchun tanlangan variant (null = hali javob berilmagan)
  int _score = 0;
  bool _done = false;

  void _pick(int idx, QuizQuestion q) {
    if (_picked != null) return; // bir savolga bir marta
    setState(() {
      _picked = idx;
      if (idx == q.correct) _score++;
    });
  }

  void _next() {
    setState(() {
      if (_q < spiritualityQuiz.length - 1) {
        _q++;
        _picked = null;
      } else {
        _done = true;
      }
    });
  }

  void _restart() {
    setState(() {
      _q = 0;
      _picked = null;
      _score = 0;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Maʼnaviyat va vatanparvarlik'),
      body: ListView(
        children: [
          const SinfHero(
            title: 'Yurt maʼnaviyati',
            subtitle: 'Tarixiy meros, milliy qadriyatlar va bilim sinovi.',
            icon: AppIcons.book,
          ),
          const SectionHeader('Materiallar'),
          ...List.generate(spiritualityMaterials.length, (i) {
            final m = spiritualityMaterials[i];
            return FadeInUp(index: i, child: _materialCard(m['title'] ?? '', m['type'] ?? ''));
          }),
          const SectionHeader('Viktorina'),
          FadeInUp(child: _done ? _resultCard() : _quizCard()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _materialCard(String title, String type) {
    return SinfCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SinfColors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(AppIcons.book, color: SinfColors.purple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: metro(size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(type, style: metro(size: 12, color: SinfColors.muted)),
              ],
            ),
          ),
          Icon(AppIcons.arrowRight, color: SinfColors.muted),
        ],
      ),
    );
  }

  Widget _quizCard() {
    final q = spiritualityQuiz[_q];
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Pill('Savol ${_q + 1} / ${spiritualityQuiz.length}', color: SinfColors.purple, icon: AppIcons.quiz),
              Text('Ball: $_score', style: metro(size: 12, color: SinfColors.muted, weight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Text(q.question, style: metro(size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...List.generate(q.options.length, (i) => _optionTile(q, i)),
          if (_picked != null) ...[
            const SizedBox(height: 12),
            Text(
              _picked == q.correct ? 'Toʻgʻri javob! Barakalla.' : 'Notoʻgʻri — yashil variant toʻgʻri javob.',
              style: metro(
                size: 13,
                weight: FontWeight.w600,
                color: _picked == q.correct ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: _q < spiritualityQuiz.length - 1 ? 'Keyingi' : 'Natijani koʻrish',
                icon: AppIcons.arrowRight,
                onTap: _next,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _optionTile(QuizQuestion q, int i) {
    final answered = _picked != null;
    final isCorrect = i == q.correct;
    final isPicked = i == _picked;

    Color border = Colors.grey.shade200;
    Color bg = Colors.grey.shade50;
    Color textColor = SinfColors.text;
    IconData? mark;
    Color markColor = SinfColors.muted;

    if (answered) {
      if (isCorrect) {
        border = Colors.green.shade300;
        bg = Colors.green.withOpacity(0.08);
        textColor = Colors.green.shade800;
        mark = AppIcons.check;
        markColor = Colors.green.shade600;
      } else if (isPicked) {
        border = Colors.red.shade300;
        bg = Colors.red.withOpacity(0.08);
        textColor = Colors.red.shade800;
        mark = AppIcons.close;
        markColor = Colors.red.shade600;
      } else {
        textColor = SinfColors.muted;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Pressable(
        onTap: answered ? null : () => _pick(i, q),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: 1.4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(q.options[i], style: metro(size: 14, weight: FontWeight.w600, color: textColor)),
              ),
              if (mark != null) Icon(mark, color: markColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultCard() {
    final total = spiritualityQuiz.length;
    final ratio = total == 0 ? 0.0 : _score / total;
    String title;
    IconData icon;
    if (ratio == 1.0) {
      title = 'Ajoyib! Barcha javoblar toʻgʻri.';
      icon = AppIcons.trophy;
    } else if (ratio >= 0.5) {
      title = 'Yaxshi natija! Yana bir bor sinab koʻring.';
      icon = AppIcons.like;
    } else {
      title = 'Mashq qilishda davom eting — hammasi qoʻlingizdan keladi!';
      icon = AppIcons.spirit;
    }

    return SinfCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(gradient: sinfButtonGradient, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 14),
          Text('$_score / $total', style: metro(size: 30, weight: FontWeight.w800, color: SinfColors.primary)),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: metro(size: 14, weight: FontWeight.w600)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: GradientButton(label: 'Qaytadan', icon: AppIcons.refresh, onTap: _restart),
          ),
        ],
      ),
    );
  }
}
