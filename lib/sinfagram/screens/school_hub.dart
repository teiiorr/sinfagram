import 'package:flutter/material.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import 'clubs_screen.dart';
import 'projects_screen.dart';
import 'spirituality_screen.dart';
import 'olympiads_screen.dart';
import 'mentoring_screen.dart';
import 'leaderboard_screen.dart';

/// "Maktab" tabi — katta ikonkali, sochli, havodor kartalar.
class SchoolHubScreen extends StatelessWidget {
  const SchoolHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = <_Section>[
      _Section(AppIcons.clubs, 'Klublar', 'Shaxmat, IT, teatr...', const Color(0xFF2F80ED), () => const ClubsScreen()),
      _Section(AppIcons.projects, 'Loyihalar', 'Jamoaviy ishlar', const Color(0xFFF2994A), () => const ProjectsScreen()),
      _Section(AppIcons.spirit, 'Maʼnaviyat', 'Materiallar, viktorina', const Color(0xFF8B2FC9), () => const SpiritualityScreen()),
      _Section(AppIcons.contests, 'Olimpiadalar', 'Tanlovlar taqvimi', const Color(0xFFEF5DA8), () => const OlympiadsScreen()),
      _Section(AppIcons.mentor, 'Ustoz-shogird', 'Peer mentoring', const Color(0xFF12B39B), () => const MentoringScreen()),
      _Section(AppIcons.leaderboard, 'Sinf reytingi', 'Faollik ballari', const Color(0xFF27AE60), () => const LeaderboardScreen()),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Maktab', back: false),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          const SinfHero(
            title: 'Maktab jamiyati',
            subtitle: 'Klublar, loyihalar, olimpiadalar',
            icon: AppIcons.hub,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, i) {
                final s = sections[i];
                return FadeInUp(
                  index: i,
                  child: BigIconCard(
                    icon: s.icon,
                    title: s.title,
                    subtitle: s.subtitle,
                    color: s.color,
                    onTap: () => Navigator.push(context, sinfRoute(s.build())),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Section {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget Function() build;
  const _Section(this.icon, this.title, this.subtitle, this.color, this.build);
}
