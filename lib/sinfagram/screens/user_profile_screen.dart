import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import '../widgets/profile_widgets.dart';

/// Sinfdosh profili (Instagram-uslubi). Jonli: obuna, maqtov (kudos).
class UserProfileScreen extends StatelessWidget {
  final Classmate mate;
  const UserProfileScreen({Key? key, required this.mate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final m = mate;
    final following = app.isFollowing(m.name);
    final kudosMap = app.kudosFor(m.name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar(m.name),
      body: ListView(
        children: [
          FadeInUp(
            child: ProfileHeader(
              name: m.name,
              subtitle: m.className,
              bio: m.bio,
              posts: m.posts,
              followers: app.followersOf(m.name, m.followers),
              following: m.following,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: following ? 'Obuna boʻlingan' : 'Obuna boʻlish',
                    icon: following ? AppIcons.check : AppIcons.people,
                    onTap: () {
                      app.toggleFollow(m.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(!following ? '${m.name}ga obuna boʻldingiz' : 'Obuna bekor qilindi'), duration: const Duration(milliseconds: 900)),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SinfColors.primary,
                      side: BorderSide(color: SinfColors.primary.withOpacity(0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _openKudos(context, app, m),
                    icon: const Icon(AppIcons.kudos, size: 18),
                    label: Text('Maqtash', style: metro(size: 14, weight: FontWeight.w700, color: SinfColors.primary)),
                  ),
                ),
              ],
            ),
          ),
          if (kudosMap.isNotEmpty) _kudosRow(kudosMap),
          const SectionHeader('Postlar'),
          PhotoGrid(photos: m.photos, ownerName: m.name),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _kudosRow(Map<String, int> kudosMap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: kudosMap.entries.map((e) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(AppIcons.kudosFill, size: 16, color: Color(0xFFF2994A)),
              const SizedBox(width: 6),
              Text('${e.key} · ${e.value}', style: metro(size: 12.5, weight: FontWeight.w600, color: Colors.black87)),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _openKudos(BuildContext context, AppState app, Classmate m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${m.name}ni maqtang', style: momo(size: 18)),
            const SizedBox(height: 4),
            Text('Ijobiy fazilat tanlang — profiliga qoʻshiladi', style: metro(size: 12.5, color: SinfColors.muted)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kKudos.map((label) {
                final color = juicyFor(label);
                return Pressable(
                  onTap: () {
                    app.giveKudos(m.name, label);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${m.name}ga "$label" berildi'), duration: const Duration(milliseconds: 1000)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.28)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(AppIcons.kudos, size: 17, color: color),
                      const SizedBox(width: 8),
                      Text(label, style: metro(size: 13.5, weight: FontWeight.w700, color: color)),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
