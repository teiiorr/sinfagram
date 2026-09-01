import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Portfolio" — oʻquvchining yutuqlari (sertifikat, loyiha, ijodiy ish).
/// 3 bosqichli tasdiq: oʻzi kiritgan → oʻqituvchi tasdiqlagan → maktab tasdiqlagan.
class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  Widget _statusPill(PortfolioStatus status) {
    switch (status) {
      case PortfolioStatus.self:
        return Pill('Oʻzim kiritdim', color: Colors.grey, icon: AppIcons.edit);
      case PortfolioStatus.teacher:
        return Pill('Oʻqituvchi tasdiqladi', color: SinfColors.blue, icon: AppIcons.verify);
      case PortfolioStatus.school:
        return Pill('Maktab tasdiqladi', color: Colors.green.shade700, icon: AppIcons.verify);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Portfolio'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SinfHero(
            title: currentUser.name,
            subtitle: '${portfolio.length} ta yutuq',
            icon: AppIcons.portfolio,
          ),
          const SizedBox(height: 6),
          ...List.generate(
            portfolio.length,
            (i) {
              final item = portfolio[i];
              return FadeInUp(
                index: i,
                child: SinfCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Pill(item.category, icon: AppIcons.book),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        style: metro(size: 16, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
                        style: metro(size: 12.5, color: SinfColors.muted),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 12),
                      _statusPill(item.status),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GradientButton(
              label: 'Yangi yutuq qoʻshish',
              icon: AppIcons.add,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yangi yutuq qoʻshildi — oʻqituvchi tasdigʻini kutmoqda')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
