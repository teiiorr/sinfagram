import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Shaxsiy oʻsish jurnali" — faqat oʻquvchining oʻziga koʻrinadigan maxfiy kundalik.
class GrowthJournalScreen extends StatefulWidget {
  const GrowthJournalScreen({Key? key}) : super(key: key);

  @override
  State<GrowthJournalScreen> createState() => _GrowthJournalScreenState();
}

class _GrowthJournalScreenState extends State<GrowthJournalScreen> {
  static const List<String> _moods = ['😄', '🙂', '😐', '😔', '😤'];

  final TextEditingController _controller = TextEditingController();
  String _picked = '🙂';
  late final List<JournalEntry> _entries = List<JournalEntry>.from(journal);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avval bir necha soʻz yozing')),
      );
      return;
    }
    setState(() {
      _entries.insert(0, JournalEntry(date: 'Bugun', mood: _picked, text: text));
      _controller.clear();
      _picked = '🙂';
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saqlandi — bu yozuvni faqat sen koʻrasan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Shaxsiy oʻsish jurnali'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          // Maxfiylik banneri
          SinfCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SinfColors.purple.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(AppIcons.lock, color: Colors.purple, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bu jurnalni faqat sen koʻrasan. Hech kim — oʻqituvchi ham, ota-ona ham koʻrmaydi.',
                    style: metro(size: 13, weight: FontWeight.w600, color: SinfColors.text),
                  ),
                ),
              ],
            ),
          ),
          // Yangi yozuv
          SinfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bugun oʻzingni qanday his qilyapsan?', style: metro(size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _moods.map((m) {
                    final selected = m == _picked;
                    return Pressable(
                      onTap: () => setState(() => _picked = m),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? SinfColors.purple.withOpacity(0.12) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected ? SinfColors.purple : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(m, style: const TextStyle(fontSize: 26)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 3,
                  style: metro(size: 14),
                  decoration: InputDecoration(
                    hintText: 'Bugun nimalarni oʻrgandim, nimadan xursandman...',
                    hintStyle: metro(size: 13, color: SinfColors.muted),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: SinfColors.purple, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: GradientButton(label: 'Saqlash', icon: AppIcons.check, onTap: _save),
                ),
              ],
            ),
          ),
          const SectionHeader('Yozuvlarim'),
          ...List.generate(
            _entries.length,
            (i) {
              final e = _entries[i];
              return FadeInUp(
                index: i,
                child: SinfCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.mood, style: const TextStyle(fontSize: 34)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.date, style: metro(size: 12, color: SinfColors.muted, weight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(e.text, style: metro(size: 14, weight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
