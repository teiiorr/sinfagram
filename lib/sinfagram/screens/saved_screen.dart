import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import '../widgets/feed_card.dart';

/// Saqlangan postlar — belgi (bookmark) qoʻyilganlar.
class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final saved = app.savedPosts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Saqlangan'),
      body: saved.isEmpty
          ? _empty()
          : ListView(
              children: [
                const SizedBox(height: 6),
                for (int i = 0; i < saved.length; i++)
                  FadeInUp(index: i < 6 ? i : 0, child: FeedCard(key: ValueKey('saved_${saved[i].id}'), post: saved[i])),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.saved, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Saqlangan postlar yoʻq', style: metro(size: 15, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Postdagi belgini bosib saqlang', style: metro(size: 13, color: SinfColors.muted)),
        ],
      ),
    );
  }
}
