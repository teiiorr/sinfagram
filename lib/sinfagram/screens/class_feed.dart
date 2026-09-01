import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import '../widgets/feed_card.dart';
import '../widgets/mood_strip.dart';
import 'class_chat.dart';
import 'tasks_screen.dart';
import 'threads_screen.dart';
import 'story_viewer.dart';
import 'search_screen.dart';
import 'saved_screen.dart';

/// "Sinf" tabi — sinf lentasi (jonli) + storylar + kayfiyat.
class ClassFeedScreen extends StatelessWidget {
  const ClassFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Sinfagram', back: false, titleWidget: sinfWordmark(size: 28), actions: [
        IconButton(
          icon: const Icon(AppIcons.search, color: Colors.black, size: 24),
          onPressed: () => Navigator.push(context, sinfRoute(const SearchScreen())),
        ),
        IconButton(
          icon: const Icon(AppIcons.saved, color: Colors.black, size: 24),
          onPressed: () => Navigator.push(context, sinfRoute(const SavedScreen())),
        ),
        IconButton(
          icon: const Icon(AppIcons.chat, color: Colors.black, size: 24),
          onPressed: () => Navigator.push(context, sinfRoute(const ClassChatScreen())),
        ),
      ]),
      body: ListView(
        children: [
          _storyRow(context, app),
          const SizedBox(height: 4),
          const MoodStrip(),
          _quickActions(context),
          const Divider(height: 1),
          const SizedBox(height: 6),
          for (int i = 0; i < app.feed.length; i++)
            FadeInUp(index: i < 6 ? i : 0, child: FeedCard(key: ValueKey(app.feed[i].id), post: app.feed[i])),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _storyRow(BuildContext context, AppState app) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final s = stories[i];
          final name = i == 0 ? currentUser.name : s.name;
          final seen = app.seenStories.contains(i);
          return Pressable(
            onTap: () {
              app.markStorySeen(i);
              Navigator.push(context, sinfRoute(StoryViewerScreen(initialIndex: i)));
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Opacity(opacity: seen ? 0.55 : 1.0, child: Avatar(name, radius: 30, ring: true)),
                    if (i == 0)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(color: SinfColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(width: 66, child: Text(i == 0 ? 'Siz' : s.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: metro(size: 11, weight: FontWeight.w600))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
        children: [
          Expanded(child: _actionTile(context, AppIcons.chat, 'Suhbat', const Color(0xFF2F80ED), () => Navigator.push(context, sinfRoute(const ClassChatScreen())))),
          const SizedBox(width: 11),
          Expanded(child: _actionTile(context, AppIcons.thread, 'Munozara', const Color(0xFFEF5DA8), () => Navigator.push(context, sinfRoute(const ThreadsScreen())))),
          const SizedBox(width: 11),
          Expanded(child: _actionTile(context, AppIcons.task, 'Vazifa', const Color(0xFF12B39B), () => Navigator.push(context, sinfRoute(const TasksScreen())))),
        ],
      ),
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Pressable(
      onTap: onTap,
      scale: 0.93,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.16), color.withOpacity(0.07)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: metro(size: 12, weight: FontWeight.w700, color: color))),
        ]),
      ),
    );
  }
}
