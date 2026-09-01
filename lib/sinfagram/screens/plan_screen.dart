import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import 'tasks_screen.dart';
import 'schedule_screen.dart';
import 'calendar_screen.dart';
import 'leaderboard_screen.dart';
import 'birthdays_screen.dart';

/// "Reja" tabi — bugungi dars/vazifa xulosasi va bo'limlarga kirish.
class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undone = tasks.where((t) => !t.done).toList();
    final firstUndone = undone.isNotEmpty ? undone.first.title : 'Barcha vazifalar bajarildi';
    final firstDay = schedule[0];
    final firstLesson = firstDay.lessons[0].subject;
    final firstEvent = events[0].title;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Reja', back: false),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          FadeInUp(
            index: 0,
            child: SinfHero(
              title: 'Bugungi reja',
              subtitle: '${firstDay.lessons.length} ta dars, ${undone.length} ta vazifa',
              icon: AppIcons.plan,
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(index: 1, child: _PlanTile(icon: AppIcons.task, title: 'Vazifalar', subtitle: firstUndone, color: const Color(0xFF12B39B), onTap: () => Navigator.push(context, sinfRoute(const TasksScreen())))),
          FadeInUp(index: 2, child: _PlanTile(icon: AppIcons.schedule, title: 'Dars jadvali', subtitle: '${firstDay.day} — $firstLesson', color: const Color(0xFF2F80ED), onTap: () => Navigator.push(context, sinfRoute(const ScheduleScreen())))),
          FadeInUp(index: 3, child: _PlanTile(icon: AppIcons.events, title: 'Kalendar', subtitle: firstEvent, color: const Color(0xFFF2994A), onTap: () => Navigator.push(context, sinfRoute(const CalendarScreen())))),
          FadeInUp(index: 4, child: _PlanTile(icon: AppIcons.leaderboard, title: 'Sinf reytingi', subtitle: 'Faollik ballari boʻyicha', color: const Color(0xFF8B2FC9), onTap: () => Navigator.push(context, sinfRoute(const LeaderboardScreen())))),
          FadeInUp(index: 5, child: _PlanTile(icon: AppIcons.birthday, title: 'Tugʻilgan kunlar', subtitle: 'Sinfdoshlarni tabriklang', color: const Color(0xFFEB4D8C), onTap: () => Navigator.push(context, sinfRoute(const BirthdaysScreen())))),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _PlanTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.16), blurRadius: 24, offset: const Offset(0, 12)),
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.28)!], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: metro(size: 17, weight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(AppIcons.arrowRight, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
