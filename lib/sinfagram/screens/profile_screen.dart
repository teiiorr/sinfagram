import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/settings/settings.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import '../widgets/profile_widgets.dart';
import 'activity_screen.dart';
import 'classmates_screen.dart';
import 'portfolio_screen.dart';
import 'career_test.dart';
import 'growth_journal.dart';
import 'who_sees_me.dart';
import 'complaint_screen.dart';
import 'sos_screen.dart';
import 'teacher_panel.dart';
import 'parent_notifications.dart';
import 'director_dashboard.dart';
import 'leaderboard_screen.dart';
import 'birthdays_screen.dart';
import 'saved_screen.dart';

/// "Profil" tabi — Instagram-uslubi (fotolar to'ri) + Sinfagram funksiyalari.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final photos = [...app.myPostsExtra, ...myPosts];
    final myKudos = app.kudosFor(currentUser.name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar(
        'Profil',
        back: false,
        actions: [
          IconButton(
            tooltip: 'Faoliyat',
            icon: const Icon(AppIcons.activity, color: Colors.black),
            onPressed: () => Navigator.push(context, sinfRoute(const SinfActivityScreen())),
          ),
          IconButton(
            tooltip: 'Sinfdoshlar',
            icon: const Icon(AppIcons.people, color: Colors.black),
            onPressed: () => Navigator.push(context, sinfRoute(const ClassmatesScreen())),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          FadeInUp(
            index: 0,
            child: ProfileHeader(
              name: currentUser.name,
              subtitle: '${currentUser.className} · ${currentUser.school}',
              bio: myBio,
              posts: myPostsCount + app.myPostsExtra.length,
              followers: myFollowers,
              following: app.myFollowingCount,
            ),
          ),
          FadeInUp(index: 1, child: _actions(context)),
          FadeInUp(index: 2, child: _highlights(context, app)),
          if (myKudos.isNotEmpty) FadeInUp(index: 2, child: _kudosRow(myKudos)),
          FadeInUp(index: 3, child: const SectionHeader('Mening postlarim')),
          FadeInUp(index: 3, child: PhotoGrid(photos: photos, ownerName: currentUser.name)),
          const SizedBox(height: 6),
          FadeInUp(index: 4, child: _sosButton(context)),
          const SizedBox(height: 4),
          _menuRow(context, AppIcons.portfolio, 'Portfolio', const PortfolioScreen()),
          _menuRow(context, AppIcons.career, 'Kasb yoʻnalishi testi', const CareerTestScreen()),
          _menuRow(context, AppIcons.growth, 'Shaxsiy oʻsish jurnali', const GrowthJournalScreen()),
          _menuRow(context, AppIcons.whoSees, 'Meni kim koʻradi', const WhoSeesMeScreen()),
          _menuRow(context, AppIcons.complaint, 'Maxfiy shikoyat', const ComplaintScreen()),
          const SectionHeader('Kattalar uchun'),
          _menuRow(context, AppIcons.teacherPanel, 'Oʻqituvchi paneli', const TeacherPanelScreen()),
          _menuRow(context, AppIcons.parent, 'Ota-ona xabarnomasi', const ParentNotificationsScreen()),
          _menuRow(context, AppIcons.director, 'Direktor dashboardi', const DirectorDashboardScreen()),
          const SizedBox(height: 20),
          Center(
            child: Text('Designed & Developed by teiior', style: metro(size: 12, color: Colors.grey.shade500, weight: FontWeight.w500)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Yangi funksiyalarga tez kirish (reyting, tugʻilgan kunlar, saqlangan)
  Widget _highlights(BuildContext context, AppState app) {
    Widget tile(IconData icon, String label, String sub, Color color, Widget target) => Expanded(
          child: Pressable(
            onTap: () => Navigator.push(context, sinfRoute(target)),
            scale: 0.94,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.09),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.18)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 7),
                Text(label, style: metro(size: 12, weight: FontWeight.w700, color: color)),
                const SizedBox(height: 2),
                Text(sub, style: metro(size: 10.5, color: SinfColors.muted)),
              ]),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
      child: Row(
        children: [
          tile(AppIcons.leaderboard, 'Reyting', '${app.myRank()}-oʻrin', const Color(0xFF8B2FC9), const LeaderboardScreen()),
          const SizedBox(width: 10),
          tile(AppIcons.birthday, 'Tugʻilgan kun', 'Tabriklash', const Color(0xFFEB4D8C), const BirthdaysScreen()),
          const SizedBox(width: 10),
          tile(AppIcons.saved, 'Saqlangan', '${app.savedPosts.length} post', const Color(0xFF2F80ED), const SavedScreen()),
        ],
      ),
    );
  }

  Widget _kudosRow(Map<String, int> kudosMap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Row(
        children: [
          const Icon(AppIcons.kudosFill, size: 17, color: Color(0xFFF2994A)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Maqtovlar: ${kudosMap.entries.map((e) => '${e.key} (${e.value})').join(', ')}',
              style: metro(size: 12.5, weight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    OutlinedButton btn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 17, color: Colors.black87),
          label: Text(label, style: metro(size: 13, weight: FontWeight.w600, color: Colors.black87)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(vertical: 11),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 2),
      child: Row(
        children: [
          Expanded(
            child: btn('Profilni tahrirlash', AppIcons.edit,
                () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profilni tahrirlash (demo)')))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: btn('Sozlamalar', AppIcons.settings, () => Navigator.push(context, sinfRoute(AppSettings()))),
          ),
        ],
      ),
    );
  }

  Widget _sosButton(BuildContext context) {
    const red = Color(0xFFE53935);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: Pressable(
        onTap: () => Navigator.push(context, sinfRoute(const SosScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: red.withOpacity(0.30), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                child: const Icon(AppIcons.sos, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SOS — yordam', style: metro(size: 16, weight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('Maxfiy yordam soʻrash', style: metro(size: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(AppIcons.arrowRight, color: Colors.white70, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuRow(BuildContext context, IconData icon, String title, Widget target) {
    final color = juicyFor(title);
    return SinfCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => Navigator.push(context, sinfRoute(target)),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.28)!], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.32), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: metro(size: 15, weight: FontWeight.w600))),
          Icon(AppIcons.arrowRight, color: color, size: 18),
        ],
      ),
    );
  }
}
