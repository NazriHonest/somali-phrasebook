import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/phrasebook_app.dart';
import '../../core/database/phrasebook_repository.dart';
import '../../core/reference/reference_library.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import 'reference_feature.dart';

class ReferenceLibraryScreen extends ConsumerStatefulWidget {
  const ReferenceLibraryScreen({super.key});

  @override
  ConsumerState<ReferenceLibraryScreen> createState() =>
      _ReferenceLibraryScreenState();
}

class _ReferenceLibraryScreenState
    extends ConsumerState<ReferenceLibraryScreen> {
  int selectedTab = 0;
  late final Future<List<ReferenceEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = ref.read(referenceLibraryProvider).entries();
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _entriesFuture,
    builder: (context, entries) {
      final theme = Theme.of(context);
      final counts = <String, int>{};
      for (final entry in entries) {
        counts[entry.type] = (counts[entry.type] ?? 0) + 1;
      }
      final libraries = _libraries(counts);
      selectedTab = selectedTab.clamp(0, libraries.length - 1);
      final selected = libraries[selectedTab];
      final visibleEntries = entries
          .where((entry) => entry.type == selected.type)
          .toList(growable: false);
      return Scaffold(
        body: Column(
          children: [
            BlueHeader(
              title: 'Reference Library',
              subtitle:
                  'Offline English-Somali phrases, questions, responses, idioms, and phrasal verbs.',
              headerStart: theme.phrasebook.greenHeaderStart,
              headerEnd: theme.phrasebook.greenHeaderEnd,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              trailing: IconButton(
                onPressed: () => context.push('/search'),
                icon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
              ),
            ),
            InlineTabBar(
              tabs: libraries.map((item) => item.label).toList(),
              selectedIndex: selectedTab,
              onSelected: (index) => setState(() => selectedTab = index),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                itemCount: visibleEntries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = visibleEntries[index];
                  final tone =
                      theme.phrasebook.categoryTiles[index %
                          theme.phrasebook.categoryTiles.length];
                  return ListTile(
                    leading: IconBox(
                      icon: _referenceIcon(entry.type),
                      backgroundColor: tone.withValues(alpha: 0.12),
                      iconColor: tone,
                    ),
                    title: Text(
                      entry.english,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text(
                      ref.watch(showSomaliProvider)
                          ? entry.somali
                          : entry.contextLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      ReferenceFeature.detailPath(entry.type, entry.id),
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

class ReferenceDetailScreen extends ConsumerStatefulWidget {
  const ReferenceDetailScreen({
    super.key,
    required this.type,
    required this.id,
  });

  final String type;
  final String id;

  @override
  ConsumerState<ReferenceDetailScreen> createState() =>
      _ReferenceDetailScreenState();
}

class _ReferenceDetailScreenState extends ConsumerState<ReferenceDetailScreen> {
  late Future<List<Object?>> _future;
  final _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _load();
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.45);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _load() {
    _future = Future.wait<Object?>([
      ref.read(referenceLibraryProvider).entry(widget.type, widget.id),
      ref.read(repositoryProvider).isFavorite(widget.type, widget.id),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final entry = data[0] as ReferenceEntry?;
      if (entry == null) return const MissingScaffold();
      final favorite = data[1] as bool;
      ref
          .watch(repositoryProvider)
          .markRecent(entry.type, entry.id, entry.english, entry.somali);
      final theme = Theme.of(context);
      return Scaffold(
        body: Column(
          children: [
            BlueHeader(
              title: entry.english,
              subtitle: entry.contextLabel,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Hear English',
                    onPressed: () => _tts.speak(entry.english),
                    icon: Icon(
                      Icons.volume_up,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Favorite',
                    onPressed: () async {
                      await ref
                          .read(repositoryProvider)
                          .toggleFavorite(entry.type, entry.id);
                      setState(_load);
                    },
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  UiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ReferenceLine(label: 'English', text: entry.english),
                        if (ref.watch(showSomaliProvider)) ...[
                          Divider(color: theme.phrasebook.cardBorder),
                          _ReferenceLine(
                            label: 'Somali',
                            text: entry.somali,
                            emphasize: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionPill(
                        icon: Icons.copy,
                        label: 'Copy',
                        onTap: () =>
                            _copy(context, '${entry.english}\n${entry.somali}'),
                      ),
                      ActionPill(
                        icon: Icons.ios_share,
                        label: 'Share',
                        onTap: () => SharePlus.instance.share(
                          ShareParams(
                            text: '${entry.english}\n${entry.somali}',
                          ),
                        ),
                      ),
                      ActionPill(
                        icon: Icons.search,
                        label: 'Related',
                        onTap: () => _showRelated(context, entry),
                      ),
                    ],
                  ),
                  if (entry.explanation.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _InfoPanel(title: 'Use', text: entry.explanation),
                  ],
                  if (entry.exampleEnglish.isNotEmpty ||
                      entry.exampleSomali.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    UiCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Example',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (entry.exampleEnglish.isNotEmpty)
                            _ReferenceLine(
                              label: 'English',
                              text: entry.exampleEnglish,
                            ),
                          if (entry.exampleSomali.isNotEmpty)
                            _ReferenceLine(
                              label: 'Somali',
                              text: entry.exampleSomali,
                              emphasize: true,
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (entry.answerExampleEnglish.isNotEmpty ||
                      entry.answerExampleSomali.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _InfoPanel(
                      title: 'Natural answer',
                      text: [
                        entry.answerExampleEnglish,
                        entry.answerExampleSomali,
                      ].where((line) => line.isNotEmpty).join('\n'),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _MetadataPanel(entry: entry),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  Future<void> _showRelated(BuildContext context, ReferenceEntry entry) async {
    final related = await ref.read(referenceLibraryProvider).related(entry);
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListView.separated(
        shrinkWrap: true,
        itemCount: related.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = related[index];
          return ListTile(
            leading: Icon(_referenceIcon(item.type)),
            title: Text(item.english),
            subtitle: Text(item.somali),
            onTap: () {
              context.pop();
              context.push(ReferenceFeature.detailPath(item.type, item.id));
            },
          );
        },
      ),
    );
  }
}

class _ReferenceLine extends StatelessWidget {
  const _ReferenceLine({
    required this.label,
    required this.text,
    this.emphasize = false,
  });

  final String label;
  final String text;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 6),
          SelectableText(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: emphasize ? theme.phrasebook.success : null,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.phrasebook.infoSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(text),
        ],
      ),
    );
  }
}

class _MetadataPanel extends StatelessWidget {
  const _MetadataPanel({required this.entry});

  final ReferenceEntry entry;

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Type', entry.typeLabel),
      if (entry.cefr.isNotEmpty) MapEntry('Level', entry.cefr),
      if (entry.register.isNotEmpty) MapEntry('Register', entry.register),
      if (entry.phraseType.isNotEmpty)
        MapEntry('Phrase type', entry.phraseType),
      if (entry.categoryCode.isNotEmpty)
        MapEntry('Category', entry.categoryCode.replaceAll('_', ' ')),
      if (entry.subcategoryCode.isNotEmpty)
        MapEntry('Subcategory', entry.subcategoryCode.replaceAll('_', ' ')),
    ];
    return UiCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final row in rows)
            ListTile(
              dense: true,
              title: Text(row.key),
              trailing: Text(row.value),
            ),
        ],
      ),
    );
  }
}

Future<void> _copy(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Copied')));
}

IconData _referenceIcon(String type) => switch (type) {
  'common_question' => Icons.help_outline,
  'everyday_response' => Icons.chat_bubble_outline,
  'phrasal_verb' => Icons.account_tree_outlined,
  'idiom' => Icons.psychology_outlined,
  'phrase' => Icons.notes_outlined,
  _ => Icons.record_voice_over,
};

List<_ReferenceLibraryTab> _libraries(Map<String, int> counts) => [
  _ReferenceLibraryTab(
    'Expressions (${counts['reference_expression'] ?? 0})',
    'reference_expression',
  ),
  _ReferenceLibraryTab(
    'Questions (${counts['common_question'] ?? 0})',
    'common_question',
  ),
  _ReferenceLibraryTab(
    'Responses (${counts['everyday_response'] ?? 0})',
    'everyday_response',
  ),
  _ReferenceLibraryTab(
    'Phrasal verbs (${counts['phrasal_verb'] ?? 0})',
    'phrasal_verb',
  ),
  _ReferenceLibraryTab('Idioms (${counts['idiom'] ?? 0})', 'idiom'),
  _ReferenceLibraryTab('Phrases (${counts['phrase'] ?? 0})', 'phrase'),
];

class _ReferenceLibraryTab {
  const _ReferenceLibraryTab(this.label, this.type);

  final String label;
  final String type;
}

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
