import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// Sinf kalendari — tadbirlar roʻyxati. Har bir tadbir sana nishonchasi,
/// sarlavha, turi (Pill) va joyi bilan koʻrsatiladi.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  // Tadbir turiga qarab rang (apostrof turiga bogʻlanmasdan mos keladi).
  Color _typeColor(String type) {
    if (type.startsWith('Ekskursiya')) return SinfColors.blue;
    if (type.contains('naviyat')) return SinfColors.deepPurple;
    return SinfColors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Sinf kalendari'),
      body: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 20),
        children: [
          for (int i = 0; i < events.length; i++)
            FadeInUp(index: i, child: _eventCard(events[i])),
        ],
      ),
    );
  }

  Widget _dateBadge(String date) {
    final parts = date.split('-');
    final day = parts.isNotEmpty ? parts[0] : date;
    final month = parts.length > 1 ? parts[1] : '';
    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: sinfButtonGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(day, style: metro(size: 20, weight: FontWeight.w800, color: Colors.white)),
          if (month.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                month,
                textAlign: TextAlign.center,
                style: metro(size: 10, weight: FontWeight.w600, color: Colors.white70),
              ),
            ),
        ],
      ),
    );
  }

  Widget _eventCard(SinfEvent e) {
    final color = _typeColor(e.type);
    return SinfCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateBadge(e.date),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: metro(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 8),
                Pill(e.type, color: color, icon: AppIcons.events),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(AppIcons.location, size: 14, color: SinfColors.muted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(e.place, style: metro(size: 12, color: SinfColors.muted)),
                    ),
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
