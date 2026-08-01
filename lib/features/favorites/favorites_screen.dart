import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

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
    _future = ref.read(repositoryProvider).favoriteItems();
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
                    theme.phrasebook.pinkHeaderStart,
                    theme.phrasebook.pinkHeaderEnd,
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
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final row = filteredRows[index];
                        final type = '${row['item_type']}';
                        return ListTile(
                          leading: Icon(
                            _favoriteIcon(type),
                            color:
                                theme.phrasebook.categoryTiles[index %
                                    theme.phrasebook.categoryTiles.length],
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
  return Icons.record_voice_over;
}

String _typeLabel(String type) => switch (type) {
  'expression' => 'Expressions',
  'dialogue' => 'Dialogs',
  'vocabulary' => 'Words',
  'category' => 'Categories',
  'sign' => 'Signs',
  _ => type,
};
