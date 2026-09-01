import 'package:flutter/material.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Yordam" (SOS) — tinch, qo'llab-quvvatlovchi ekran (bezovta qilmaydigan).
class SosScreen extends StatelessWidget {
  const SosScreen({Key? key}) : super(key: key);

  void _sendRequest(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(AppIcons.check, color: Color(0xFF2E9E83), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Yuborildi', style: metro(size: 18, weight: FontWeight.w700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Murojaating maxfiy yuborildi. Psixolog tez orada bogʻlanadi.',
              style: metro(size: 14, weight: FontWeight.w500).copyWith(height: 1.4),
            ),
            const SizedBox(height: 10),
            Text(
              'Sen yolgʻiz emassan — biz doim yoningdamiz. 💛',
              style: metro(size: 13, color: SinfColors.muted).copyWith(height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Yaxshi', style: metro(size: 14, weight: FontWeight.w700, color: SinfColors.purple)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Yordam'),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          FadeInUp(
            index: 0,
            child: Center(
              child: Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: SinfColors.purple.withOpacity(0.08), shape: BoxShape.circle),
                child: const Icon(AppIcons.kudos, color: SinfColors.purple, size: 46),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            index: 1,
            child: SinfCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yoningdamiz', style: metro(size: 17, weight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    'Oʻzingni yolgʻiz his qilyapsanmi yoki yordam kerakmi? Bu tugma orqali psixolog va sinf rahbaringga MAXFIY murojaat yuborasan. Xabaring boshqa oʻquvchilarga koʻrinmaydi.',
                    style: metro(size: 14, weight: FontWeight.w500).copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(
            index: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: GradientButton(
                label: 'Yordam soʻrash',
                icon: AppIcons.heartFill,
                onTap: () => _sendRequest(context),
              ),
            ),
          ),
          FadeInUp(
            index: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                'Murojaating faqat psixolog va sinf rahbaringga koʻrinadi.',
                textAlign: TextAlign.center,
                style: metro(size: 12, color: SinfColors.muted).copyWith(height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
