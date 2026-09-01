import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/class_feed.dart';
import 'screens/school_hub.dart';
import 'screens/create_post.dart';
import 'screens/plan_screen.dart';
import 'screens/profile_screen.dart';
import 'sinf_icons.dart';
import 'sinf_theme.dart';

/// Sinfagram asosiy navigatsiyasi — curved bottom nav (zamonaviy iconsax ikonlari).
class SinfNav extends StatefulWidget {
  static const String id = 'nav';
  const SinfNav({Key? key}) : super(key: key);

  @override
  State<SinfNav> createState() => _SinfNavState();
}

class _SinfNavState extends State<SinfNav> {
  int _index = 0;

  final List<Widget> _pages = const [
    ClassFeedScreen(),
    SchoolHubScreen(),
    CreatePostScreen(),
    PlanScreen(),
    ProfileScreen(),
  ];

  static const _linear = [AppIcons.home, AppIcons.hub, AppIcons.add, AppIcons.plan, AppIcons.profile];
  static const _bold = [AppIcons.homeFill, AppIcons.hubFill, AppIcons.addFill, AppIcons.planFill, AppIcons.profileFill];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: SinfColors.primary,
        color: Colors.grey.shade50,
        height: 62.0,
        animationDuration: const Duration(milliseconds: 360),
        animationCurve: Curves.easeOutCubic,
        index: _index,
        items: <Widget>[
          for (int i = 0; i < 5; i++)
            Icon(
              i == _index ? _bold[i] : _linear[i],
              color: i == _index ? Colors.white : Colors.black87,
              size: i == 2 ? 30 : 26,
            ),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
