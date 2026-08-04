import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/reference/reference_library.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';
  int selectedTab = 0;
  bool loading = true;
  List<Map<String, Object?>> rows = const [];
  Timer? _debounce;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: query);
    _runSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = _filters(rows);
    selectedTab = selectedTab.clamp(0, filters.length - 1);
    final selectedFilter = filters[selectedTab];
    final filteredRows = selectedFilter.type == 'all'
        ? rows
        : rows
              .where(
                (row) => _bucketFor('${row['type']}') == selectedFilter.type,
              )
              .toList();

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.phrasebook.greenHeaderStart,
                  theme.phrasebook.greenHeaderEnd,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLowest,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                        _setQuery('');
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                    hintText: 'Search English or Somali',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _setQuery,
                ),
              ),
            ),
          ),
          InlineTabBar(
            tabs: filters.map((filter) => filter.label).toList(),
            selectedIndex: selectedTab,
            onSelected: (index) => setState(() => selectedTab = index),
          ),
          if (loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: filteredRows.isEmpty
                ? const EmptyState(
                    message:
                        'Search words, phrases, dialogues, questions, responses, signs, idioms, and phrasal verbs.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 96),
                    itemCount: filteredRows.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        SearchResultTile(row: filteredRows[index]),
                  ),
          ),
        ],
      ),
    );
  }

  void _setQuery(String value) {
    setState(() {
      query = value;
      selectedTab = 0;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), _runSearch);
  }

  Future<void> _runSearch() async {
    setState(() => loading = true);
    final activeQuery = query;
    final databaseRows = await ref.read(repositoryProvider).search(activeQuery);
    final referenceRows = await ref
        .read(referenceLibraryProvider)
        .search(activeQuery);
    final nextRows = [...databaseRows, ...referenceRows];
    final normalized = normalizeReferenceText(activeQuery);
    if (normalized.isNotEmpty) {
      await ref.read(repositoryProvider).addSearchHistory(activeQuery);
    }
    if (!mounted || activeQuery != query) return;
    setState(() {
      rows = nextRows;
      loading = false;
    });
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.row});

  final Map<String, Object?> row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(_typeIcon('${row['type']}')),
      title: Text(
        '${row['title']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text(
        [
          '${row['subtitle']}',
          if ('${row['preview'] ?? ''}'.isNotEmpty) '${row['preview']}',
        ].join('\n'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _typeLabel('${row['type']}'),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
      onTap: () => openResult(context, row),
    );
  }
}

List<_SearchFilter> _filters(List<Map<String, Object?>> rows) {
  int count(String type) =>
      rows.where((row) => _bucketFor('${row['type']}') == type).length;
  return [
    _SearchFilter('All (${rows.length})', 'all'),
    _SearchFilter('Words (${count('words')})', 'words'),
    _SearchFilter('Phrases (${count('phrases')})', 'phrases'),
    _SearchFilter('Dialogues (${count('dialogues')})', 'dialogues'),
    _SearchFilter('Reference (${count('reference')})', 'reference'),
  ];
}

String _bucketFor(String type) {
  if (type == 'vocabulary') return 'words';
  if (type == 'phrase' || type == 'expression') return 'phrases';
  if (type.contains('dialogue')) return 'dialogues';
  return 'reference';
}

String _typeLabel(String type) => switch (type) {
  'vocabulary' => 'Word',
  'expression' => 'Phrase',
  'dialogue' => 'Dialogue',
  'dialogue_line' => 'Dialogue',
  'reference_expression' => 'Expression',
  'common_question' => 'Question',
  'everyday_response' => 'Response',
  'phrasal_verb' => 'Phrasal verb',
  'idiom' => 'Idiom',
  'phrase' => 'Phrase',
  'sign' => 'Sign',
  'category' => 'Category',
  _ => type,
};

class _SearchFilter {
  const _SearchFilter(this.label, this.type);

  final String label;
  final String type;
}

IconData _typeIcon(String type) {
  if (type.contains('dialogue')) return Icons.forum;
  if (type == 'vocabulary') return Icons.text_fields;
  if (type == 'common_question') return Icons.help_outline;
  if (type == 'everyday_response') return Icons.chat_bubble_outline;
  if (type == 'phrasal_verb') return Icons.account_tree_outlined;
  if (type == 'idiom') return Icons.psychology_outlined;
  if (type == 'sign') return Icons.signpost;
  if (type == 'category') return Icons.grid_view;
  return Icons.record_voice_over;
}
