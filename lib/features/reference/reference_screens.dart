import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/widgets/shared_widgets.dart';

class SignsScreen extends ConsumerWidget {
  const SignsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).signs(),
    builder: (context, rows) => Scaffold(
      appBar: AppBar(title: const Text('Signs')),
      body: ListView.separated(
        itemCount: rows.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) => ListTile(
          leading: IconBox(icon: iconFor('${rows[i]['icon_key']}')),
          title: Text('${rows[i]['english_text']}'),
          subtitle: Text(
            '${rows[i]['somali_meaning']}\n${rows[i]['somali_explanation']}',
          ),
          isThreeLine: true,
        ),
      ),
    ),
  );
}

class MeasuresScreen extends ConsumerWidget {
  const MeasuresScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).units(),
    builder: (context, rows) => Scaffold(
      appBar: AppBar(title: const Text('Weights and Measures')),
      body: ListView.separated(
        itemCount: rows.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) => ListTile(
          title: Text('${rows[i]['english_name']} / ${rows[i]['somali_name']}'),
          subtitle: Text('${rows[i]['unit_type']} • ${rows[i]['explanation']}'),
        ),
      ),
    ),
  );
}
