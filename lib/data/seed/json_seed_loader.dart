import 'dart:convert';

import 'package:flutter/services.dart';

class JsonSeedBundle {
  const JsonSeedBundle({
    required this.categories,
    required this.subcategories,
    required this.expressions,
    required this.expressionExamples,
    required this.dialogues,
    required this.dialogueLines,
    required this.vocabularyEntries,
    required this.vocabularyTranslations,
    required this.vocabularyExamples,
    required this.categoryVocabulary,
    required this.referenceEntries,
  });

  final List<Map<String, Object?>> categories;
  final List<Map<String, Object?>> subcategories;
  final List<Map<String, Object?>> expressions;
  final List<Map<String, Object?>> expressionExamples;
  final List<Map<String, Object?>> dialogues;
  final List<Map<String, Object?>> dialogueLines;
  final List<Map<String, Object?>> vocabularyEntries;
  final List<Map<String, Object?>> vocabularyTranslations;
  final List<Map<String, Object?>> vocabularyExamples;
  final List<Map<String, Object?>> categoryVocabulary;
  final List<Map<String, Object?>> referenceEntries;
}

class JsonSeedLoader {
  const JsonSeedLoader._();

  static const seedVersion = 11;

  static const phraseAssets = <String>[
    'lib/data/seed/phrases/clothing_phrases.json',
    'lib/data/seed/phrases/communication_phrases.json',
    'lib/data/seed/phrases/daily_activities_phrases.json',
    'lib/data/seed/phrases/descriptions_phrases.json',
    'lib/data/seed/phrases/food_dining_phrases.json',
    'lib/data/seed/phrases/greetings_etiquette_phrases.json',
    'lib/data/seed/phrases/health_phrases.json',
    'lib/data/seed/phrases/housing_phrases.json',
    'lib/data/seed/phrases/jobs_work_phrases.json',
    'lib/data/seed/phrases/language_barrier_phrases.json',
    'lib/data/seed/phrases/locations_phrases.json',
    'lib/data/seed/phrases/measurements_phrases.json',
    'lib/data/seed/phrases/money_phrases.json',
    'lib/data/seed/phrases/numbers_phrases.json',
    'lib/data/seed/phrases/personal_information_phrases.json',
    'lib/data/seed/phrases/public_signs_phrases.json',
    'lib/data/seed/phrases/school_education_phrases.json',
    'lib/data/seed/phrases/time_phrases.json',
    'lib/data/seed/phrases/transportation_phrases.json',
  ];

  static const conversationAssets = <String>[
    'lib/data/seed/conversations/clothing_conversations.json',
    'lib/data/seed/conversations/communication_conversations.json',
    'lib/data/seed/conversations/daily_activities_conversations.json',
    'lib/data/seed/conversations/descriptions_conversations.json',
    'lib/data/seed/conversations/food_dining_conversations.json',
    'lib/data/seed/conversations/greetings_etiquette_conversations.json',
    'lib/data/seed/conversations/health_conversations.json',
    'lib/data/seed/conversations/housing_conversations.json',
    'lib/data/seed/conversations/jobs_work_conversations.json',
    'lib/data/seed/conversations/language_barrier_conversations.json',
    'lib/data/seed/conversations/locations_conversations.json',
    'lib/data/seed/conversations/measurements_conversations.json',
    'lib/data/seed/conversations/money_conversations.json',
    'lib/data/seed/conversations/numbers_conversations.json',
    'lib/data/seed/conversations/personal_information_conversations.json',
    'lib/data/seed/conversations/public_signs_conversations.json',
    'lib/data/seed/conversations/school_education_conversations.json',
    'lib/data/seed/conversations/time_conversations.json',
    'lib/data/seed/conversations/transportation_conversations.json',
  ];

  static const vocabularyAssets = <String>[
    'lib/data/seed/vocabulary/clothing.json',
    'lib/data/seed/vocabulary/communication.json',
    'lib/data/seed/vocabulary/daily_activities.json',
    'lib/data/seed/vocabulary/descriptions.json',
    'lib/data/seed/vocabulary/food_dining.json',
    'lib/data/seed/vocabulary/greetings_etiquette.json',
    'lib/data/seed/vocabulary/health.json',
    'lib/data/seed/vocabulary/housing.json',
    'lib/data/seed/vocabulary/jobs_work.json',
    'lib/data/seed/vocabulary/language_barrier_vocabulary.json',
    'lib/data/seed/vocabulary/locations.json',
    'lib/data/seed/vocabulary/measurements.json',
    'lib/data/seed/vocabulary/money.json',
    'lib/data/seed/vocabulary/numbers.json',
    'lib/data/seed/vocabulary/personal_information.json',
    'lib/data/seed/vocabulary/public_signs.json',
    'lib/data/seed/vocabulary/school_education.json',
    'lib/data/seed/vocabulary/time.json',
    'lib/data/seed/vocabulary/transportation.json',
  ];

  static const referenceAssets = <String, String>{
    'reference_expression':
        'lib/data/seed/reference/expressions_reference.json',
    'common_question':
        'lib/data/seed/reference/common_questions_reference.json',
    'everyday_response':
        'lib/data/seed/reference/everyday_responses_reference.json',
    'phrasal_verb': 'lib/data/seed/reference/phrasal_verbs_reference.json',
    'idiom': 'lib/data/seed/reference/idioms_reference.json',
  };

  static Future<JsonSeedBundle> load() async {
    final now = DateTime.now().toIso8601String();
    final categoriesJson = await _loadList(
      'lib/data/seed/categories_seed.json',
    );
    final categories = <Map<String, Object?>>[];
    final categoryIdsByCode = <String, String>{};
    for (final item in categoriesJson) {
      final code = _canonicalCategoryCode(_string(item['code']));
      final id = 'category_$code';
      categoryIdsByCode[code] = id;
      categories.add({
        'id': id,
        'code': code,
        'english_title': _string(item['english_title']),
        'somali_title': _string(item['somali_title']),
        'english_description': _string(item['english_description']),
        'somali_description': _string(item['somali_description']),
        'icon_key': _string(item['icon'], fallback: 'label'),
        'theme_key': _themeKey(item['sort_order']),
        'sort_order': _int(item['sort_order'], fallback: categories.length + 1),
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
      });
    }

    final subcategoriesJson = await _loadList(
      'lib/data/seed/subcategories_seed.json',
    );
    final subcategories = <Map<String, Object?>>[];
    final subcategoryIds = <String>{};
    final subcategoryOrderByCategory = <String, int>{};
    for (final item in subcategoriesJson) {
      final categoryCode = _canonicalCategoryCode(
        _string(item['category_code']),
      );
      final categoryId = categoryIdsByCode[categoryCode];
      if (categoryId == null) continue;
      final code = _string(item['code']).replaceAll('.', '_');
      final id = _string(item['id'], fallback: 'subcategory_$code');
      subcategoryIds.add(id);
      final sortOrder = (subcategoryOrderByCategory[categoryId] =
          (subcategoryOrderByCategory[categoryId] ?? 0) + 1);
      subcategories.add({
        'id': id,
        'category_id': categoryId,
        'english_title': _string(item['english_title']),
        'somali_title': _string(item['somali_title']),
        'sort_order': sortOrder,
      });
    }

    final expressions = <Map<String, Object?>>[];
    final expressionExamples = <Map<String, Object?>>[];
    final expressionOrderByCategory = <String, int>{};
    final usedExpressionIds = <String>{};
    final usedExpressionKeys = <String>{};
    for (final asset in phraseAssets) {
      final phrases = await _loadList(asset);
      final sourceKey = asset.split('/').last.replaceAll('.json', '');
      for (final item in phrases) {
        final categoryId =
            categoryIdsByCode[_canonicalCategoryCode(
              _string(item['category_code']),
            )];
        final subcategoryId = _subcategoryId(item['subcategory_code']);
        if (categoryId == null || !subcategoryIds.contains(subcategoryId)) {
          continue;
        }
        final rawId = _string(item['id']);
        final id = usedExpressionIds.add(rawId) ? rawId : '$sourceKey:$rawId';
        final sortOrder = (expressionOrderByCategory[categoryId] =
            (expressionOrderByCategory[categoryId] ?? 0) + 1);
        final english = _string(item['english']);
        final somali = _string(item['somali']);
        final expressionKey = '$categoryId|${english.toLowerCase()}';
        if (!usedExpressionKeys.add(expressionKey)) continue;
        expressions.add({
          'id': id,
          'category_id': categoryId,
          'subcategory_id': subcategoryId,
          'english_text': english,
          'somali_text': somali,
          'somali_alternative': _strings(item['alternative_somali']).join('; '),
          'usage_explanation': _string(
            item['notes'],
            fallback: 'Phrasebook phrase.',
          ),
          'context': _string(item['type'], fallback: 'phrase'),
          'formality': _formality(item['type']),
          'pronunciation': '',
          'difficulty': _string(item['cefr'], fallback: 'A1'),
          'sort_order': sortOrder,
          'search_text':
              '$english $somali ${_strings(item['keywords']).join(' ')}',
          'created_at': now,
          'updated_at': now,
        });
        expressionExamples.add({
          'id': '${id}_example_1',
          'expression_id': id,
          'english_sentence': english,
          'somali_sentence': somali,
          'sort_order': 1,
        });
      }
    }

    final dialogues = <Map<String, Object?>>[];
    final dialogueLines = <Map<String, Object?>>[];
    final dialogueOrderByCategory = <String, int>{};
    for (final asset in conversationAssets) {
      final conversations = await _loadList(asset);
      for (final item in conversations) {
        final categoryId =
            categoryIdsByCode[_canonicalCategoryCode(
              _string(item['category_code']),
            )];
        final subcategoryId = _subcategoryId(item['subcategory_code']);
        if (categoryId == null || !subcategoryIds.contains(subcategoryId)) {
          continue;
        }
        final id = _string(item['id']);
        final sortOrder = (dialogueOrderByCategory[categoryId] =
            (dialogueOrderByCategory[categoryId] ?? 0) + 1);
        dialogues.add({
          'id': id,
          'category_id': categoryId,
          'subcategory_id': subcategoryId,
          'code': id,
          'english_title': _string(item['title']),
          'somali_title': _string(item['somali_title']),
          'english_situation': _string(item['situation']),
          'somali_situation': _string(item['somali_situation']),
          'difficulty': _string(item['cefr'], fallback: 'A1'),
          'sort_order': sortOrder,
          'created_at': now,
          'updated_at': now,
        });
        final lines = item['dialogue'];
        if (lines is List) {
          for (final line in lines.whereType<Map<String, dynamic>>()) {
            final order = _int(
              line['turn'],
              fallback: dialogueLines.length + 1,
            );
            dialogueLines.add({
              'id': '${id}_line_$order',
              'dialogue_id': id,
              'speaker': _string(line['speaker']),
              'english_text': _string(line['english']),
              'somali_text': _string(line['somali']),
              'usage_note': '',
              'line_order': order,
            });
          }
        }
      }
    }

    final vocabularyEntries = <Map<String, Object?>>[];
    final vocabularyTranslations = <Map<String, Object?>>[];
    final vocabularyExamples = <Map<String, Object?>>[];
    final categoryVocabulary = <Map<String, Object?>>[];
    final usedVocabularyIds = <String>{};
    final vocabularyIdByHeadword = <String, String>{};
    final categoryVocabularyKeys = <String>{};
    for (final asset in vocabularyAssets) {
      final words = await _loadList(asset);
      for (final item in words) {
        final categoryId =
            categoryIdsByCode[_canonicalCategoryCode(
              _string(item['category_code']),
            )];
        if (categoryId == null) continue;
        final id = _string(item['id']);
        final english =
            (item['english'] as Map?)?.cast<String, dynamic>() ?? {};
        final somali = (item['somali'] as Map?)?.cast<String, dynamic>() ?? {};
        final headword = _string(english['headword'], fallback: id);
        final pos = _string(item['part_of_speech'], fallback: 'noun');
        final vocabKey = '${headword.toLowerCase()}|$pos';
        final existingId = vocabularyIdByHeadword[vocabKey];
        if (existingId != null) {
          final relationKey = '$categoryId|$existingId';
          if (categoryVocabularyKeys.add(relationKey)) {
            categoryVocabulary.add({
              'category_id': categoryId,
              'vocabulary_entry_id': existingId,
            });
          }
          continue;
        }
        if (!usedVocabularyIds.add(id)) continue;
        vocabularyIdByHeadword[vocabKey] = id;
        final senses = item['senses'];
        final firstSense =
            senses is List && senses.isNotEmpty && senses.first is Map
            ? (senses.first as Map).cast<String, dynamic>()
            : const <String, dynamic>{};
        final examples = firstSense['examples'];
        final firstExample =
            examples is List && examples.isNotEmpty && examples.first is Map
            ? (examples.first as Map).cast<String, dynamic>()
            : const <String, dynamic>{};
        vocabularyEntries.add({
          'id': id,
          'english_headword': headword,
          'part_of_speech': pos,
          'english_definition': _string(firstSense['definition']),
          'plural_form': '',
          'past_form': '',
          'past_participle': '',
          'comparative_form': '',
          'superlative_form': '',
          'frequency': 'common',
          'difficulty': _string(item['cefr'], fallback: 'A1'),
          'pronunciation': '',
          'usage_notes': _strings(item['common_mistakes']).join('; '),
          'alphabetical_key': headword.toLowerCase(),
          'metadata_json': jsonEncode(item),
          'created_at': now,
          'updated_at': now,
        });
        vocabularyTranslations.add({
          'id': '${id}_translation_1',
          'vocabulary_entry_id': id,
          'somali_headword': _string(somali['translation']),
          'somali_explanation': _string(somali['explanation']),
          'regional_variant': '',
          'is_primary': 1,
          'sort_order': 1,
        });
        vocabularyExamples.add({
          'id': '${id}_example_1',
          'vocabulary_entry_id': id,
          'english_sentence': _string(firstExample['english']),
          'somali_sentence': _string(firstExample['somali']),
          'context': _strings(item['situations']).take(1).join(),
          'sort_order': 1,
        });
        final relationKey = '$categoryId|$id';
        if (categoryVocabularyKeys.add(relationKey)) {
          categoryVocabulary.add({
            'category_id': categoryId,
            'vocabulary_entry_id': id,
          });
        }
      }
    }

    final referenceEntries = <Map<String, Object?>>[];
    for (final asset in referenceAssets.entries) {
      final items = await _loadList(asset.value);
      for (final item in items.indexed) {
        final english = _string(item.$2['english']);
        final somali = _string(item.$2['somali']);
        referenceEntries.add({
          'id': _string(item.$2['id']),
          'type': asset.key,
          'english': english,
          'somali': somali,
          'explanation': _string(item.$2['explanation']),
          'example_english': _string(item.$2['example_english']),
          'example_somali': _string(item.$2['example_somali']),
          'answer_example_english': _string(item.$2['answer_example_english']),
          'answer_example_somali': _string(item.$2['answer_example_somali']),
          'context': _string(item.$2['context']),
          'register': _string(item.$2['register']),
          'tags_json': jsonEncode(_strings(item.$2['tags'])),
          'search_text': '$english $somali ${_string(item.$2['explanation'])}',
          'sort_order': item.$1 + 1,
        });
      }
    }

    return JsonSeedBundle(
      categories: categories,
      subcategories: subcategories,
      expressions: expressions,
      expressionExamples: expressionExamples,
      dialogues: dialogues,
      dialogueLines: dialogueLines,
      vocabularyEntries: vocabularyEntries,
      vocabularyTranslations: vocabularyTranslations,
      vocabularyExamples: vocabularyExamples,
      categoryVocabulary: categoryVocabulary,
      referenceEntries: referenceEntries,
    );
  }

  static Future<List<Map<String, dynamic>>> _loadList(String asset) async {
    final text = await rootBundle.loadString(asset);
    return (jsonDecode(text) as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  static String _canonicalCategoryCode(String code) => switch (code) {
    'food_dining' => 'food',
    'jobs_work' => 'jobs',
    'school_education' => 'school',
    _ => code,
  };

  static String _subcategoryId(Object? code) {
    final value = _string(code).replaceAll('.', '_');
    return value.startsWith('subcategory_') ? value : 'subcategory_$value';
  }

  static String _themeKey(Object? sortOrder) {
    const keys = ['green', 'red', 'amber', 'blue', 'purple', 'teal'];
    return keys[(_int(sortOrder, fallback: 1) - 1) % keys.length];
  }

  static String _formality(Object? type) {
    final value = _string(type);
    if (value.contains('polite')) return 'polite';
    return 'neutral';
  }

  static String _string(Object? value, {String fallback = ''}) {
    final text = value == null ? '' : '$value'.trim();
    return text.isEmpty ? fallback : text;
  }

  static int _int(Object? value, {required int fallback}) {
    if (value is int) return value;
    return int.tryParse('$value') ?? fallback;
  }

  static List<String> _strings(Object? value) {
    if (value is List) {
      return value
          .map((item) => '$item'.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static Future<List<Map<String, Object?>>> signRows() async {
    final phrases = await _loadList(
      'lib/data/seed/phrases/public_signs_phrases.json',
    );
    return [
      for (final item in phrases.indexed)
        {
          'id': _string(item.$2['id']),
          'english_text': _string(item.$2['english']),
          'somali_meaning': _string(item.$2['somali']),
          'somali_explanation': _string(item.$2['notes']),
          'category': _string(item.$2['subcategory_code']).replaceAll('_', ' '),
          'icon_key': 'signpost',
          'seen_at': '',
        },
    ];
  }

  static Future<List<Map<String, Object?>>> unitsRows() async {
    final words = await _loadList('lib/data/seed/vocabulary/measurements.json');
    return [
      for (final entry in words.indexed)
        {
          'id': _string(entry.$2['id']),
          'english_name': _string(
            (entry.$2['english'] as Map?)?.cast<String, dynamic>()['headword'],
          ),
          'somali_name': _string(
            (entry.$2['somali'] as Map?)
                ?.cast<String, dynamic>()['translation'],
          ),
          'unit_type': _string(
            entry.$2['subcategory_code'],
          ).replaceAll('_', ' '),
          'explanation': _string(
            (entry.$2['somali'] as Map?)
                ?.cast<String, dynamic>()['explanation'],
          ),
        },
    ];
  }

  static List<Map<String, Object?>> qaRows() => const [];
}
