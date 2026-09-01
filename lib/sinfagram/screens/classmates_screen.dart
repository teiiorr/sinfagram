import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';
import 'user_profile_screen.dart';

/// Sinfdoshlar — dumaloq avatarlar animatsiya bilan "chiqadi", bosilsa profilga.
class ClassmatesScreen extends StatelessWidget {
  const ClassmatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Sinfdoshlar'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Icon(AppIcons.people, color: SinfColors.primary, size: 20),
                const SizedBox(width: 8),
                Text('9-A sinf · ${classmates.length} oʻquvchi', style: metro(size: 13.5, weight: FontWeight.w600, color: SinfColors.muted)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              itemCount: classmates.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, i) {
                final m = classmates[i];
                return _PopIn(
                  index: i,
                  child: Pressable(
                    onTap: () => Navigator.push(context, sinfRoute(UserProfileScreen(mate: m))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Avatar(m.name, radius: 38, ring: true),
                        const SizedBox(height: 8),
                        Text(
                          m.name.split(' ').first,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: metro(size: 12.5, weight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Bosqichma-bosqich "pop" (scale + fade) — avatarlar chiroyli chiqadi.
class _PopIn extends StatelessWidget {
  final Widget child;
  final int index;
  const _PopIn({Key? key, required this.child, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + 55 * index),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: t.clamp(0.0, 1.05), child: child),
      ),
      child: child,
    );
  }
}
