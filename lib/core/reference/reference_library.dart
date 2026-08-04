import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referenceLibraryProvider = Provider<ReferenceLibrary>((ref) {
  return const ReferenceLibrary();
});

class ReferenceLibrary {
  const ReferenceLibrary();

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

  Future<List<ReferenceEntry>> entries() async {
    final entries = <ReferenceEntry>[];
    for (final asset in referenceAssets.entries) {
      entries.addAll(await _loadEntries(asset.value, asset.key));
    }
    for (final asset in phraseAssets) {
      entries.addAll(await _loadEntries(asset, 'phrase'));
    }
    return entries;
  }

  Future<List<Map<String, Object?>>> search(String query) async {
    final normalizedQuery = normalizeReferenceText(query);
    final all = await entries();
    if (normalizedQuery.isEmpty) {
      return all.take(40).map((entry) => entry.toRow()).toList();
    }
    final scored = <({ReferenceEntry entry, int score})>[];
    for (final entry in all) {
      final score = entry.score(normalizedQuery);
      if (score > 0) scored.add((entry: entry, score: score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(80).map((item) => item.entry.toRow()).toList();
  }

  Future<ReferenceEntry?> entry(String type, String id) async {
    for (final item in await entries()) {
      if (item.type == type && item.id == id) return item;
    }
    return null;
  }

  Future<List<ReferenceEntry>> byType(String type) async {
    return (await entries()).where((entry) => entry.type == type).toList();
  }

  Future<List<ReferenceEntry>> related(ReferenceEntry entry) async {
    final tags = entry.tags.map(normalizeReferenceText).toSet();
    final context = normalizeReferenceText(entry.context);
    final related = <({ReferenceEntry entry, int score})>[];
    for (final item in await entries()) {
      if (item.id == entry.id && item.type == entry.type) continue;
      var score = 0;
      for (final tag in item.tags.map(normalizeReferenceText)) {
        if (tag.isNotEmpty && tags.contains(tag)) score += 3;
      }
      if (context.isNotEmpty &&
          normalizeReferenceText(item.context).contains(context)) {
        score += 2;
      }
      if (score > 0) related.add((entry: item, score: score));
    }
    related.sort((a, b) => b.score.compareTo(a.score));
    return related.take(6).map((item) => item.entry).toList();
  }

  Future<Map<String, int>> counts() async {
    final counts = <String, int>{};
    for (final entry in await entries()) {
      counts[entry.type] = (counts[entry.type] ?? 0) + 1;
    }
    return counts;
  }

  Future<Set<String>> idsForType(String type) async {
    return (await byType(type)).map((entry) => entry.id).toSet();
  }

  Future<List<ReferenceEntry>> _loadEntries(String asset, String type) async {
    final text = await rootBundle.loadString(asset);
    final decoded = jsonDecode(text) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((json) => ReferenceEntry.fromJson(type, json, sourceAsset: asset))
        .toList();
  }
}

class ReferenceEntry {
  const ReferenceEntry({
    required this.type,
    required this.id,
    required this.english,
    required this.somali,
    required this.explanation,
    required this.exampleEnglish,
    required this.exampleSomali,
    required this.answerExampleEnglish,
    required this.answerExampleSomali,
    required this.context,
    required this.categoryCode,
    required this.subcategoryCode,
    required this.tags,
    required this.register,
    required this.cefr,
    required this.notes,
    required this.phraseType,
  });

  final String type;
  final String id;
  final String english;
  final String somali;
  final String explanation;
  final String exampleEnglish;
  final String exampleSomali;
  final String answerExampleEnglish;
  final String answerExampleSomali;
  final String context;
  final String categoryCode;
  final String subcategoryCode;
  final List<String> tags;
  final String register;
  final String cefr;
  final String notes;
  final String phraseType;

  factory ReferenceEntry.fromJson(
    String type,
    Map<String, dynamic> json, {
    required String sourceAsset,
  }) {
    final rawId = '${json['id']}';
    final sourceKey = sourceAsset
        .split('/')
        .last
        .replaceAll('.json', '')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]+'), '_');
    return ReferenceEntry(
      type: type,
      id: type == 'phrase' ? '$sourceKey:$rawId' : rawId,
      english: _string(json['english']),
      somali: _string(json['somali']),
      explanation: _string(json['explanation']),
      exampleEnglish: _string(json['example_english']),
      exampleSomali: _string(json['example_somali']),
      answerExampleEnglish: _string(json['answer_example_english']),
      answerExampleSomali: _string(json['answer_example_somali']),
      context: _string(json['context']),
      categoryCode: _string(json['category_code']),
      subcategoryCode: _string(json['subcategory_code']),
      tags: [..._strings(json['tags']), ..._strings(json['keywords'])],
      register: _string(json['register']),
      cefr: _string(json['cefr']),
      notes: _string(json['notes']),
      phraseType: _string(json['type']),
    );
  }

  String get typeLabel => switch (type) {
    'reference_expression' => 'Expression',
    'common_question' => 'Question',
    'everyday_response' => 'Response',
    'phrasal_verb' => 'Phrasal verb',
    'idiom' => 'Idiom',
    'phrase' => 'Phrase',
    _ => type,
  };

  String get subtitle {
    if (somali.isNotEmpty) return somali;
    if (explanation.isNotEmpty) return explanation;
    return context;
  }

  String get contextLabel {
    if (context.isNotEmpty) return context;
    if (subcategoryCode.isNotEmpty) return subcategoryCode.replaceAll('_', ' ');
    if (categoryCode.isNotEmpty) return categoryCode.replaceAll('_', ' ');
    return typeLabel;
  }

  String get searchableText => [
    english,
    somali,
    explanation,
    exampleEnglish,
    exampleSomali,
    answerExampleEnglish,
    answerExampleSomali,
    context,
    categoryCode,
    subcategoryCode,
    register,
    cefr,
    notes,
    phraseType,
    ...tags,
  ].join(' ');

  int score(String normalizedQuery) {
    final haystack = normalizeReferenceText(searchableText);
    if (haystack.contains(normalizedQuery)) {
      final title = normalizeReferenceText(english);
      final translation = normalizeReferenceText(somali);
      if (title == normalizedQuery || translation == normalizedQuery) {
        return 100;
      }
      if (title.contains(normalizedQuery)) return 80;
      if (translation.contains(normalizedQuery)) return 70;
      return 50;
    }
    final queryTokens = normalizedQuery
        .split(' ')
        .where((token) => token.length > 2)
        .toList();
    if (queryTokens.isEmpty) return 0;
    final haystackTokens = haystack
        .split(' ')
        .where((token) => token.length > 2);
    var tokenScore = 0;
    for (final queryToken in queryTokens) {
      if (haystackTokens.any((token) => token == queryToken)) {
        tokenScore += 12;
      } else if (queryToken.length > 3 &&
          haystackTokens.any(
            (token) => _distanceAtMostOne(token, queryToken),
          )) {
        tokenScore += 5;
      }
    }
    return tokenScore;
  }

  Map<String, Object?> toRow() => {
    'type': type,
    'id': id,
    'title': english,
    'subtitle': subtitle,
    'preview': explanation.isNotEmpty ? explanation : contextLabel,
    'category': categoryCode,
    'subcategory': subcategoryCode,
    'type_label': typeLabel,
  };
}

String normalizeReferenceText(String value) {
  var normalized = value.toLowerCase().trim();
  const replacements = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    '’': '',
    "'": '',
    '-': ' ',
    '_': ' ',
  };
  for (final entry in replacements.entries) {
    normalized = normalized.replaceAll(entry.key, entry.value);
  }
  return normalized
      .replaceAll(RegExp(r'[^a-z0-9\s]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}

String _string(Object? value) => value == null ? '' : '$value'.trim();

List<String> _strings(Object? value) {
  if (value is List) {
    return value
        .map((item) => '$item'.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return const [];
}

bool _distanceAtMostOne(String a, String b) {
  if ((a.length - b.length).abs() > 1) return false;
  var edits = 0;
  var i = 0;
  var j = 0;
  while (i < a.length && j < b.length) {
    if (a.codeUnitAt(i) == b.codeUnitAt(j)) {
      i++;
      j++;
      continue;
    }
    edits++;
    if (edits > 1) return false;
    if (a.length > b.length) {
      i++;
    } else if (b.length > a.length) {
      j++;
    } else {
      i++;
      j++;
    }
  }
  return true;
}
