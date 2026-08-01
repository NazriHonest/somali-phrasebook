import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: query);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: ref.watch(repositoryProvider).search(query),
    builder: (context, rows) {
      final theme = Theme.of(context);
      final expressions = rows
          .where((row) => row['type'] == 'expression')
          .toList();
      final dialogues = rows
          .where((row) => '${row['type']}'.contains('dialogue'))
          .toList();
      final words = rows.where((row) => row['type'] == 'vocabulary').toList();
      return Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.phrasebook.greenHeaderStart,
                    theme.phrasebook.headerEnd,
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
                        onPressed: () => setState(() {
                          query = '';
                          controller.clear();
                        }),
                        icon: const Icon(Icons.cancel),
                      ),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => query = value),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  PillLabel(label: 'All (${rows.length})', selected: true),
                  const SizedBox(width: 8),
                  PillLabel(label: 'Expressions (${expressions.length})'),
                  const SizedBox(width: 8),
                  PillLabel(label: 'Dialog (${dialogues.length})'),
                  const SizedBox(width: 8),
                  PillLabel(label: 'Words (${words.length})'),
                ],
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const EmptyState(
                      message:
                          'Search phrases, dialogue lines, signs, and words.',
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 96),
                      children: [
                        SearchSection(
                          title: 'Expressions',
                          rows: expressions.take(3).toList(),
                        ),
                        SearchSection(
                          title: 'Dialogs',
                          rows: dialogues.take(3).toList(),
                        ),
                        SearchSection(
                          title: 'Words',
                          rows: words.take(4).toList(),
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

class SearchSection extends StatelessWidget {
  const SearchSection({super.key, required this.title, required this.rows});
  final String title;
  final List<Map<String, Object?>> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (rows.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                'See all',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          UiCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final row in rows)
                  ListTile(
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
                      '${row['subtitle']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.volume_up),
                    onTap: () => openResult(context, row),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _typeIcon(String type) {
  if (type.contains('dialogue')) return Icons.forum;
  if (type == 'vocabulary') return Icons.text_fields;
  return Icons.record_voice_over;
}
