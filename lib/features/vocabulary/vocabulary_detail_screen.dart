import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class VocabularyDetailScreen extends ConsumerStatefulWidget {
  const VocabularyDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<VocabularyDetailScreen> createState() =>
      _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState
    extends ConsumerState<VocabularyDetailScreen> {
  int selectedTab = 0;
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).vocabulary(widget.id),
      ref.read(repositoryProvider).isFavorite('vocabulary', widget.id),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final row = data[0] as Map<String, Object?>?;
      if (row == null) return const MissingScaffold();
      final favorite = data[1] as bool;
      ref
          .watch(repositoryProvider)
          .markRecent(
            'vocabulary',
            widget.id,
            '${row['english_headword']}',
            '${row['somali_headword']}',
          );
      final theme = Theme.of(context);
      final formFields = [
        'plural_form',
        'past_form',
        'past_participle',
        'comparative_form',
        'superlative_form',
      ].where((field) => '${row[field] ?? ''}'.trim().isNotEmpty).toList();
      final tabs = ['Details', 'Examples', if (formFields.isNotEmpty) 'Forms'];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
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
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${row['english_headword']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${row['part_of_speech']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(repositoryProvider)
                            .toggleFavorite('vocabulary', widget.id),
                        icon: Icon(
                          favorite ? Icons.star : Icons.star_border,
                          color: favorite
                              ? theme.phrasebook.favorite
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InlineTabBar(
              tabs: tabs,
              selectedIndex: selectedTab,
              onSelected: (index) => setState(() => selectedTab = index),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                children: switch (tabs[selectedTab]) {
                  'Examples' => [
                    DetailLine(
                      label: 'English',
                      value: '${row['english_sentence']}',
                      audio: true,
                    ),
                    DetailLine(
                      label: 'Somali',
                      value: '${row['somali_sentence']}',
                      success: true,
                      audio: true,
                    ),
                  ],
                  'Forms' => [
                    for (final field in formFields)
                      DetailLine(
                        label: field.replaceAll('_', ' '),
                        value: '${row[field]}',
                      ),
                  ],
                  _ => [
                    DetailLine(
                      label: 'Part of speech',
                      value: '${row['part_of_speech']}',
                    ),
                    DetailLine(
                      label: 'Somali',
                      value: '${row['somali_headword']}',
                      success: true,
                    ),
                    DetailLine(
                      label: 'Definition',
                      value: '${row['english_definition']}',
                    ),
                    DetailLine(
                      label: 'Sharaxaad',
                      value: '${row['somali_explanation']}',
                      success: true,
                    ),
                    DetailLine(
                      label: 'Frequency',
                      value: '${row['frequency']}',
                    ),
                    DetailLine(
                      label: 'Difficulty',
                      value: '${row['difficulty']}',
                    ),
                  ],
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class DetailLine extends StatelessWidget {
  const DetailLine({
    super.key,
    required this.label,
    required this.value,
    this.success = false,
    this.audio = false,
  });

  final String label;
  final String value;
  final bool success;
  final bool audio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.phrasebook.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 104,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: success ? theme.phrasebook.success : null,
                  fontWeight: success ? FontWeight.w800 : null,
                ),
              ),
            ),
            if (audio) ...[
              const SizedBox(width: 8),
              const Icon(Icons.volume_up, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
