import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Faoliyat — jonli bildirishnomalar (yoqtirishlar, izohlar, obunalar, maqtovlar).
class SinfActivityScreen extends StatelessWidget {
  const SinfActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = context.watch<AppState>().notifications;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Faoliyat'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int i = 0; i < items.length; i++)
            FadeInUp(
              index: i < 8 ? i : 0,
              child: ListTile(
                leading: Avatar(items[i]['who']!, radius: 24),
                title: Text.rich(
                  TextSpan(
                    style: metro(size: 13.5),
                    children: [
                      TextSpan(text: items[i]['who']!, style: metro(size: 13.5, weight: FontWeight.w700)),
                      TextSpan(text: items[i]['who'] == 'Siz' ? ' ${items[i]['action']!}' : ' ${items[i]['action']!}'),
                    ],
                  ),
                ),
                subtitle: Text(items[i]['time']!, style: metro(size: 11.5, color: SinfColors.muted)),
                trailing: Icon(AppIcons.heartFill, color: Colors.red.shade300, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}
