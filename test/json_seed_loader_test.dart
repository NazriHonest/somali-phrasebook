import 'package:english_somali_phrasebook/data/seed/json_seed_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('json seed folder migrates into database row bundles', () async {
    final bundle = await JsonSeedLoader.load();

    expect(bundle.categories, hasLength(19));
    expect(bundle.subcategories.length, greaterThan(100));
    expect(bundle.expressions.length, greaterThan(1000));
    expect(bundle.dialogues.length, greaterThan(100));
    expect(bundle.dialogueLines.length, greaterThan(1000));
    expect(bundle.vocabularyEntries.length, greaterThan(100));
    expect(
      bundle.vocabularyTranslations,
      hasLength(bundle.vocabularyEntries.length),
    );
    expect(
      bundle.vocabularyExamples,
      hasLength(bundle.vocabularyEntries.length),
    );
    expect(
      bundle.categoryVocabulary.length,
      greaterThan(bundle.vocabularyEntries.length),
    );
    expect(bundle.referenceEntries, hasLength(225));

    final categoryIds = bundle.categories.map((row) => row['id']).toSet();
    final subcategoryIds = bundle.subcategories.map((row) => row['id']).toSet();
    for (final row in bundle.subcategories) {
      expect(categoryIds, contains(row['category_id']));
    }
    for (final row in bundle.expressions) {
      expect(categoryIds, contains(row['category_id']));
      expect(subcategoryIds, contains(row['subcategory_id']));
    }
    for (final row in bundle.dialogues) {
      expect(categoryIds, contains(row['category_id']));
      expect(subcategoryIds, contains(row['subcategory_id']));
    }
    for (final row in bundle.categoryVocabulary) {
      expect(categoryIds, contains(row['category_id']));
    }
  });
}
