import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';

class ExpressionDetailScreen extends ConsumerWidget {
  const ExpressionDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: Future.wait([
      ref.watch(repositoryProvider).expression(id),
      ref.watch(repositoryProvider).expressionExample(id),
      ref.watch(repositoryProvider).isFavorite('expression', id),
    ]),
    builder: (context, data) {
      final expr = data[0] as Map<String, Object?>?;
      if (expr == null) return const MissingScaffold();
      final example = data[1] as Map<String, Object?>?;
      final favorite = data[2] as bool;
      ref
          .watch(repositoryProvider)
          .markRecent(
            'expression',
            id,
            '${expr['english_text']}',
            '${expr['somali_text']}',
          );
      final theme = Theme.of(context);
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
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
                              '${expr['english_text']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${expr['context']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async => ref
                            .read(repositoryProvider)
                            .toggleFavorite('expression', id),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  UiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LanguageLine(
                          label: 'English',
                          text: '${expr['english_text']}',
                          onCopy: () => _copy('${expr['english_text']}'),
                        ),
                        Divider(color: theme.phrasebook.cardBorder),
                        _LanguageLine(
                          label: 'Somali',
                          text: '${expr['somali_text']}',
                          emphasize: true,
                          onCopy: () => _copy('${expr['somali_text']}'),
                        ),
                        if ('${expr['somali_alternative']}'.isNotEmpty) ...[
                          Divider(color: theme.phrasebook.cardBorder),
                          _LanguageLine(
                            label: 'Alternative',
                            text: '${expr['somali_alternative']}',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Usage',
                    value: '${expr['usage_explanation']}',
                  ),
                  _InfoRow(label: 'Formality', value: '${expr['formality']}'),
                  _InfoRow(label: 'Difficulty', value: '${expr['difficulty']}'),
                  _InfoRow(label: 'Context', value: '${expr['context']}'),
                  if (example != null) ...[
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
                          _LanguageLine(
                            label: 'English',
                            text: '${example['english_sentence']}',
                            onCopy: () =>
                                _copy('${example['english_sentence']}'),
                          ),
                          Divider(color: theme.phrasebook.cardBorder),
                          _LanguageLine(
                            label: 'Somali',
                            text: '${example['somali_sentence']}',
                            emphasize: true,
                            onCopy: () =>
                                _copy('${example['somali_sentence']}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _LanguageLine extends StatelessWidget {
  const _LanguageLine({
    required this.label,
    required this.text,
    this.emphasize = false,
    this.onCopy,
  });

  final String label;
  final String text;
  final bool emphasize;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: emphasize ? theme.phrasebook.success : null,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onCopy, icon: const Icon(Icons.volume_up)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.phrasebook.infoSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 86,
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}

Future<void> _copy(String text) => Clipboard.setData(ClipboardData(text: text));
