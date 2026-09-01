import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// Dars jadvali — yuqorida kun chiplari, pastda tanlangan kunning darslari
/// vertikal taymlayn koʻrinishida.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final day = schedule[_selected];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Dars jadvali'),
      body: Column(
        children: [
          _dayChips(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 6, bottom: 20),
              children: [
                for (int i = 0; i < day.lessons.length; i++)
                  FadeInUp(
                    key: ValueKey('${day.day}-$i'),
                    index: i,
                    child: _lessonCard(day.lessons[i]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayChips() {
    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        itemCount: schedule.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final selected = i == _selected;
          return Pressable(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                gradient: selected ? sinfButtonGradient : null,
                color: selected ? null : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                schedule[i].day,
                style: metro(
                  size: 13,
                  weight: FontWeight.w700,
                  color: selected ? Colors.white : SinfColors.text,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _lessonCard(Lesson l) {
    return SinfCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: SinfColors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              l.time,
              style: metro(size: 13, weight: FontWeight.w700, color: SinfColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.subject, style: metro(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(AppIcons.location, size: 14, color: SinfColors.muted),
                    const SizedBox(width: 4),
                    Text(l.room, style: metro(size: 12, color: SinfColors.muted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
