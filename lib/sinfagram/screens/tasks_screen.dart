import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Vazifalar taxtasi — uy vazifalari. Doira bosilganda bajarilgan holatga
/// oʻtadi (AppState orqali, sessiya davomida saqlanadi) + umumiy progress.
class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final tasksList = app.taskList;
    final undone = tasksList.where((t) => !t.done).length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Vazifalar taxtasi'),
      body: ListView(
        children: [
          _progressCard(app, undone),
          const SizedBox(height: 4),
          for (int i = 0; i < tasksList.length; i++) FadeInUp(index: i, child: _taskCard(context, tasksList[i])),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _progressCard(AppState app, int undone) {
    final pct = app.taskProgress;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: sinfButtonGradient, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(AppIcons.task, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vazifalar', style: momo(size: 24, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('$undone ta bajarilmagan · ${(pct * 100).round()}% bajarildi', style: metro(size: 12.5, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 9, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(BuildContext context, HomeworkTask t) {
    return SinfCard(
      onTap: () => context.read<AppState>().toggleTask(t),
      child: Row(
        children: [
          _checkbox(context, t),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Pill(t.subject, color: SinfColors.purple, icon: AppIcons.book),
                const SizedBox(height: 6),
                Text(
                  t.title,
                  style: metro(
                    size: 14,
                    weight: FontWeight.w600,
                    color: t.done ? SinfColors.muted : SinfColors.text,
                  ).copyWith(
                    decoration: t.done ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Pill(
            t.due,
            color: t.due == 'Ertaga' ? Colors.red : SinfColors.blue,
            icon: AppIcons.clock,
          ),
        ],
      ),
    );
  }

  Widget _checkbox(BuildContext context, HomeworkTask t) {
    return Pressable(
      onTap: () => context.read<AppState>().toggleTask(t),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: t.done ? sinfButtonGradient : null,
          border: t.done ? null : Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: t.done ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
      ),
    );
  }
}
