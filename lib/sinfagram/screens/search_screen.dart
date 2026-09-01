import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import 'user_profile_screen.dart';

/// Qidiruv — sinfdoshlar va postlar boʻyicha (jonli).
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final mates = app.searchClassmates(_q);
    final posts = app.searchPosts(_q);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              const Icon(AppIcons.search, size: 19, color: Colors.black54),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  autofocus: true,
                  onChanged: (v) => setState(() => _q = v),
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Sinfdosh yoki post qidiring...', hintStyle: metro(size: 14, color: SinfColors.muted)),
                  style: metro(size: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          if (mates.isNotEmpty) const SectionHeader('Sinfdoshlar'),
          ...mates.map((m) => FadeInUp(
                child: ListTile(
                  leading: Avatar(m.name, radius: 24, ring: true),
                  title: Text(m.name, style: metro(size: 14.5, weight: FontWeight.w700)),
                  subtitle: Text(m.bio, style: metro(size: 12.5, color: SinfColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(AppIcons.arrowRight, size: 18, color: Colors.black38),
                  onTap: () => Navigator.push(context, sinfRoute(UserProfileScreen(mate: m))),
                ),
              )),
          if (_q.isNotEmpty && posts.isNotEmpty) const SectionHeader('Postlar'),
          ...posts.map((p) => FadeInUp(
                child: SinfCard(
                  child: Row(
                    children: [
                      Avatar(p.author, radius: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.author, style: metro(size: 13.5, weight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(p.text ?? '(rasm)', style: metro(size: 13, color: SinfColors.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          if (mates.isEmpty && posts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Center(child: Text('Hech narsa topilmadi', style: metro(size: 14, color: SinfColors.muted))),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
