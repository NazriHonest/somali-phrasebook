import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../categories/categories_feature.dart';
import '../progress/progress_feature.dart';
import '../recent/recent_feature.dart';
import '../reference/reference_feature.dart';
import '../search/search_feature.dart';
import '../wordlists/wordlists_feature.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: Future.wait<Object?>([
      ref.watch(repositoryProvider).categories(),
      ref.watch(repositoryProvider).progressSummary(),
    ]),
    builder: (context, data) {
      final categories = data[0] as List<Map<String, Object?>>;
      final progress = data[1] as Map<String, int>;
      final theme = Theme.of(context);
      return Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 28,
            16,
            96,
          ),
          children: [
            Row(
              children: [
                const AppMark(size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Find the right words for every situation.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SearchBox(onTap: () => context.push(SearchFeature.route)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Browse by Category',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(CategoriesFeature.route),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.take(9).length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final row = categories[index];
                final tone =
                    theme.phrasebook.categoryTiles[index %
                        theme.phrasebook.categoryTiles.length];
                return DashboardCategoryTile(
                  title: _homeCategoryTitle('${row['english_title']}'),
                  icon: iconFor('${row['icon_key']}'),
                  tone: tone,
                  onTap: () => context.push(
                    CategoriesFeature.detailPath('${row['id']}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Quick Access',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.35,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                QuickAccessCard(
                  icon: Icons.bookmark,
                  title: 'Wordlist',
                  subtitle: 'English to Somali',
                  toneIndex: 3,
                  onTap: () => context.push(WordlistsFeature.englishRoute),
                ),
                QuickAccessCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Reference',
                  subtitle: 'Phrases and idioms',
                  toneIndex: 0,
                  onTap: () => context.push(ReferenceFeature.route),
                ),
                QuickAccessCard(
                  icon: Icons.history,
                  title: 'Recent',
                  subtitle: '${progress['recent']} viewed',
                  toneIndex: 2,
                  onTap: () => context.push(RecentFeature.route),
                ),
                QuickAccessCard(
                  icon: Icons.bar_chart,
                  title: 'Statistics',
                  subtitle: 'Progress summary',
                  toneIndex: 5,
                  onTap: () => context.push(ProgressFeature.route),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class DashboardCategoryTile extends StatelessWidget {
  const DashboardCategoryTile({
    super.key,
    required this.title,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBox(
            icon: icon,
            backgroundColor: tone.withValues(alpha: 0.12),
            iconColor: tone,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.toneIndex,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int toneIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tone =
        theme.phrasebook.categoryTiles[toneIndex.clamp(
          0,
          theme.phrasebook.categoryTiles.length - 1,
        )];
    return UiCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          IconBox(
            icon: icon,
            backgroundColor: tone.withValues(alpha: 0.12),
            iconColor: tone,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _homeCategoryTitle(String title) => title
    .replaceFirst('Coping with the Language Barrier', 'Travel')
    .replaceFirst('Useful Forms of Etiquette', 'Health')
    .replaceFirst('Giving Information About Yourself', 'People')
    .replaceFirst('Recognizing Signs', 'Services')
    .replaceFirst('Weights and Measures', 'Shopping')
    .replaceFirst('Using Numbers', 'Money')
    .replaceFirst('Dealing with Time', 'Time')
    .replaceFirst('About Schools', 'Education');
