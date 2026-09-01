import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Ota-ona xabarnomasi" — faqat oʻquv faktlari (davomat, vazifa, baho).
/// Bolaning ijtimoiy hayotiga oyna emas; har bir xabar aniq harakatga ishora.
class ParentNotificationsScreen extends StatelessWidget {
  const ParentNotificationsScreen({Key? key}) : super(key: key);

  Color _typeColor(String type) {
    switch (type) {
      case 'Davomat':
        return SinfColors.blue;
      case 'Vazifa':
        return Colors.orange.shade800;
      case 'Baho':
        return Colors.green.shade700;
      default:
        return SinfColors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Ota-ona xabarnomasi'),
      body: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 24),
        children: [
          FadeInUp(index: 0, child: _noteCard()),
          ...List.generate(parentNotifications.length, (i) {
            final n = parentNotifications[i];
            final type = n['type'] ?? '';
            return FadeInUp(
              index: i + 1,
              child: _notificationCard(type, n['text'] ?? '', n['action'] ?? ''),
            );
          }),
        ],
      ),
    );
  }

  Widget _noteCard() {
    return SinfCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: SinfColors.purple.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(AppIcons.safety, color: SinfColors.purple, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Faqat oʻquv faktlari — davomat, vazifa, baho. Bolaning ijtimoiy hayotiga oyna emas.',
              style: metro(size: 14, weight: FontWeight.w500, color: SinfColors.text).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard(String type, String text, String action) {
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pill(type, color: _typeColor(type), icon: AppIcons.info),
          const SizedBox(height: 10),
          Text(
            text,
            style: metro(size: 15, weight: FontWeight.w700).copyWith(height: 1.35),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(AppIcons.arrowRight, size: 16, color: SinfColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  action,
                  style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
