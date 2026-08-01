import 'package:english_somali_phrasebook/data/seed/seed_factory.dart';
import 'package:english_somali_phrasebook/core/theme/app_theme.dart';
import 'package:english_somali_phrasebook/features/categories/categories_screen.dart';
import 'package:english_somali_phrasebook/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seed insertion source contains authored content for every section', () {
    expect(SeedFactory.categoryRows(), hasLength(19));
    expect(SeedFactory.subcategoryRows(), hasLength(greaterThanOrEqualTo(95)));
    expect(SeedFactory.expressionRows(), hasLength(greaterThanOrEqualTo(38)));
    expect(SeedFactory.dialogueRows(), hasLength(19));
    expect(
      SeedFactory.dialogueLineRows(),
      hasLength(greaterThanOrEqualTo(114)),
    );
    expect(SeedFactory.qaRows(), hasLength(greaterThanOrEqualTo(38)));
    expect(SeedFactory.vocabularyRows(), hasLength(greaterThanOrEqualTo(38)));
    expect(
      SeedFactory.vocabularyTranslationRows(),
      hasLength(SeedFactory.vocabularyRows().length),
    );
  });

  test('all 19 categories have required linked content', () {
    final expressions = SeedFactory.expressionRows();
    final dialogues = SeedFactory.dialogueRows();
    final qa = SeedFactory.qaRows();
    final vocabulary = SeedFactory.vocabularyCategoryRows();
    for (final category in SeedFactory.categoryRows()) {
      final id = category['id'];
      expect(expressions.where((row) => row['category_id'] == id), isNotEmpty);
      expect(dialogues.where((row) => row['category_id'] == id), hasLength(1));
      expect(qa.where((row) => row['category_id'] == id), isNotEmpty);
      expect(vocabulary.where((row) => row['category_id'] == id), isNotEmpty);
    }
  });

  test(
    'duplicate detection finds no duplicate expressions or dialogue lines',
    () {
      int duplicates(Iterable<String> values) {
        final seen = <String>{};
        return values.where((value) => !seen.add(value)).length;
      }

      expect(
        duplicates(
          SeedFactory.expressionRows().map((row) => '${row['english_text']}'),
        ),
        0,
      );
      expect(
        duplicates(
          SeedFactory.dialogueLineRows().map(
            (row) => '${row['dialogue_id']}|${row['english_text']}',
          ),
        ),
        0,
      );
    },
  );

  test('authored seed rejects template-like phrasebook content', () {
    final allText = [
      ...SeedFactory.expressionRows().expand(
        (row) => [
          row['english_text'],
          row['somali_text'],
          row['usage_explanation'],
        ],
      ),
      ...SeedFactory.vocabularyRows().expand(
        (row) => [row['english_headword'], row['english_definition']],
      ),
      ...SeedFactory.vocabularyTranslationRows().expand(
        (row) => [row['somali_headword'], row['somali_explanation']],
      ),
      ...SeedFactory.vocabularyExampleRows().expand(
        (row) => [row['english_sentence'], row['somali_sentence']],
      ),
    ].map((value) => '$value'.toLowerCase()).join('\n');

    for (final forbidden in const [
      'for detail',
      'qodobka ',
      'i need this word for',
      'a practical word or expression used when talking about',
      'waa eray somali ah oo ka caawinaya fahamka',
    ]) {
      expect(allText, isNot(contains(forbidden)));
    }
  });

  test('vocabulary headwords, examples, and grammar are authored', () {
    const allowedPartsOfSpeech = {
      'adjective',
      'adverb',
      'conjunction',
      'noun',
      'phrase',
      'preposition',
      'verb',
    };
    final examples = {
      for (final row in SeedFactory.vocabularyExampleRows())
        row['vocabulary_entry_id']: '${row['english_sentence']}'.toLowerCase(),
    };

    for (final word in SeedFactory.vocabularyRows()) {
      final headword = '${word['english_headword']}';
      expect(RegExp(r'\d+$').hasMatch(headword), isFalse);
      expect(allowedPartsOfSpeech, contains(word['part_of_speech']));
      expect(
        '${word['english_definition']}',
        isNot(startsWith('A practical word')),
      );

      final sentence = examples[word['id']] ?? '';
      final forms = [
        headword.toLowerCase(),
        '${word['plural_form']}'.toLowerCase(),
        '${word['past_form']}'.toLowerCase(),
        '${word['past_participle']}'.toLowerCase(),
      ].where((value) => value.isNotEmpty);
      expect(forms.any(sentence.contains), isTrue);
    }

    final irregulars = {
      'apply': ['applied', 'applied'],
      'submit': ['submitted', 'submitted'],
    };
    for (final entry in irregulars.entries) {
      final row = SeedFactory.vocabularyRows().firstWhere(
        (word) => word['english_headword'] == entry.key,
      );
      expect(row['past_form'], entry.value.first);
      expect(row['past_participle'], entry.value.last);
    }
  });

  test('expression examples are real situations, not copied phrases', () {
    final expressions = {
      for (final row in SeedFactory.expressionRows()) row['id']: row,
    };
    for (final example in SeedFactory.expressionExampleRows()) {
      final expression = expressions[example['expression_id']]!;
      expect(
        '${example['english_sentence']}'.trim().toLowerCase(),
        isNot('${expression['english_text']}'.trim().toLowerCase()),
      );
      expect('${example['somali_sentence']}'.trim(), isNotEmpty);
    }
  });

  test('English-Somali and Somali-English search sources exist', () {
    final englishHits = SeedFactory.vocabularyRows()
        .where((row) => '${row['english_headword']}'.contains('appointment'))
        .toList();
    final somaliHits = SeedFactory.vocabularyTranslationRows()
        .where((row) => '${row['somali_headword']}'.contains('ballan'))
        .toList();
    expect(englishHits, isNotEmpty);
    expect(somaliHits, isNotEmpty);
  });

  test('practice generation source has bilingual answers', () {
    final vocab = SeedFactory.vocabularyRows().take(10).toList();
    final translations = SeedFactory.vocabularyTranslationRows()
        .take(10)
        .toList();
    for (var i = 0; i < vocab.length; i++) {
      expect(vocab[i]['english_headword'], isNotNull);
      expect(translations[i]['somali_headword'], isNotNull);
    }
  });

  testWidgets('onboarding renders on narrow scaled screens', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: OnboardingPage(
            icon: Icons.forum,
            title: 'Practical everyday phrases',
            body: 'Short English phrases with clear Somali meaning.',
          ),
        ),
      ),
    );
    expect(find.text('Practical everyday phrases'), findsOneWidget);
  });

  testWidgets('category card stays aligned on narrow light-mode screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.4)),
          child: Scaffold(
            body: CategoryListCard(
              icon: Icons.translate,
              englishTitle: 'Coping with the Language Barrier',
              somaliTitle: 'La qabsiga caqabadda luqadda',
              description:
                  'Ask for repetition, slower speech, spelling, and interpretation.',
              expressionCount: 2,
              dialogueCount: 1,
              onTap: _noop,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Coping with the Language Barrier'), findsOneWidget);
    expect(find.textContaining('expressions'), findsOneWidget);
  });
}

void _noop() {}
