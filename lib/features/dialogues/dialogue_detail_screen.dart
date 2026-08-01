import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class DialogueDetailScreen extends ConsumerStatefulWidget {
  const DialogueDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<DialogueDetailScreen> createState() =>
      _DialogueDetailScreenState();
}

class _DialogueDetailScreenState extends ConsumerState<DialogueDetailScreen> {
  int selectedTab = 0;
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).dialogue(widget.id),
      ref.read(repositoryProvider).dialogueLines(widget.id),
      ref.read(repositoryProvider).isFavorite('dialogue', widget.id),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final dialogue = data[0] as Map<String, Object?>?;
      if (dialogue == null) return const MissingScaffold();
      final lines = data[1] as List<Map<String, Object?>>;
      final favorite = data[2] as bool;
      ref
          .watch(repositoryProvider)
          .markRecent(
            'dialogue',
            widget.id,
            '${dialogue['english_title']}',
            '${dialogue['somali_title']}',
          );
      final theme = Theme.of(context);
      final dialogueWords = _dialogueWords(lines);
      final tabs = ['Dialogue', if (dialogueWords.isNotEmpty) 'Vocabulary'];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
      return Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.phrasebook.headerStart,
                    theme.phrasebook.headerEnd,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
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
                              '${dialogue['english_title']}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${dialogue['somali_title']}',
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
                            .toggleFavorite('dialogue', widget.id),
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
            Transform.translate(
              offset: const Offset(0, -8),
              child: InlineTabBar(
                tabs: tabs,
                selectedIndex: selectedTab,
                onSelected: (index) => setState(() => selectedTab = index),
              ),
            ),
            Expanded(
              child: selectedTab == 0
                  ? ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      itemCount: lines.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: BilingualBlock(
                              english: '${dialogue['english_situation']}',
                              somali: '${dialogue['somali_situation']}',
                            ),
                          );
                        }
                        final line = lines[index - 1];
                        return ChatLineTile(
                          line: line,
                          alignRight: index.isEven,
                        );
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      itemCount: dialogueWords.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.text_fields),
                        title: Text(dialogueWords[index]),
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

List<String> _dialogueWords(List<Map<String, Object?>> lines) {
  final words = <String>{};
  for (final line in lines) {
    final text = '${line['english_text']}'.toLowerCase();
    for (final word in text.split(RegExp(r'[^a-z]+'))) {
      if (word.length > 4) words.add(word);
    }
  }
  return words.take(14).toList();
}

class ChatLineTile extends StatelessWidget {
  const ChatLineTile({super.key, required this.line, required this.alignRight});
  final Map<String, Object?> line;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = alignRight
        ? theme.phrasebook.successSoft
        : theme.phrasebook.infoSoft;
    final avatar = CircleAvatar(
      radius: 13,
      backgroundColor: alignRight
          ? theme.phrasebook.success
          : theme.colorScheme.primary,
      child: Icon(Icons.person, size: 16, color: theme.colorScheme.onPrimary),
    );
    final bubble = Flexible(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${line['speaker']}:',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text('${line['english_text']}'),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '${line['somali_text']}',
                    style: TextStyle(color: theme.phrasebook.success),
                  ),
                ),
                const Icon(Icons.volume_up, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
    return Row(
      mainAxisAlignment: alignRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: alignRight
          ? [bubble, const SizedBox(width: 8), avatar]
          : [avatar, const SizedBox(width: 8), bubble],
    );
  }
}
