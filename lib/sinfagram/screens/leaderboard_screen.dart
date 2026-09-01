import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import 'user_profile_screen.dart';

/// Sinf reytingi — faollik ballari (post, izoh, vazifa, maqtov).
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  static const _medals = [Color(0xFFF2C94C), Color(0xFFBFC7D1), Color(0xFFCD8B5B)];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final lb = app.leaderboard;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Sinf reytingi'),
      body: ListView(
        children: [
          _header(app),
          for (int i = 0; i < lb.length; i++) _row(context, i, lb[i].key, lb[i].value),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(AppState app) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: sinfButtonGradient, borderRadius: BorderRadius.circular(28)),
      child: Row(
        children: [
          const Icon(AppIcons.trophy, color: Colors.white, size: 44),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sizning oʻrningiz: ${app.myRank()}', style: momo(size: 20, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${app.myPoints} ball · faol boʻling, koʻtariling', style: metro(size: 12.5, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, int i, String name, int points) {
    final me = name == currentUser.name;
    final medal = i < 3 ? _medals[i] : null;
    return FadeInUp(
      index: i < 6 ? i : 0,
      child: SinfCard(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        onTap: me ? null : () => _openMate(context, name),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: medal != null
                  ? Icon(AppIcons.trophy, color: medal, size: 26)
                  : Text('${i + 1}', textAlign: TextAlign.center, style: metro(size: 16, weight: FontWeight.w700, color: SinfColors.muted)),
            ),
            const SizedBox(width: 6),
            Avatar(name, radius: 22, ring: i < 3),
            const SizedBox(width: 12),
            Expanded(
              child: Text(me ? '$name (siz)' : name, style: metro(size: 14.5, weight: me ? FontWeight.w800 : FontWeight.w600, color: me ? SinfColors.primary : Colors.black)),
            ),
            Row(children: [
              const Icon(AppIcons.star, size: 16, color: Color(0xFFF2C94C)),
              const SizedBox(width: 5),
              Text('$points', style: metro(size: 14, weight: FontWeight.w700)),
            ]),
          ],
        ),
      ),
    );
  }

  void _openMate(BuildContext context, String name) {
    Classmate? m;
    for (final c in classmates) {
      if (c.name == name) {
        m = c;
        break;
      }
    }
    if (m != null) Navigator.push(context, sinfRoute(UserProfileScreen(mate: m)));
  }
}
