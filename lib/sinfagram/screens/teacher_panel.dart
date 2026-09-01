import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Oʻqituvchi paneli" — sinf makonini kuzatish (agregat koʻrsatkichlar).
/// Oʻqituvchi ishtirokchi: shaxsiy xabarlarni koʻrmaydi, faqat umumiy holat.
class TeacherPanelScreen extends StatelessWidget {
  const TeacherPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = teacherStats.entries.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Oʻqituvchi paneli'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SinfHero(
            title: '9-A sinf',
            subtitle: 'Sinf makonini boshqarish',
            icon: AppIcons.teacherPanel,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, i) {
                final e = stats[i];
                return FadeInUp(index: i, child: _statCard(e.key, e.value));
              },
            ),
          ),
          FadeInUp(index: stats.length, child: _noteCard()),
          const SizedBox(height: 6),
          FadeInUp(
            index: stats.length + 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
              child: GradientButton(
                label: 'Attestatsiya portfoliosini yuklash',
                icon: AppIcons.download,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Yil oxirida bir tugma bilan tayyor boʻladi',
                      style: metro(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: metro(size: 28, weight: FontWeight.w800, color: SinfColors.primary, spacing: -0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: metro(size: 12.5, color: SinfColors.muted, weight: FontWeight.w600).copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _noteCard() {
    return SinfCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: SinfColors.purple.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(AppIcons.eyeOff, color: SinfColors.purple, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Oʻqituvchi — ishtirokchi, kuzatuvchi emas. Shaxsiy xabarlar oʻqilmaydi.',
              style: metro(size: 14, weight: FontWeight.w500, color: SinfColors.text).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
