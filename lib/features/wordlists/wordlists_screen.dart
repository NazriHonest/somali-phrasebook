import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../search/search_feature.dart';
import '../vocabulary/vocabulary_feature.dart';

class EnglishWordlistScreen extends StatelessWidget {
  const EnglishWordlistScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const WordlistScreen(initialEnglish: true);
}

class SomaliWordlistScreen extends StatelessWidget {
  const SomaliWordlistScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const WordlistScreen(initialEnglish: false);
}

class WordlistScreen extends ConsumerStatefulWidget {
  const WordlistScreen({super.key, required this.initialEnglish});
  final bool initialEnglish;

  @override
  ConsumerState<WordlistScreen> createState() => _WordlistScreenState();
}

class _WordlistScreenState extends ConsumerState<WordlistScreen> {
  late bool englishFirst = widget.initialEnglish;
  String query = '';
  String selectedLetter = '';
  late final Future<List<List<Map<String, Object?>>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      ref.read(repositoryProvider).englishWordlist(),
      ref.read(repositoryProvider).somaliWordlist(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureView(
      future: _future,
      builder: (context, data) {
        final sourceRows = englishFirst ? data[0] : data[1];
        final normalizedQuery = query.trim().toLowerCase();
        final queryRows = normalizedQuery.isEmpty
            ? sourceRows
            : sourceRows.where((row) {
                return '${row['english_headword']} ${row['somali_headword']}'
                    .toLowerCase()
                    .contains(normalizedQuery);
              }).toList();
        final filteredRows = selectedLetter.isEmpty
            ? queryRows
            : queryRows.where((row) {
                final value = englishFirst
                    ? '${row['english_headword']}'
                    : '${row['somali_headword']}';
                return value.toUpperCase().startsWith(selectedLetter);
              }).toList();
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.phrasebook.headerStart,
                      theme.phrasebook.headerEnd,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Wordlist',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.push(SearchFeature.route),
                              icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerLowest,
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search English or Somali',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) => setState(() => query = value),
                        ),
                        const SizedBox(height: 8),
                        InlineTabBar(
                          tabs: const [
                            'English to Somali',
                            'Somali to English',
                          ],
                          selectedIndex: englishFirst ? 0 : 1,
                          onSelected: (index) => setState(() {
                            englishFirst = index == 0;
                            selectedLetter = '';
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Text(
                  'Browse by Letter',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _letters.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final letter = index == 0 ? '' : _letters[index - 1];
                    final selected = selectedLetter == letter;
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => selectedLetter = letter),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerLowest,
                        child: Text(
                          letter.isEmpty ? 'All' : letter,
                          style: TextStyle(
                            color: selected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
                  itemCount: filteredRows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 0),
                  itemBuilder: (context, index) => WordCard(
                    row: filteredRows[index],
                    englishFirst: englishFirst,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WordCard extends ConsumerWidget {
  const WordCard({super.key, required this.row, required this.englishFirst});

  final Map<String, Object?> row;
  final bool englishFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final id = '${row['id'] ?? row['vocabulary_entry_id']}';
    final title = englishFirst
        ? '${row['english_headword']}'
        : '${row['somali_headword']}';
    final subtitle = englishFirst
        ? '${row['somali_headword']}'
        : '${row['english_headword']}';
    return FutureBuilder<bool>(
      future: ref.watch(repositoryProvider).isFavorite('vocabulary', id),
      builder: (context, snapshot) {
        final favorite = snapshot.data ?? false;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            border: Border(
              bottom: BorderSide(color: theme.phrasebook.cardBorder),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            title: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: theme.phrasebook.success),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${row['part_of_speech']}',
                  style: theme.textTheme.bodySmall,
                ),
                IconButton(
                  onPressed: () => ref
                      .read(repositoryProvider)
                      .toggleFavorite('vocabulary', id),
                  icon: Icon(
                    favorite ? Icons.star : Icons.star_border,
                    color: favorite
                        ? theme.phrasebook.favorite
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            onTap: () => context.push(VocabularyFeature.detailPath(id)),
          ),
        );
      },
    );
  }
}

const _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
