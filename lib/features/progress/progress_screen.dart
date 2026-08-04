import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/reference/reference_library.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: Future.wait<Object?>([
      ref.watch(repositoryProvider).progressSummary(),
      ref.watch(repositoryProvider).counts(),
      ref.watch(referenceLibraryProvider).counts(),
    ]),
    builder: (context, data) {
      final progress = data[0] as Map<String, int>;
      final counts = data[1] as Map<String, int>;
      final referenceCounts = data[2] as Map<String, int>;
      final referenceTotal = referenceCounts.values.fold<int>(
        0,
        (total, count) => total + count,
      );
      final totalAnswers = progress['total'] ?? 0;
      final correct = progress['correct'] ?? 0;
      final accuracy = totalAnswers == 0 ? 0 : correct / totalAnswers;
      final theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left),
          ),
          title: const Text('Statistics'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            UiCard(
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 82,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: accuracy.clamp(0, 1).toDouble(),
                          strokeWidth: 8,
                          backgroundColor: theme.phrasebook.brandSoft,
                        ),
                        Center(
                          child: Text(
                            '${(accuracy * 100).round()}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice accuracy',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '$correct correct answers from $totalAnswers attempts',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _MetricCard(
                  icon: Icons.favorite,
                  label: 'Favorites',
                  value: '${progress['favorites']}',
                  tone: theme.phrasebook.categoryTiles[7],
                ),
                _MetricCard(
                  icon: Icons.history,
                  label: 'Recent',
                  value: '${progress['recent']}',
                  tone: theme.phrasebook.orange,
                ),
                _MetricCard(
                  icon: Icons.school,
                  label: 'Practice',
                  value: '${progress['sessions']}',
                  tone: theme.phrasebook.categoryTiles[4],
                ),
                _MetricCard(
                  icon: Icons.menu_book,
                  label: 'Offline reference',
                  value: '$referenceTotal',
                  tone: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Content Library',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            UiCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  StatTile(
                    label: 'Categories',
                    value: '${counts['categories']}',
                  ),
                  StatTile(
                    label: 'Subcategories',
                    value: '${counts['subcategories']}',
                  ),
                  StatTile(
                    label: 'Expressions',
                    value: '${counts['expressions']}',
                  ),
                  StatTile(label: 'Dialogues', value: '${counts['dialogues']}'),
                  StatTile(
                    label: 'Vocabulary',
                    value: '${counts['vocabulary_entries']}',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(
            icon: icon,
            backgroundColor: tone.withValues(alpha: 0.12),
            iconColor: tone,
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
