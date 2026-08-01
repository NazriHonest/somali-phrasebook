import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../categories/categories_feature.dart';
import '../favorites/favorites_feature.dart';
import '../practice/practice_feature.dart';
import '../recent/recent_feature.dart';
import '../search/search_feature.dart';
import '../settings/settings_feature.dart';
import '../wordlists/wordlists_feature.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).categories(),
    builder: (context, categories) {
      final theme = Theme.of(context);
      final first = categories.isEmpty ? null : categories.first;
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.go(SettingsFeature.route),
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () => context.push(SearchFeature.route),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () => context.push(RecentFeature.route),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          children: [
            Text(
              'Hello!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Let’s learn useful English together.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            UiCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today’s Phrase',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Excuse me, where is the bus stop?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fadlan, joogsiga baska xaggee ku yaal?',
                          style: TextStyle(
                            color: theme.phrasebook.success,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.star_border, color: theme.phrasebook.favorite),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionHeader(
              title: 'Continue Learning',
              action: TextButton(
                onPressed: () => context.push(CategoriesFeature.route),
                child: const Text('View all'),
              ),
            ),
            if (first != null)
              ContinueCard(
                title: '${first['sort_order']}. ${first['english_title']}',
                subtitle: 'Grocery Shopping',
                progressLabel: '3/10 expressions',
                imageIcon: iconFor('${first['icon_key']}'),
                onTap: () => context.push(
                  CategoriesFeature.detailPath('${first['id']}'),
                ),
              ),
            const SizedBox(height: 18),
            SectionHeader(title: 'Quick Access'),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                QuickAccessCard(
                  icon: Icons.bookmark,
                  title: 'Wordlist',
                  subtitle: 'English → Somali',
                  toneIndex: 0,
                  onTap: () => context.push(WordlistsFeature.englishRoute),
                ),
                QuickAccessCard(
                  icon: Icons.g_translate,
                  title: 'Wordlist',
                  subtitle: 'Somali → English',
                  toneIndex: 1,
                  onTap: () => context.push(WordlistsFeature.somaliRoute),
                ),
                QuickAccessCard(
                  icon: Icons.quiz,
                  title: 'Practice',
                  subtitle: 'Take a quiz',
                  toneIndex: 3,
                  onTap: () => context.push(PracticeFeature.route),
                ),
                QuickAccessCard(
                  icon: Icons.history,
                  title: 'Recent',
                  subtitle: 'Last viewed',
                  toneIndex: 5,
                  onTap: () => context.push(RecentFeature.route),
                ),
                QuickAccessCard(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  subtitle: 'Saved items',
                  toneIndex: 9,
                  onTap: () => context.go(FavoritesFeature.route),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class ContinueCard extends StatelessWidget {
  const ContinueCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progressLabel,
    required this.imageIcon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String progressLabel;
  final IconData imageIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.3,
                          minHeight: 6,
                          backgroundColor: theme.phrasebook.infoSoft,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(progressLabel, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 76,
            height: 58,
            decoration: BoxDecoration(
              color: theme.phrasebook.successSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(imageIcon, color: theme.phrasebook.success, size: 34),
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
          Icon(icon, color: tone),
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
