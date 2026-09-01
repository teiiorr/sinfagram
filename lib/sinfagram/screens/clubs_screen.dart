import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// Klublar va toʻgaraklar roʻyxati — qopqoq rasmi, kurator va aʼzolar soni.
class ClubsScreen extends StatelessWidget {
  const ClubsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Klublar va toʻgaraklar'),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 6, bottom: 24),
        itemCount: clubs.length,
        itemBuilder: (context, i) => FadeInUp(
          index: i,
          child: _ClubCard(club: clubs[i]),
        ),
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Club club;
  const _ClubCard({Key? key, required this.club}) : super(key: key);

  static const double _h = 150;

  @override
  Widget build(BuildContext context) {
    return SinfCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Stack(
              children: [
                SinfPhoto(club.cover, height: _h, radius: 0),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: Row(
                    children: [
                      Text(club.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          club.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: metro(size: 17, weight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(AppIcons.person, size: 16, color: SinfColors.muted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              club.curator,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: metro(size: 13, weight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(AppIcons.people, size: 16, color: SinfColors.muted),
                          const SizedBox(width: 6),
                          Text(
                            '${club.members} aʼzo',
                            style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GradientButton(
                  label: 'Aʼzo boʻlish',
                  icon: AppIcons.add,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Soʻrov yuborildi')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
