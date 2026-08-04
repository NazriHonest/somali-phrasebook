import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/reference/reference_library.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../reference/reference_feature.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  int selectedTab = 0;
  late final Future<List<Map<String, Object?>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _favoriteRows();
  }

  Future<List<Map<String, Object?>>> _favoriteRows() async {
    final rows = await ref.read(repositoryProvider).favoriteItems();
    final library = ref.read(referenceLibraryProvider);
    final resolved = <Map<String, Object?>>[];
    for (final row in rows) {
      final type = '${row['item_type']}';
      if (!ReferenceFeature.isReferenceType(type)) {
        resolved.add(row);
        continue;
      }
      final entry = await library.entry(type, '${row['item_id']}');
      resolved.add({
        ...row,
        'title': entry?.english ?? row['title'],
        'subtitle': entry?.somali ?? row['subtitle'],
      });
    }
    return resolved;
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, rows) {
      final theme = Theme.of(context);
      final types = rows.map((row) => '${row['item_type']}').toSet().toList();
      final tabs = ['All', ...types.map(_typeLabel)];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
      final filteredRows = selectedTab == 0
          ? rows
          : rows
                .where(
                  (row) =>
                      _typeLabel('${row['item_type']}') == tabs[selectedTab],
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Center(
                    child: Text(
                      'Favorites',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: InlineTabBar(
                tabs: tabs,
                selectedIndex: selectedTab,
                onSelected: (index) => setState(() => selectedTab = index),
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const EmptyState(message: 'Saved items appear here.')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      itemCount: filteredRows.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final row = filteredRows[index];
                        final type = '${row['item_type']}';
                        final tone =
                            theme.phrasebook.categoryTiles[index %
                                theme.phrasebook.categoryTiles.length];
                        return UiCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: IconBox(
                              icon: _favoriteIcon(type),
                              backgroundColor: tone.withValues(alpha: 0.12),
                              iconColor: tone,
                            ),
                            title: Text(
                              '${row['title']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            subtitle: Text(
                              '${row['subtitle']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => openResult(context, {
                              'type': type,
                              'id': row['item_id'],
                            }),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}

IconData _favoriteIcon(String type) {
  if (type == 'dialogue') return Icons.forum;
  if (type == 'vocabulary') return Icons.text_fields;
  if (type == 'sign') return Icons.signpost;
  if (type == 'category') return Icons.grid_view;
  if (type == 'common_question') return Icons.help_outline;
  if (type == 'everyday_response') return Icons.chat_bubble_outline;
  if (type == 'phrasal_verb') return Icons.account_tree_outlined;
  if (type == 'idiom') return Icons.psychology_outlined;
  if (type == 'phrase') return Icons.notes_outlined;
  return Icons.record_voice_over;
}

String _typeLabel(String type) => switch (type) {
  'expression' => 'Expressions',
  'dialogue' => 'Dialogs',
  'vocabulary' => 'Words',
  'category' => 'Categories',
  'sign' => 'Signs',
  'reference_expression' => 'Expressions',
  'common_question' => 'Questions',
  'everyday_response' => 'Responses',
  'phrasal_verb' => 'Phrasal verbs',
  'idiom' => 'Idioms',
  'phrase' => 'Phrases',
  _ => type,
};
