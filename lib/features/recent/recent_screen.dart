import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class RecentScreen extends ConsumerWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).recent(),
    builder: (context, rows) {
      final theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left),
          ),
          title: Column(
            children: [
              const Text('Recent'),
              Text('${rows.length} items', style: theme.textTheme.bodySmall),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => ref.read(repositoryProvider).clearRecent(),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        body: rows.isEmpty
            ? const EmptyState(message: 'Recently viewed content appears here.')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: rows.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final tone = theme
                      .phrasebook
                      .categoryTiles[i % theme.phrasebook.categoryTiles.length];
                  return UiCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: IconBox(
                        icon: _recentIcon('${rows[i]['item_type']}'),
                        backgroundColor: tone.withValues(alpha: 0.12),
                        iconColor: tone,
                      ),
                      title: Text(
                        '${rows[i]['title']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      subtitle: Text(
                        '${rows[i]['subtitle']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => openResult(context, {
                        'type': rows[i]['item_type'],
                        'id': rows[i]['item_id'],
                      }),
                    ),
                  );
                },
              ),
      );
    },
  );
}

IconData _recentIcon(String type) {
  if (type == 'dialogue') return Icons.forum;
  if (type == 'vocabulary') return Icons.text_fields;
  if (type == 'category') return Icons.grid_view;
  if (type == 'sign') return Icons.signpost;
  if (type == 'common_question') return Icons.help_outline;
  if (type == 'everyday_response') return Icons.chat_bubble_outline;
  if (type == 'phrasal_verb') return Icons.account_tree_outlined;
  if (type == 'idiom') return Icons.psychology_outlined;
  if (type == 'phrase') return Icons.notes_outlined;
  return Icons.record_voice_over;
}
