import 'package:flutter/material.dart';
import '../sinf_theme.dart';

/// Instagram-uslubidagi profil shapkasi: avatar + statistika + ism + bio.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String subtitle; // sinf · maktab
  final String bio;
  final int posts;
  final int followers;
  final int following;
  const ProfileHeader({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(name, radius: 40, ring: true),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(posts, 'Postlar'),
                    _stat(followers, 'Obunachilar'),
                    _stat(following, 'Obunalar'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(name, style: metro(size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(subtitle, style: metro(size: 12.5, color: SinfColors.muted)),
          if (bio.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(bio, style: metro(size: 13)),
          ],
        ],
      ),
    );
  }

  Widget _stat(int value, String label) {
    return Column(
      children: [
        Text('$value', style: metro(size: 19, weight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: metro(size: 11.5, color: SinfColors.muted)),
      ],
    );
  }
}

/// Foto to'ri (3 ustun), animatsiyali paydo bo'lish bilan.
class PhotoGrid extends StatelessWidget {
  final List<String> photos;
  final String ownerName;
  const PhotoGrid({Key? key, required this.photos, required this.ownerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, i) {
        return FadeInUp(
          index: i % 6,
          offset: 16,
          child: Pressable(
            onTap: () => _openPhoto(context, ownerName, photos[i]),
            child: PostMedia(ownerName, photos[i], radius: 14),
          ),
        );
      },
    );
  }
}

/// Foto plitkasini bosganda kattaroq koʻrsatish (silliq zoom animatsiya bilan).
void _openPhoto(BuildContext context, String ownerName, String seed) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'photo',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, __, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Center(
          child: Transform.scale(
            scale: 0.7 + 0.3 * curved.value.clamp(0.0, 1.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: PostMedia(ownerName, seed, height: 320, radius: 28),
              ),
            ),
          ),
        ),
      );
    },
  );
}
