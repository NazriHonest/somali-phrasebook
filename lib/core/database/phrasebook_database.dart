import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../data/seed/json_seed_loader.dart';

class PhrasebookDatabase {
  PhrasebookDatabase({this._databasePath});

  static const schemaVersion = 2;
  final String? _databasePath;
  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;
    final path =
        _databasePath ??
        p.join(await getDatabasesPath(), 'english_somali_phrasebook.db');
    return _db = await openDatabase(
      path,
      version: schemaVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await _createSchema(db);
        await seed(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < schemaVersion) await _createSchema(db);
        await seed(db);
      },
      onOpen: seed,
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<void> seed(Database db) async {
    final current = await db.query(
      'app_metadata',
      where: 'key = ?',
      whereArgs: ['seed_version'],
      limit: 1,
    );
    final currentVersion = current.isEmpty
        ? 0
        : int.tryParse('${current.first['value']}') ?? 0;
    if (currentVersion >= JsonSeedLoader.seedVersion) return;

    final seedBundle = await JsonSeedLoader.load();
    final signRows = await JsonSeedLoader.signRows();
    final unitRows = await JsonSeedLoader.unitsRows();

    await db.transaction((txn) async {
      await _clearSeedTables(txn);
      final batch = txn.batch();
      _insertAll(batch, 'categories', seedBundle.categories);
      _insertAll(batch, 'subcategories', seedBundle.subcategories);
      _insertAll(batch, 'expressions', seedBundle.expressions);
      _insertAll(batch, 'expression_examples', seedBundle.expressionExamples);
      _insertAll(batch, 'dialogues', seedBundle.dialogues);
      _insertAll(batch, 'dialogue_lines', seedBundle.dialogueLines);
      _insertAll(batch, 'question_answer_pairs', JsonSeedLoader.qaRows());
      _insertAll(batch, 'vocabulary_entries', seedBundle.vocabularyEntries);
      _insertAll(
        batch,
        'vocabulary_translations',
        seedBundle.vocabularyTranslations,
      );
      _insertAll(batch, 'vocabulary_examples', seedBundle.vocabularyExamples);
      _insertAll(batch, 'category_vocabulary', seedBundle.categoryVocabulary);
      _insertAll(batch, 'reference_entries', seedBundle.referenceEntries);
      _insertAll(batch, 'signs', signRows);
      _insertAll(batch, 'units_of_measure', unitRows);
      batch.insert('app_metadata', {
        'key': 'seed_version',
        'value': '${JsonSeedLoader.seedVersion}',
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      batch.insert('app_metadata', {
        'key': 'schema_version',
        'value': '$schemaVersion',
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await batch.commit(noResult: true);
    });
  }

  static void _insertAll(
    Batch batch,
    String table,
    List<Map<String, Object?>> rows,
  ) {
    for (final row in rows) {
      batch.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> _clearSeedTables(DatabaseExecutor db) async {
    for (final table in const [
      'category_vocabulary',
      'reference_entries',
      'expression_examples',
      'dialogue_lines',
      'question_answer_pairs',
      'vocabulary_examples',
      'vocabulary_translations',
      'vocabulary_relations',
      'signs',
      'units_of_measure',
      'expressions',
      'dialogues',
      'vocabulary_entries',
      'subcategories',
      'categories',
    ]) {
      await db.delete(table);
    }
  }

  static Future<void> _createSchema(Database db) async {
    final statements = [
      '''
      CREATE TABLE IF NOT EXISTS app_metadata(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS categories(
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL UNIQUE,
        english_title TEXT NOT NULL,
        somali_title TEXT NOT NULL,
        english_description TEXT NOT NULL,
        somali_description TEXT NOT NULL,
        icon_key TEXT NOT NULL,
        theme_key TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS subcategories(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        english_title TEXT NOT NULL,
        somali_title TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        UNIQUE(category_id, sort_order)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS expressions(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        subcategory_id TEXT REFERENCES subcategories(id) ON DELETE SET NULL,
        english_text TEXT NOT NULL,
        somali_text TEXT NOT NULL,
        somali_alternative TEXT NOT NULL DEFAULT '',
        usage_explanation TEXT NOT NULL,
        context TEXT NOT NULL,
        formality TEXT NOT NULL,
        pronunciation TEXT NOT NULL DEFAULT '',
        difficulty TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        search_text TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(category_id, english_text)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS expression_examples(
        id TEXT PRIMARY KEY,
        expression_id TEXT NOT NULL REFERENCES expressions(id) ON DELETE CASCADE,
        english_sentence TEXT NOT NULL,
        somali_sentence TEXT NOT NULL,
        sort_order INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS dialogues(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        subcategory_id TEXT REFERENCES subcategories(id) ON DELETE SET NULL,
        code TEXT NOT NULL UNIQUE,
        english_title TEXT NOT NULL,
        somali_title TEXT NOT NULL,
        english_situation TEXT NOT NULL,
        somali_situation TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS dialogue_lines(
        id TEXT PRIMARY KEY,
        dialogue_id TEXT NOT NULL REFERENCES dialogues(id) ON DELETE CASCADE,
        speaker TEXT NOT NULL,
        english_text TEXT NOT NULL,
        somali_text TEXT NOT NULL,
        usage_note TEXT NOT NULL DEFAULT '',
        line_order INTEGER NOT NULL,
        UNIQUE(dialogue_id, line_order)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS question_answer_pairs(
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        subcategory_id TEXT REFERENCES subcategories(id) ON DELETE SET NULL,
        english_question TEXT NOT NULL,
        somali_question TEXT NOT NULL,
        english_answer TEXT NOT NULL,
        somali_answer TEXT NOT NULL,
        alternative_answer TEXT NOT NULL DEFAULT '',
        usage_note TEXT NOT NULL DEFAULT '',
        related_vocabulary TEXT NOT NULL DEFAULT '',
        sort_order INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS vocabulary_entries(
        id TEXT PRIMARY KEY,
        english_headword TEXT NOT NULL,
        part_of_speech TEXT NOT NULL,
        english_definition TEXT NOT NULL,
        plural_form TEXT NOT NULL DEFAULT '',
        past_form TEXT NOT NULL DEFAULT '',
        past_participle TEXT NOT NULL DEFAULT '',
        comparative_form TEXT NOT NULL DEFAULT '',
        superlative_form TEXT NOT NULL DEFAULT '',
        frequency TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        pronunciation TEXT NOT NULL DEFAULT '',
        usage_notes TEXT NOT NULL DEFAULT '',
        alphabetical_key TEXT NOT NULL,
        metadata_json TEXT NOT NULL DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(english_headword, part_of_speech)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS vocabulary_translations(
        id TEXT PRIMARY KEY,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        somali_headword TEXT NOT NULL,
        somali_explanation TEXT NOT NULL,
        regional_variant TEXT NOT NULL DEFAULT '',
        is_primary INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS vocabulary_examples(
        id TEXT PRIMARY KEY,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        english_sentence TEXT NOT NULL,
        somali_sentence TEXT NOT NULL,
        context TEXT NOT NULL DEFAULT '',
        sort_order INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS vocabulary_relations(
        id TEXT PRIMARY KEY,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        related_vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        relation_type TEXT NOT NULL CHECK(relation_type IN ('synonym','antonym','related_word','see_also','commonly_confused')),
        UNIQUE(vocabulary_entry_id, related_vocabulary_entry_id, relation_type)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS category_vocabulary(
        category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        PRIMARY KEY(category_id, vocabulary_entry_id)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS expression_vocabulary(
        expression_id TEXT NOT NULL REFERENCES expressions(id) ON DELETE CASCADE,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        PRIMARY KEY(expression_id, vocabulary_entry_id)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS dialogue_vocabulary(
        dialogue_id TEXT NOT NULL REFERENCES dialogues(id) ON DELETE CASCADE,
        vocabulary_entry_id TEXT NOT NULL REFERENCES vocabulary_entries(id) ON DELETE CASCADE,
        PRIMARY KEY(dialogue_id, vocabulary_entry_id)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS signs(
        id TEXT PRIMARY KEY,
        english_text TEXT NOT NULL,
        somali_meaning TEXT NOT NULL,
        somali_explanation TEXT NOT NULL,
        category TEXT NOT NULL,
        icon_key TEXT NOT NULL,
        seen_at TEXT NOT NULL DEFAULT ''
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS units_of_measure(
        id TEXT PRIMARY KEY,
        english_name TEXT NOT NULL,
        somali_name TEXT NOT NULL,
        unit_type TEXT NOT NULL,
        explanation TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS reference_entries(
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        english TEXT NOT NULL,
        somali TEXT NOT NULL,
        explanation TEXT NOT NULL,
        example_english TEXT NOT NULL DEFAULT '',
        example_somali TEXT NOT NULL DEFAULT '',
        answer_example_english TEXT NOT NULL DEFAULT '',
        answer_example_somali TEXT NOT NULL DEFAULT '',
        context TEXT NOT NULL DEFAULT '',
        register TEXT NOT NULL DEFAULT '',
        tags_json TEXT NOT NULL DEFAULT '[]',
        search_text TEXT NOT NULL,
        sort_order INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS number_lessons(
        id TEXT PRIMARY KEY,
        english_title TEXT NOT NULL,
        somali_title TEXT NOT NULL,
        explanation TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS favorites(
        id TEXT PRIMARY KEY,
        item_type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(item_type, item_id)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS recent_items(
        id TEXT PRIMARY KEY,
        item_type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        viewed_at TEXT NOT NULL,
        UNIQUE(item_type, item_id)
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS bookmarks(
        id TEXT PRIMARY KEY,
        item_type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS practice_sessions(
        id TEXT PRIMARY KEY,
        started_at TEXT NOT NULL,
        completed_at TEXT,
        correct_count INTEGER NOT NULL DEFAULT 0,
        total_count INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS practice_questions(
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL REFERENCES practice_sessions(id) ON DELETE CASCADE,
        question_type TEXT NOT NULL,
        prompt TEXT NOT NULL,
        correct_answer TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS practice_attempts(
        id TEXT PRIMARY KEY,
        question_id TEXT NOT NULL REFERENCES practice_questions(id) ON DELETE CASCADE,
        selected_answer TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS search_history(
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
      ''',
      '''
      CREATE TABLE IF NOT EXISTS user_settings(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
      ''',
    ];
    for (final statement in statements) {
      await db.execute(statement);
    }
    for (final index in const [
      'CREATE INDEX IF NOT EXISTS idx_categories_order ON categories(sort_order)',
      'CREATE INDEX IF NOT EXISTS idx_expressions_category ON expressions(category_id, sort_order)',
      'CREATE INDEX IF NOT EXISTS idx_dialogues_category ON dialogues(category_id, sort_order)',
      'CREATE INDEX IF NOT EXISTS idx_dialogue_lines_order ON dialogue_lines(dialogue_id, line_order)',
      'CREATE INDEX IF NOT EXISTS idx_qa_category ON question_answer_pairs(category_id, sort_order)',
      'CREATE INDEX IF NOT EXISTS idx_vocab_alpha ON vocabulary_entries(alphabetical_key)',
      'CREATE INDEX IF NOT EXISTS idx_vocab_translation ON vocabulary_translations(somali_headword)',
      'CREATE INDEX IF NOT EXISTS idx_reference_type ON reference_entries(type, sort_order)',
      'CREATE INDEX IF NOT EXISTS idx_recent_time ON recent_items(viewed_at)',
    ]) {
      await db.execute(index);
    }
  }
}
