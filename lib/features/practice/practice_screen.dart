import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import 'practice_feature.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  int selectedMode = 0;
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).progressSummary(),
      ref.read(repositoryProvider).counts(),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final progress = data[0] as Map<String, int>;
      final counts = data[1] as Map<String, int>;
      final theme = Theme.of(context);
      final questionCount = counts['vocabulary_entries'] ?? 0;
      return Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.phrasebook.headerStart,
                    theme.phrasebook.headerEnd,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Practice',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: theme.phrasebook.favorite,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${progress['sessions']}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text(
                    'Choose mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${progress['correct']} / ${progress['total']} correct',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                crossAxisCount: 2,
                childAspectRatio: 1.45,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  for (var i = 0; i < _modes.length; i++)
                    PracticeModeCard(
                      mode: _modes[i],
                      questionCount: questionCount,
                      selected: selectedMode == i,
                      onTap: () => context.push(
                        PracticeFeature.modePath(_modes[i].code),
                      ),
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

class PracticeModeCard extends StatelessWidget {
  const PracticeModeCard({
    super.key,
    required this.mode,
    required this.questionCount,
    required this.selected,
    required this.onTap,
  });

  final PracticeMode mode;
  final int questionCount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tone =
        theme.phrasebook.categoryTiles[mode.toneIndex.clamp(
          0,
          theme.phrasebook.categoryTiles.length - 1,
        )];
    return UiCard(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? tone
                : theme.colorScheme.surface.withValues(alpha: 0),
            width: selected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Icon(mode.icon, color: tone, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${mode.subtitle}\n$questionCount available words',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeMode {
  const PracticeMode(
    this.code,
    this.icon,
    this.title,
    this.subtitle,
    this.toneIndex,
  );
  final String code;
  final IconData icon;
  final String title;
  final String subtitle;
  final int toneIndex;
}

const _modes = [
  PracticeMode(
    'en-so',
    Icons.translate,
    'English to Somali',
    'Multiple choice',
    0,
  ),
  PracticeMode(
    'so-en',
    Icons.g_translate,
    'Somali to English',
    'Multiple choice',
    3,
  ),
  PracticeMode(
    'complete-phrase',
    Icons.format_quote,
    'Complete Phrase',
    'Expression recall',
    0,
  ),
  PracticeMode(
    'match-columns',
    Icons.compare_arrows,
    'Match Columns',
    'Word matching',
    1,
  ),
  PracticeMode(
    'correct-response',
    Icons.assignment_turned_in,
    'Correct Response',
    'Q & A practice',
    11,
  ),
  PracticeMode(
    'dialogue-ordering',
    Icons.forum,
    'Dialogue Ordering',
    'Conversation sequence',
    9,
  ),
  PracticeMode(
    'sign-recognition',
    Icons.signpost,
    'Sign Recognition',
    'Public sign meanings',
    4,
  ),
];

class PracticeModeScreen extends ConsumerStatefulWidget {
  const PracticeModeScreen({super.key, required this.mode});
  final String mode;

  @override
  ConsumerState<PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends ConsumerState<PracticeModeScreen> {
  int index = 0;
  int correct = 0;
  String? selectedAnswer;
  bool saved = false;
  late final Future<List<Map<String, Object?>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(repositoryProvider).practiceQuestions(limit: 10);
  }

  PracticeMode get mode => _modes.firstWhere(
    (item) => item.code == widget.mode,
    orElse: () => _modes.first,
  );

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, questions) {
      final theme = Theme.of(context);
      if (questions.isEmpty) {
        return const Scaffold(
          body: EmptyState(message: 'Practice is unavailable.'),
        );
      }
      final complete = index >= questions.length;
      if (complete && !saved) {
        saved = true;
        ref
            .read(repositoryProvider)
            .savePracticeResult(correct: correct, total: questions.length);
      }
      final tone =
          theme.phrasebook.categoryTiles[mode.toneIndex.clamp(
            0,
            theme.phrasebook.categoryTiles.length - 1,
          )];
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 18),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Icon(mode.icon, color: theme.colorScheme.onPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mode.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '$correct / ${questions.length}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: complete
                  ? _PracticeComplete(
                      correct: correct,
                      total: questions.length,
                      onRestart: () => setState(() {
                        index = 0;
                        correct = 0;
                        selectedAnswer = null;
                        saved = false;
                      }),
                    )
                  : _PracticeQuestionView(
                      row: questions[index],
                      rows: questions,
                      index: index,
                      total: questions.length,
                      mode: mode,
                      tone: tone,
                      selectedAnswer: selectedAnswer,
                      onSelect: (answer) {
                        if (selectedAnswer != null) return;
                        final current = questions[index];
                        if (answer == _answerFor(current, mode.code)) {
                          correct++;
                        }
                        setState(() => selectedAnswer = answer);
                      },
                      onNext: selectedAnswer == null
                          ? null
                          : () => setState(() {
                              index++;
                              selectedAnswer = null;
                            }),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

class _PracticeQuestionView extends StatelessWidget {
  const _PracticeQuestionView({
    required this.row,
    required this.rows,
    required this.index,
    required this.total,
    required this.mode,
    required this.tone,
    required this.selectedAnswer,
    required this.onSelect,
    required this.onNext,
  });

  final Map<String, Object?> row;
  final List<Map<String, Object?>> rows;
  final int index;
  final int total;
  final PracticeMode mode;
  final Color tone;
  final String? selectedAnswer;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prompt = _promptFor(row, mode.code);
    final correctAnswer = _answerFor(row, mode.code);
    final choices = _choicesFor(rows, row, mode.code, index);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          children: [
            PillLabel(label: '${index + 1} / $total', selected: true),
            const SizedBox(width: 8),
            PillLabel(label: mode.subtitle),
          ],
        ),
        const SizedBox(height: 14),
        UiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(mode.icon, color: tone, size: 30),
              const SizedBox(height: 14),
              Text(
                prompt,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _contextFor(row),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final choice in choices)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AnswerTile(
              answer: choice,
              correctAnswer: correctAnswer,
              selectedAnswer: selectedAnswer,
              onTap: () => onSelect(choice),
            ),
          ),
        const SizedBox(height: 6),
        FilledButton(
          onPressed: onNext,
          child: Text(index == total - 1 ? 'Finish' : 'Next'),
        ),
      ],
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.answer,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onTap,
  });

  final String answer;
  final String correctAnswer;
  final String? selectedAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = selectedAnswer == answer;
    final revealed = selectedAnswer != null;
    final correct = answer == correctAnswer;
    final color = !revealed
        ? theme.colorScheme.surfaceContainerLowest
        : correct
        ? theme.phrasebook.successSoft
        : selected
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.surfaceContainerLowest;
    final icon = !revealed
        ? Icons.radio_button_unchecked
        : correct
        ? Icons.check_circle
        : selected
        ? Icons.cancel
        : Icons.radio_button_unchecked;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: revealed ? null : onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: theme.phrasebook.cardBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: correct ? theme.phrasebook.success : null),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  answer,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: selected || correct ? FontWeight.w800 : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeComplete extends StatelessWidget {
  const _PracticeComplete({
    required this.correct,
    required this.total,
    required this.onRestart,
  });

  final int correct;
  final int total;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: UiCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events,
                size: 42,
                color: theme.phrasebook.favorite,
              ),
              const SizedBox(height: 12),
              Text(
                '$correct / $total',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text('Session complete', style: theme.textTheme.titleMedium),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: onRestart,
                child: const Text('Practice again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _promptFor(Map<String, Object?> row, String mode) {
  if (mode == 'so-en') return '${row['somali_headword']}';
  if (mode == 'complete-phrase') return '${row['english_sentence']}';
  if (mode == 'correct-response') return '${row['english_sentence']}';
  return '${row['english_headword']}';
}

String _answerFor(Map<String, Object?> row, String mode) {
  if (mode == 'so-en') return '${row['english_headword']}';
  return '${row['somali_headword']}';
}

String _contextFor(Map<String, Object?> row) {
  final sentence = '${row['somali_sentence'] ?? ''}'.trim();
  return sentence.isEmpty ? '${row['english_sentence']}' : sentence;
}

List<String> _choicesFor(
  List<Map<String, Object?>> rows,
  Map<String, Object?> current,
  String mode,
  int index,
) {
  final correct = _answerFor(current, mode);
  final pool = rows
      .map((row) => _answerFor(row, mode))
      .where((answer) => answer != correct)
      .toSet()
      .toList();
  final selected = <String>[correct];
  for (var offset = 0; offset < pool.length && selected.length < 4; offset++) {
    selected.add(pool[(index + offset) % pool.length]);
  }
  if (selected.length < 2) return selected;
  final shift = index % selected.length;
  return [...selected.skip(shift), ...selected.take(shift)];
}
