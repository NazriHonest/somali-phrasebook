import 'dart:io';

import 'package:english_somali_phrasebook/data/seed/seed_factory.dart';

void main() {
  final categories = SeedFactory.categoryRows();
  final subcategories = SeedFactory.subcategoryRows();
  final expressions = SeedFactory.expressionRows();
  final expressionExamples = SeedFactory.expressionExampleRows();
  final dialogues = SeedFactory.dialogueRows();
  final lines = SeedFactory.dialogueLineRows();
  final qa = SeedFactory.qaRows();
  final vocabulary = SeedFactory.vocabularyRows();
  final translations = SeedFactory.vocabularyTranslationRows();
  final examples = SeedFactory.vocabularyExampleRows();
  final categoryVocabulary = SeedFactory.vocabularyCategoryRows();
  final signs = SeedFactory.signRows();

  final failures = <String>[];
  final categoryIds = categories.map((row) => '${row['id']}').toSet();
  final subcategoryIds = subcategories.map((row) => '${row['id']}').toSet();
  final vocabularyIds = vocabulary.map((row) => '${row['id']}').toSet();
  final dialogueIds = dialogues.map((row) => '${row['id']}').toSet();
  final expressionIds = expressions.map((row) => '${row['id']}').toSet();

  int duplicateCount(Iterable<String> values) {
    final seen = <String>{};
    var duplicates = 0;
    for (final value in values) {
      if (!seen.add(value.toLowerCase().trim())) duplicates++;
    }
    return duplicates;
  }

  bool containsAny(String value, List<Pattern> patterns) {
    final lower = value.toLowerCase();
    return patterns.any((pattern) => lower.contains(pattern));
  }

  final templatePatterns = <Pattern>[
    'for detail',
    'qodobka ',
    'i need this word for',
    'a practical word or expression used when talking about',
    'waa eray somali ah oo ka caawinaya fahamka',
    RegExp(r'\bcategory item \d+\b'),
    RegExp(r'\btopic phrase \d+\b'),
    RegExp(r'\bword [a-z_ ]+ \d+\b'),
  ];
  final genericDefinitionPatterns = <Pattern>[
    'a practical word used when talking about',
    'a practical word or expression used when talking about',
    'used when talking about this topic',
  ];
  final categoryCodes = categories.map((row) => '${row['code']}').toSet();
  final allowedPartsOfSpeech = {
    'adjective',
    'adverb',
    'conjunction',
    'noun',
    'phrase',
    'preposition',
    'verb',
  };

  final duplicateExpressions = duplicateCount(
    expressions.map((row) => '${row['english_text']}'),
  );
  final duplicateVocabulary = duplicateCount(
    vocabulary.map(
      (row) => '${row['english_headword']}|${row['part_of_speech']}',
    ),
  );
  final duplicateDialogues = duplicateCount(
    dialogues.map((row) => '${row['english_title']}'),
  );
  final duplicateLines = duplicateCount(
    lines.map((row) => '${row['dialogue_id']}|${row['english_text']}'),
  );
  final duplicateCountTotal =
      duplicateExpressions +
      duplicateVocabulary +
      duplicateDialogues +
      duplicateLines;

  final allTextRows = [
    ...expressions.expand(
      (row) => [
        row['english_text'],
        row['somali_text'],
        row['usage_explanation'],
      ],
    ),
    ...expressionExamples.expand(
      (row) => [row['english_sentence'], row['somali_sentence']],
    ),
    ...dialogues.expand(
      (row) => [
        row['english_title'],
        row['somali_title'],
        row['english_situation'],
        row['somali_situation'],
      ],
    ),
    ...lines.expand((row) => [row['english_text'], row['somali_text']]),
    ...qa.expand(
      (row) => [
        row['english_question'],
        row['somali_question'],
        row['english_answer'],
        row['somali_answer'],
      ],
    ),
    ...vocabulary.expand(
      (row) => [row['english_headword'], row['english_definition']],
    ),
    ...translations.expand(
      (row) => [row['somali_headword'], row['somali_explanation']],
    ),
    ...examples.expand(
      (row) => [row['english_sentence'], row['somali_sentence']],
    ),
  ].map((value) => '$value').toList();

  final repeatedTemplateCount = allTextRows
      .where((value) => containsAny(value, templatePatterns))
      .length;
  final invalidHeadwordCount = vocabulary.where((row) {
    final headword = '${row['english_headword']}'.trim().toLowerCase();
    return RegExp(r'\d+$').hasMatch(headword) ||
        categoryCodes.any((code) => headword.contains(code));
  }).length;
  final genericDefinitionCount = vocabulary
      .where(
        (row) => containsAny(
          '${row['english_definition']}',
          genericDefinitionPatterns,
        ),
      )
      .length;
  final genericSomaliExplanationCount = translations
      .where(
        (row) => containsAny('${row['somali_explanation']}', [
          'waa eray somali ah',
          'ka caawinaya fahamka',
        ]),
      )
      .length;
  final genericExampleCount = examples
      .where(
        (row) => '${row['english_sentence']}'.toLowerCase().contains(
          'i need this word for',
        ),
      )
      .length;
  final missingTranslationCount = [
    ...expressions.map((row) => '${row['somali_text']}'),
    ...lines.map((row) => '${row['somali_text']}'),
    ...qa.expand(
      (row) => ['${row['somali_question']}', '${row['somali_answer']}'],
    ),
    ...translations.map((row) => '${row['somali_headword']}'),
  ].where((value) => value.trim().isEmpty).length;
  final missingExampleCount = vocabularyIds
      .where((id) => !examples.any((row) => row['vocabulary_entry_id'] == id))
      .length;
  final requiredTextRows = [
    ...expressions.expand(
      (row) => [
        row['english_text'],
        row['somali_text'],
        row['usage_explanation'],
        row['context'],
      ],
    ),
    ...expressionExamples.expand(
      (row) => [row['english_sentence'], row['somali_sentence']],
    ),
    ...dialogues.expand(
      (row) => [
        row['english_title'],
        row['somali_title'],
        row['english_situation'],
        row['somali_situation'],
      ],
    ),
    ...lines.expand(
      (row) => [row['speaker'], row['english_text'], row['somali_text']],
    ),
    ...qa.expand(
      (row) => [
        row['english_question'],
        row['somali_question'],
        row['english_answer'],
        row['somali_answer'],
      ],
    ),
    ...vocabulary.expand(
      (row) => [
        row['english_headword'],
        row['part_of_speech'],
        row['english_definition'],
        row['frequency'],
        row['difficulty'],
        row['alphabetical_key'],
      ],
    ),
    ...translations.expand(
      (row) => [row['somali_headword'], row['somali_explanation']],
    ),
    ...examples.expand(
      (row) => [row['english_sentence'], row['somali_sentence']],
    ),
  ].map((value) => '$value').toList();
  final emptyFieldCount = requiredTextRows
      .where((value) => value.trim().isEmpty)
      .length;

  final expressionExampleRepeatCount = expressionExamples.where((example) {
    final expression = expressions.firstWhere(
      (row) => row['id'] == example['expression_id'],
      orElse: () => const {},
    );
    return '${expression['english_text']}'.trim().toLowerCase() ==
        '${example['english_sentence']}'.trim().toLowerCase();
  }).length;

  final fakePronunciationCount = [
    ...expressions.where(
      (row) =>
          '${row['pronunciation']}'.isNotEmpty &&
          '${row['pronunciation']}' == '${row['english_text']}'.toLowerCase(),
    ),
    ...vocabulary.where(
      (row) =>
          '${row['pronunciation']}'.isNotEmpty &&
          '${row['pronunciation']}' ==
              '${row['english_headword']}'.toLowerCase(),
    ),
  ].length;

  final invalidPartOfSpeechCount = vocabulary
      .where(
        (row) => !allowedPartsOfSpeech.contains('${row['part_of_speech']}'),
      )
      .length;
  final invalidVocabularyExamples = vocabulary.where((word) {
    final headword = '${word['english_headword']}'.toLowerCase();
    final plural = '${word['plural_form']}'.toLowerCase();
    final past = '${word['past_form']}'.toLowerCase();
    final participle = '${word['past_participle']}'.toLowerCase();
    final sentence = examples
        .where((row) => row['vocabulary_entry_id'] == word['id'])
        .map((row) => '${row['english_sentence']}'.toLowerCase())
        .join(' ');
    return !sentence.contains(headword) &&
        (plural.isEmpty || !sentence.contains(plural)) &&
        (past.isEmpty || !sentence.contains(past)) &&
        (participle.isEmpty || !sentence.contains(participle));
  }).length;
  final shortDialogueCount = dialogueIds.where((id) {
    return lines.where((row) => row['dialogue_id'] == id).length < 10;
  }).length;
  final thinSubcategoryExpressionCount = subcategories.where((subcategory) {
    final id = subcategory['id'];
    return expressions.where((row) => row['subcategory_id'] == id).length < 10;
  }).length;

  final invalidRelationships =
      categoryVocabulary.where((row) {
        return !categoryIds.contains('${row['category_id']}') ||
            !vocabularyIds.contains('${row['vocabulary_entry_id']}');
      }).length +
      lines
          .where((row) => !dialogueIds.contains('${row['dialogue_id']}'))
          .length +
      expressionExamples
          .where((row) => !expressionIds.contains('${row['expression_id']}'))
          .length +
      expressions
          .where(
            (row) =>
                !categoryIds.contains('${row['category_id']}') ||
                !subcategoryIds.contains('${row['subcategory_id']}'),
          )
          .length +
      dialogues
          .where(
            (row) =>
                !categoryIds.contains('${row['category_id']}') ||
                !subcategoryIds.contains('${row['subcategory_id']}'),
          )
          .length +
      qa
          .where(
            (row) =>
                !categoryIds.contains('${row['category_id']}') ||
                !subcategoryIds.contains('${row['subcategory_id']}'),
          )
          .length +
      translations
          .where(
            (row) => !vocabularyIds.contains('${row['vocabulary_entry_id']}'),
          )
          .length +
      examples
          .where(
            (row) => !vocabularyIds.contains('${row['vocabulary_entry_id']}'),
          )
          .length;

  if (categories.length != 19) failures.add('Expected 19 categories.');
  if (repeatedTemplateCount > 0) {
    failures.add('Template-like content found: $repeatedTemplateCount');
  }
  if (invalidHeadwordCount > 0) {
    failures.add('Invalid vocabulary headwords: $invalidHeadwordCount');
  }
  if (genericDefinitionCount > 0) {
    failures.add('Generic English definitions: $genericDefinitionCount');
  }
  if (genericSomaliExplanationCount > 0) {
    failures.add('Generic Somali explanations: $genericSomaliExplanationCount');
  }
  if (genericExampleCount > 0) {
    failures.add('Generic vocabulary examples: $genericExampleCount');
  }
  if (expressionExampleRepeatCount > 0) {
    failures.add(
      'Expression examples that repeat the expression: $expressionExampleRepeatCount',
    );
  }
  if (fakePronunciationCount > 0) {
    failures.add('Fake pronunciation fields: $fakePronunciationCount');
  }
  if (invalidVocabularyExamples > 0) {
    failures.add(
      'Vocabulary examples missing the headword or valid form: $invalidVocabularyExamples',
    );
  }
  if (invalidPartOfSpeechCount > 0) {
    failures.add('Invalid parts of speech: $invalidPartOfSpeechCount');
  }
  if (shortDialogueCount > 0) {
    failures.add('Dialogues below ten turns: $shortDialogueCount');
  }
  if (thinSubcategoryExpressionCount > 0) {
    failures.add(
      'Subcategories below ten expressions: $thinSubcategoryExpressionCount',
    );
  }
  if (duplicateCountTotal > 0) {
    failures.add('Duplicate content: $duplicateCountTotal');
  }
  if (missingTranslationCount > 0) {
    failures.add('Missing translations: $missingTranslationCount');
  }
  if (missingExampleCount > 0) {
    failures.add('Missing examples: $missingExampleCount');
  }
  if (emptyFieldCount > 0) {
    failures.add('Empty required fields: $emptyFieldCount');
  }
  if (invalidRelationships > 0) {
    failures.add('Invalid relationships: $invalidRelationships');
  }

  stdout.writeln('English-Somali Phrasebook Content Audit');
  stdout.writeln('seed_version: ${SeedFactory.seedVersion}');
  stdout.writeln('total categories: ${categories.length}');
  stdout.writeln('total subcategories: ${subcategories.length}');
  stdout.writeln('total expressions: ${expressions.length}');
  stdout.writeln('total dialogues: ${dialogues.length}');
  stdout.writeln('total dialogue lines: ${lines.length}');
  stdout.writeln('total question-answer pairs: ${qa.length}');
  stdout.writeln('total unique vocabulary entries: ${vocabulary.length}');
  stdout.writeln('total Somali translations: ${translations.length}');
  stdout.writeln(
    'total examples: ${examples.length + expressionExamples.length}',
  );
  stdout.writeln('total signs: ${signs.length}');
  stdout.writeln('duplicate count: $duplicateCountTotal');
  stdout.writeln('repeated-template count: $repeatedTemplateCount');
  stdout.writeln('invalid-headword count: $invalidHeadwordCount');
  stdout.writeln('generic-definition count: $genericDefinitionCount');
  stdout.writeln(
    'generic-somali-explanation count: $genericSomaliExplanationCount',
  );
  stdout.writeln('generic-example count: $genericExampleCount');
  stdout.writeln('missing-translation count: $missingTranslationCount');
  stdout.writeln('missing-example count: $missingExampleCount');
  stdout.writeln('invalid-relation count: $invalidRelationships');
  stdout.writeln('fake-pronunciation count: $fakePronunciationCount');
  stdout.writeln('invalid-part-of-speech count: $invalidPartOfSpeechCount');
  stdout.writeln('short-dialogue count: $shortDialogueCount');
  stdout.writeln(
    'thin-subcategory-expression count: $thinSubcategoryExpressionCount',
  );
  stdout.writeln('category content counts:');
  for (final category in categories) {
    final id = category['id'];
    final exprCount = expressions
        .where((row) => row['category_id'] == id)
        .length;
    final dialogueCount = dialogues
        .where((row) => row['category_id'] == id)
        .length;
    final qaCount = qa.where((row) => row['category_id'] == id).length;
    final vocabCount = categoryVocabulary
        .where((row) => row['category_id'] == id)
        .length;
    final subcategoryCount = subcategories
        .where((row) => row['category_id'] == id)
        .length;
    stdout.writeln(
      ' - ${category['english_title']}: sub=$subcategoryCount expr=$exprCount dlg=$dialogueCount qa=$qaCount vocab=$vocabCount',
    );
    if (subcategoryCount == 0 ||
        exprCount == 0 ||
        dialogueCount == 0 ||
        qaCount == 0 ||
        vocabCount == 0) {
      failures.add(
        'Category ${category['english_title']} has missing authored content.',
      );
    }
  }

  if (failures.isNotEmpty) {
    stderr.writeln('\nCRITICAL FAILURES');
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 1;
  }
}
