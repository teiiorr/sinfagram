import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/application/session_controller.dart';
import '../../features/auth/domain/session.dart';
import '../../features/board/presentation/board_screen.dart';
import '../../features/chronicle/presentation/chapter_screen.dart';
import '../../features/chronicle/presentation/chronicle_screen.dart';
import '../../features/class_extras/presentation/capsule_screen.dart';
import '../../features/class_extras/presentation/challenge_screen.dart';
import '../../features/class_extras/presentation/class_roles_screen.dart';
import '../../features/class_extras/presentation/shared_wall_screen.dart';
import '../../features/stories/presentation/story_viewer_screen.dart';
import '../../features/feed/presentation/compose_screen.dart';
import '../../features/feed/presentation/day_page_screen.dart';
import '../../features/feed/presentation/post_detail_screen.dart';
import '../../features/games/presentation/battle_lobby_screen.dart';
import '../../features/games/presentation/battle_play_screen.dart';
import '../../features/games/presentation/battle_result_screen.dart';
import '../../features/games/presentation/games_hub_screen.dart';
import '../../features/games/presentation/league_screen.dart';
import '../../features/games/presentation/quiz_screen.dart';
import '../../features/help/presentation/help_detail_screen.dart';
import '../../features/help/presentation/help_screen.dart';
import '../../features/munozara/presentation/munozara_screen.dart';
import '../../features/modes/presentation/lesson_screen.dart';
import '../../features/modes/presentation/night_screen.dart';
import '../../features/parent/presentation/parent_cases_screen.dart';
import '../../features/parent/presentation/parent_child_content_screen.dart';
import '../../features/parent/presentation/parent_digest_screen.dart';
import '../../features/parent/presentation/parent_me_screen.dart';
import '../../features/parent/presentation/parent_messages_screen.dart';
import '../../features/parent/presentation/parent_shell.dart';
import '../../features/onboarding/presentation/consent_wait_screen.dart';
import '../../features/onboarding/presentation/join_code_screen.dart';
import '../../features/onboarding/presentation/join_pin_screen.dart';
import '../../features/onboarding/presentation/join_roster_screen.dart';
import '../../features/onboarding/presentation/locale_screen.dart';
import '../../features/onboarding/presentation/role_screen.dart';
import '../../features/onboarding/presentation/visibility_screen.dart';
import '../../features/people/presentation/classmates_screen.dart';
import '../../features/people/presentation/person_profile_screen.dart';
import '../../features/profile/presentation/about_screen.dart';
import '../../features/profile/presentation/me_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/shell/pupil_shell.dart';
import '../../features/social/presentation/search_screen.dart';
import '../../features/social/presentation/activity_screen.dart';
import '../../features/teacher/presentation/teacher_announce_screen.dart';
import '../../features/teacher/presentation/teacher_case_detail_screen.dart';
import '../../features/teacher/presentation/teacher_cases_screen.dart';
import '../../features/teacher/presentation/teacher_chronicle_admin_screen.dart';
import '../../features/teacher/presentation/teacher_class_detail_screen.dart';
import '../../features/teacher/presentation/teacher_classes_screen.dart';
import '../../features/teacher/presentation/teacher_channel_screen.dart';
import '../../features/teacher/presentation/teacher_code_screen.dart';
import '../../features/teacher/presentation/teacher_games_screen.dart';
import '../../features/teacher/presentation/teacher_me_screen.dart';
import '../../features/teacher/presentation/teacher_roster_import_screen.dart';
import '../../features/teacher/presentation/teacher_schedule_screen.dart';
import '../../features/teacher/presentation/teacher_shell.dart';
import '../app/app_mode.dart';
import '../theme/motion.dart';

/// Routes that are part of the unauthenticated onboarding flow. Used by the
/// redirect to decide what a null / partial session may reach.
const _onboardingRoutes = {
  '/locale',
  '/role',
  '/join/code',
  '/join/roster',
  '/join/pin',
  '/join/consent-wait',
  '/join/visibility',
};

/// The app router (docs/07 §7.1). Built in a provider so the redirect can read
/// the session and refresh when it changes.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, __) => refresh.value++);
  ref.listen(appModeProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/locale',
    refreshListenable: refresh,
    redirect: (context, state) {
      final s = ref.read(sessionProvider);
      final loc = state.matchedLocation;

      if (s == null) {
        return _onboardingRoutes.contains(loc) ? null : '/role';
      }

      // Teachers get their own shell and skip the pupil consent/visibility/mode
      // gates entirely (those are pupil-facing).
      if (s.role == AppRole.teacher) {
        final allowed =
            loc.startsWith('/teacher') || loc == '/settings' || loc == '/about';
        return allowed ? null : '/teacher/classes';
      }
      if (s.role == AppRole.parent) {
        final allowed =
            loc.startsWith('/parent') || loc == '/settings' || loc == '/about';
        return allowed ? null : '/parent/child';
      }

      if (s.consent == ConsentState.pending) {
        return loc == '/join/consent-wait' ? null : '/join/consent-wait';
      }
      if (!s.seenVisibility) {
        return loc == '/join/visibility' ? null : '/join/visibility';
      }
      // Signed in pupil — do not sit on an onboarding, teacher or parent route.
      if (_onboardingRoutes.contains(loc) ||
          loc.startsWith('/teacher') ||
          loc.startsWith('/parent')) {
        return '/class';
      }

      // Night/lesson mode gate content, but never the board, settings or about.
      final mode = ref.read(appModeProvider);
      final modeAllowed = loc == '/board' ||
          loc == '/settings' ||
          loc == '/about' ||
          loc == '/night' ||
          loc == '/lesson';
      if (mode == AppMode.night && !modeAllowed) return '/night';
      if (mode == AppMode.lesson && !modeAllowed) return '/lesson';
      if (mode == AppMode.normal && (loc == '/night' || loc == '/lesson')) {
        return '/class';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/locale', pageBuilder: _fade(const LocaleScreen())),
      GoRoute(path: '/role', pageBuilder: _fade(const RoleScreen())),
      GoRoute(path: '/join/code', pageBuilder: _slide(const JoinCodeScreen())),
      GoRoute(
          path: '/join/roster', pageBuilder: _slide(const JoinRosterScreen())),
      GoRoute(path: '/join/pin', pageBuilder: _slide(const JoinPinScreen())),
      GoRoute(
          path: '/join/consent-wait',
          pageBuilder: _fade(const ConsentWaitScreen())),
      GoRoute(
          path: '/join/visibility',
          pageBuilder: _fade(const VisibilityScreen())),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            PupilShell(navigationShell: navigationShell),
        // Instagram-style pupil tabs: Lenta · Munozara · Oʻyinlar · Profil.
        // (The centre "create" is an action in PupilShell, not a branch.)
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/class', pageBuilder: _fade(const DayPageScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/munozara', pageBuilder: _fade(const MunozaraScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/games', pageBuilder: _fade(const GamesHubScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/me', pageBuilder: _fade(const MeScreen()))
          ]),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TeacherShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/teacher/classes',
                pageBuilder: _fade(const TeacherClassesScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/teacher/cases',
                pageBuilder: _fade(const TeacherCasesScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/teacher/games',
                pageBuilder: _fade(const TeacherGamesScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/teacher/me',
                pageBuilder: _fade(const TeacherMeScreen()))
          ]),
        ],
      ),
      GoRoute(
          path: '/teacher/case/:id',
          pageBuilder: (c, s) => _slidePage(
              TeacherCaseDetailScreen(caseId: s.pathParameters['id']!))),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ParentShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/parent/child',
                pageBuilder: _fade(const ParentDigestScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/parent/messages',
                pageBuilder: _fade(const ParentMessagesScreen()))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/parent/me', pageBuilder: _fade(const ParentMeScreen()))
          ]),
        ],
      ),
      GoRoute(
          path: '/parent/content',
          pageBuilder: _slide(const ParentChildContentScreen())),
      GoRoute(
          path: '/parent/cases',
          pageBuilder: _slide(const ParentCasesScreen())),
      GoRoute(path: '/compose', pageBuilder: _slide(const ComposeScreen())),
      GoRoute(
          path: '/stories/:index',
          pageBuilder: (c, s) => _fadePage(
              StoryViewerScreen(initialIndex: int.tryParse(s.pathParameters['index'] ?? '0') ?? 0))),
      GoRoute(
          path: '/post/:id',
          pageBuilder: (c, s) =>
              _slidePage(PostDetailScreen(postId: s.pathParameters['id']!))),
      GoRoute(path: '/help', pageBuilder: _slide(const HelpScreen())),
      GoRoute(
          path: '/help/:id',
          pageBuilder: (c, s) => _slidePage(
              HelpDetailScreen(questionId: s.pathParameters['id']!))),
      GoRoute(path: '/league', pageBuilder: _slide(const LeagueScreen())),
      GoRoute(path: '/quiz', pageBuilder: _slide(const QuizScreen())),
      GoRoute(
          path: '/battle/:id',
          pageBuilder: (c, s) =>
              _slidePage(BattleLobbyScreen(battleId: s.pathParameters['id']!))),
      GoRoute(
          path: '/battle/:id/play',
          pageBuilder: (c, s) =>
              _slidePage(BattlePlayScreen(battleId: s.pathParameters['id']!))),
      GoRoute(
          path: '/battle/:id/result',
          pageBuilder: (c, s) => _slidePage(
              BattleResultScreen(battleId: s.pathParameters['id']!))),
      GoRoute(
          path: '/chapter/:id',
          pageBuilder: (c, s) =>
              _slidePage(ChapterScreen(chapterId: s.pathParameters['id']!))),
      GoRoute(path: '/board', pageBuilder: _slide(const BoardScreen())),
      GoRoute(
          path: '/chronicle', pageBuilder: _slide(const ChronicleScreen())),
      GoRoute(
          path: '/classmates', pageBuilder: _slide(const ClassmatesScreen())),
      GoRoute(path: '/search', pageBuilder: _slide(const SearchScreen())),
      GoRoute(path: '/activity', pageBuilder: _slide(const ActivityScreen())),
      GoRoute(
          path: '/person/:id',
          pageBuilder: (c, s) => _slidePage(
              PersonProfileScreen(personId: s.pathParameters['id']!))),
      GoRoute(path: '/settings', pageBuilder: _slide(const SettingsScreen())),
      GoRoute(path: '/about', pageBuilder: _slide(const AboutScreen())),
      GoRoute(path: '/roles', pageBuilder: _slide(const ClassRolesScreen())),
      GoRoute(path: '/wall', pageBuilder: _slide(const SharedWallScreen())),
      GoRoute(path: '/challenge', pageBuilder: _slide(const ChallengeScreen())),
      GoRoute(path: '/capsule', pageBuilder: _slide(const CapsuleScreen())),
      GoRoute(
          path: '/teacher/class/:id',
          pageBuilder: (c, s) => _slidePage(
              TeacherClassDetailScreen(classId: s.pathParameters['id']!))),
      GoRoute(
          path: '/teacher/import',
          pageBuilder: _slide(const TeacherRosterImportScreen())),
      GoRoute(
          path: '/teacher/code',
          pageBuilder: _slide(const TeacherCodeScreen())),
      GoRoute(
          path: '/teacher/announce',
          pageBuilder: _slide(const TeacherAnnounceScreen())),
      GoRoute(
          path: '/teacher/schedule',
          pageBuilder: _slide(const TeacherScheduleScreen())),
      GoRoute(
          path: '/teacher/channel',
          pageBuilder: _slide(const TeacherChannelScreen())),
      GoRoute(
          path: '/teacher/chronicle-admin',
          pageBuilder: _slide(const TeacherChronicleAdminScreen())),
      GoRoute(path: '/night', pageBuilder: _fade(const NightScreen())),
      GoRoute(path: '/lesson', pageBuilder: _fade(const LessonScreen())),
    ],
  );
});

// One transition for both platforms (docs/06 §6.3): fade + 4 % x-slide, 240 ms.
GoRouterPageBuilder _slide(Widget child) =>
    (context, state) => _slidePage(child, key: state.pageKey);
GoRouterPageBuilder _fade(Widget child) =>
    (context, state) => _fadePage(child, key: state.pageKey);

CustomTransitionPage<void> _slidePage(Widget child, {LocalKey? key}) =>
    CustomTransitionPage<void>(
      key: key,
      transitionDuration: Motion.page,
      reverseTransitionDuration: Motion.page,
      child: child,
      transitionsBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(
            parent: animation, curve: Motion.enter, reverseCurve: Motion.exit);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.04, 0), end: Offset.zero)
                .animate(curved),
            child: child,
          ),
        );
      },
    );

CustomTransitionPage<void> _fadePage(Widget child, {LocalKey? key}) =>
    CustomTransitionPage<void>(
      key: key,
      transitionDuration: Motion.fast,
      reverseTransitionDuration: Motion.fast,
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );
