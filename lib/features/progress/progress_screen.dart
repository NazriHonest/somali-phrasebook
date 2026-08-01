import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/widgets/shared_widgets.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).progressSummary(),
    builder: (context, row) => Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: pagePadding,
        children: [
          StatTile(label: 'Favorites', value: '${row['favorites']}'),
          StatTile(label: 'Recently viewed', value: '${row['recent']}'),
          StatTile(label: 'Practice sessions', value: '${row['sessions']}'),
          StatTile(
            label: 'Correct answers',
            value: '${row['correct']} / ${row['total']}',
          ),
          const Text(
            'Study streak is kept light and based on recent local activity.',
          ),
        ],
      ),
    ),
  );
}
