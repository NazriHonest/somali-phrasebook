import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/widgets/shared_widgets.dart';

class RecentScreen extends ConsumerWidget {
  const RecentScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).recent(),
    builder: (context, rows) => Scaffold(
      appBar: AppBar(title: const Text('Recently viewed')),
      body: rows.isEmpty
          ? const EmptyState(message: 'Recently viewed content appears here.')
          : ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                title: Text('${rows[i]['title']}'),
                subtitle: Text('${rows[i]['subtitle']}'),
              ),
            ),
    ),
  );
}
