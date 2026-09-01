import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Direktor dashboardi" — maktab boʻyicha agregat koʻrsatkichlar.
/// Faqat umumiy holat: shaxsiy maʼlumotlar yoki yozishmalar koʻrinmaydi.
class DirectorDashboardScreen extends StatelessWidget {
  const DirectorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = directorStats.entries.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Direktor dashboardi'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SinfHero(
            title: 'Maktab koʻrsatkichlari',
            subtitle: 'Umumiy holat',
            icon: AppIcons.director,
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
          FadeInUp(index: stats.length, child: _coverageCard()),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SinfColors.purple.withOpacity(0.07),
            SinfColors.blue.withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SinfColors.purple.withOpacity(0.08), width: 1),
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
              style: metro(size: 26, weight: FontWeight.w800, color: SinfColors.primary, spacing: -0.5),
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

  Widget _coverageCard() {
    const target = 0.64;
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: SinfColors.purple.withOpacity(0.08), shape: BoxShape.circle),
                child: const Icon(AppIcons.people, color: SinfColors.purple, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text('Klublar qamrovi', style: metro(size: 16, weight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: target),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: t,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(SinfColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(t * 100).round()}% oʻquvchi klublarda faol',
                    style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
