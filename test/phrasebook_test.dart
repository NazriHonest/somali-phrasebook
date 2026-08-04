import 'package:english_somali_phrasebook/core/theme/app_theme.dart';
import 'package:english_somali_phrasebook/core/database/phrasebook_database.dart';
import 'package:english_somali_phrasebook/core/database/phrasebook_repository.dart';
import 'package:english_somali_phrasebook/data/seed/json_seed_loader.dart';
import 'package:english_somali_phrasebook/features/categories/categories_screen.dart';
import 'package:english_somali_phrasebook/features/home/home_feature.dart';
import 'package:english_somali_phrasebook/features/onboarding/onboarding_feature.dart';
import 'package:english_somali_phrasebook/features/onboarding/onboarding_screen.dart';
import 'package:english_somali_phrasebook/features/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'seed folder contains database-ready content for every section',
    () async {
      final bundle = await JsonSeedLoader.load();
      final signs = await JsonSeedLoader.signRows();
      final units = await JsonSeedLoader.unitsRows();

      expect(bundle.categories, hasLength(19));
      expect(bundle.subcategories, hasLength(greaterThanOrEqualTo(150)));
      expect(bundle.expressions, hasLength(greaterThanOrEqualTo(1200)));
      expect(bundle.dialogues, hasLength(greaterThanOrEqualTo(150)));
      expect(bundle.dialogueLines, hasLength(greaterThanOrEqualTo(1500)));
      expect(bundle.vocabularyEntries, hasLength(greaterThanOrEqualTo(200)));
      expect(
        bundle.vocabularyTranslations,
        hasLength(bundle.vocabularyEntries.length),
      );
      expect(
        bundle.vocabularyExamples,
        hasLength(bundle.vocabularyEntries.length),
      );
      expect(bundle.referenceEntries, hasLength(225));
      expect(signs, isNotEmpty);
      expect(units, isNotEmpty);
    },
  );

  test('all categories have linked seed-folder content', () async {
    final bundle = await JsonSeedLoader.load();
    for (final category in bundle.categories) {
      final id = category['id'];
      expect(
        bundle.subcategories.where((row) => row['category_id'] == id),
        isNotEmpty,
      );
      final expressions = bundle.expressions.where(
        (row) => row['category_id'] == id,
      );
      final dialogues = bundle.dialogues.where(
        (row) => row['category_id'] == id,
      );
      final vocabulary = bundle.categoryVocabulary.where(
        (row) => row['category_id'] == id,
      );
      expect(
        expressions.isNotEmpty || dialogues.isNotEmpty || vocabulary.isNotEmpty,
        isTrue,
      );
    }
  });

  test('seed-folder rows have stable unique primary keys', () async {
    final bundle = await JsonSeedLoader.load();

    int duplicates(Iterable<Object?> values) {
      final seen = <String>{};
      return values.where((value) => !seen.add('$value')).length;
    }

    expect(duplicates(bundle.categories.map((row) => row['id'])), 0);
    expect(duplicates(bundle.subcategories.map((row) => row['id'])), 0);
    expect(duplicates(bundle.expressions.map((row) => row['id'])), 0);
    expect(duplicates(bundle.dialogues.map((row) => row['id'])), 0);
    expect(duplicates(bundle.dialogueLines.map((row) => row['id'])), 0);
    expect(duplicates(bundle.vocabularyEntries.map((row) => row['id'])), 0);
    expect(duplicates(bundle.referenceEntries.map((row) => row['id'])), 0);
  });

  test('authored JSON seed content is searchable in both languages', () async {
    final bundle = await JsonSeedLoader.load();

    final englishHits = bundle.vocabularyEntries
        .where((row) => '${row['english_headword']}'.contains('appointment'))
        .toList();
    final somaliHits = bundle.vocabularyTranslations
        .where((row) => '${row['somali_headword']}'.contains('ballan'))
        .toList();
    final vocabularyHits = bundle.vocabularyEntries
        .where(
          (row) =>
              '${row['english_headword']}'.toLowerCase().contains('restaurant'),
        )
        .toList();

    expect(englishHits, isNotEmpty);
    expect(somaliHits, isNotEmpty);
    expect(vocabularyHits, isNotEmpty);
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
              englishTitle: 'Language Barrier',
              somaliTitle: 'Caqabadda Luqadda',
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
    expect(find.text('Language Barrier'), findsOneWidget);
    expect(find.textContaining('expressions'), findsOneWidget);
  });

  testWidgets('splash renders branding image and navigates without errors', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final router = GoRouter(
      initialLocation: OnboardingFeature.splashRoute,
      routes: [
        GoRoute(
          path: OnboardingFeature.splashRoute,
          builder: (_, _) => const SplashScreen(),
        ),
        GoRoute(
          path: OnboardingFeature.onboardingRoute,
          builder: (_, _) => const Scaffold(body: Text('Onboarding')),
        ),
        GoRoute(
          path: HomeFeature.route,
          builder: (_, _) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [repositoryProvider.overrideWithValue(_FakeRepository())],
        child: MaterialApp.router(
          theme: AppTheme.build(Brightness.light),
          routerConfig: router,
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Onboarding'), findsOneWidget);
  });
}

void _noop() {}

class _FakeRepository extends PhrasebookRepository {
  _FakeRepository() : super(PhrasebookDatabase());

  @override
  Future<List<Map<String, Object?>>> categories() async => const [];
}
