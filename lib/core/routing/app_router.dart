import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/categories_feature.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/dialogues/dialogue_detail_screen.dart';
import '../../features/dialogues/dialogues_feature.dart';
import '../../features/expressions/expression_detail_screen.dart';
import '../../features/expressions/expressions_feature.dart';
import '../../features/favorites/favorites_feature.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_feature.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_feature.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/practice/practice_feature.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/progress/progress_feature.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/recent/recent_feature.dart';
import '../../features/recent/recent_screen.dart';
import '../../features/reference/reference_feature.dart';
import '../../features/reference/reference_screens.dart';
import '../../features/search/search_feature.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_feature.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/vocabulary/vocabulary_detail_screen.dart';
import '../../features/vocabulary/vocabulary_feature.dart';
import '../../features/wordlists/wordlists_feature.dart';
import '../../features/wordlists/wordlists_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: OnboardingFeature.splashRoute,
    routes: [
      GoRoute(
        path: OnboardingFeature.splashRoute,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingFeature.onboardingRoute,
        builder: (_, _) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeFeature.route,
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CategoriesFeature.route,
                builder: (_, _) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PracticeFeature.route,
                builder: (_, _) => const PracticeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: FavoritesFeature.route,
                builder: (_, _) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsFeature.route,
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: SearchFeature.route,
        builder: (_, _) => const SearchScreen(),
      ),
      GoRoute(
        path: CategoriesFeature.detailRoute,
        builder: (_, state) =>
            CategoryDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: CategoriesFeature.subcategoryRoute,
        builder: (_, state) => SubcategoryContentScreen(
          categoryId: state.pathParameters['categoryId']!,
          subcategoryId: state.pathParameters['subcategoryId']!,
        ),
      ),
      GoRoute(
        path: ExpressionsFeature.listRoute,
        builder: (_, state) => CategoryExpressionsScreen(
          categoryId: state.pathParameters['categoryId']!,
          subcategoryId: state.pathParameters['subcategoryId'] == 'all'
              ? ''
              : state.pathParameters['subcategoryId']!,
        ),
      ),
      GoRoute(
        path: DialoguesFeature.listRoute,
        builder: (_, state) => CategoryDialogueListScreen(
          categoryId: state.pathParameters['categoryId']!,
        ),
      ),
      GoRoute(
        path: ExpressionsFeature.detailRoute,
        builder: (_, state) =>
            ExpressionDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: DialoguesFeature.detailRoute,
        builder: (_, state) =>
            DialogueDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: PracticeFeature.modeRoute,
        builder: (_, state) =>
            PracticeModeScreen(mode: state.pathParameters['mode']!),
      ),
      GoRoute(
        path: WordlistsFeature.englishRoute,
        builder: (_, _) => const EnglishWordlistScreen(),
      ),
      GoRoute(
        path: WordlistsFeature.somaliRoute,
        builder: (_, _) => const SomaliWordlistScreen(),
      ),
      GoRoute(
        path: RecentFeature.route,
        builder: (_, _) => const RecentScreen(),
      ),
      GoRoute(
        path: VocabularyFeature.detailRoute,
        builder: (_, state) =>
            VocabularyDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ProgressFeature.route,
        builder: (_, _) => const ProgressScreen(),
      ),
      GoRoute(
        path: ReferenceFeature.route,
        builder: (_, _) => const ReferenceLibraryScreen(),
      ),
      GoRoute(
        path: ReferenceFeature.detailRoute,
        builder: (_, state) => ReferenceDetailScreen(
          type: state.pathParameters['type']!,
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: ReferenceFeature.signsRoute,
        builder: (_, _) => const SignsScreen(),
      ),
      GoRoute(
        path: ReferenceFeature.measuresRoute,
        builder: (_, _) => const MeasuresScreen(),
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) => shell.goBranch(index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Practice',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          selectedIcon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    ),
  );
}
