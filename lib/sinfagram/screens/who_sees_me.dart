import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Meni kim ko'radi" — maxfiylik va shaffoflik jadvali (ishonchli ohang).
class WhoSeesMeScreen extends StatelessWidget {
  const WhoSeesMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Meni kim koʻradi'),
      body: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 24),
        children: [
          FadeInUp(
            index: 0,
            child: SinfCard(
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
                      'Sinfagramʼda hamma narsa shaffof. Quyida kim nimani koʻrishi aniq koʻrsatilgan.',
                      style: metro(size: 14, weight: FontWeight.w500, color: SinfColors.text).copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...List.generate(visibility.length, (i) {
            final v = visibility[i];
            return FadeInUp(
              index: i + 1,
              child: SinfCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(AppIcons.whoSees, color: SinfColors.purple, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v.what, style: metro(size: 15, weight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            v.whoSees,
                            style: metro(size: 13, color: SinfColors.muted).copyWith(height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
