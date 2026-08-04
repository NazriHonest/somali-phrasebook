import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'phrasebook_database.dart';

final databaseProvider = Provider<PhrasebookDatabase>(
  (ref) => PhrasebookDatabase(),
);

final repositoryProvider = Provider<PhrasebookRepository>((ref) {
  return PhrasebookRepository(ref.watch(databaseProvider));
});

class PhrasebookRepository {
  const PhrasebookRepository(this._database);

  final PhrasebookDatabase _database;

  Future<Database> get _db => _database.database;

  Future<List<Map<String, Object?>>> categories() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT c.*,
        (SELECT COUNT(*) FROM expressions e WHERE e.category_id = c.id) AS expression_count,
        (SELECT COUNT(*) FROM dialogues d WHERE d.category_id = c.id) AS dialogue_count
      FROM categories c
      WHERE c.is_active = 1
      ORDER BY c.sort_order
    ''');
  }

  Future<Map<String, Object?>?> category(String id) async => _one(
    'SELECT * FROM categories WHERE id = ? OR code = ?',
    [id, id.replaceFirst('cat_', '')],
  );

  Future<List<Map<String, Object?>>> expressions(String categoryId) async {
    final db = await _db;
    return db.query(
      'expressions',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'sort_order',
    );
  }

  Future<List<Map<String, Object?>>> subcategories(String categoryId) async {
    final db = await _db;
    return db.query(
      'subcategories',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'sort_order',
    );
  }

  Future<Map<String, Object?>?> expression(String id) async =>
      _one('SELECT * FROM expressions WHERE id = ?', [id]);

  Future<Map<String, Object?>?> expressionExample(
    String expressionId,
  ) async => _one(
    'SELECT * FROM expression_examples WHERE expression_id = ? ORDER BY sort_order LIMIT 1',
    [expressionId],
  );

  Future<List<Map<String, Object?>>> dialogues(String categoryId) async {
    final db = await _db;
    return db.query(
      'dialogues',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'sort_order',
    );
  }

  Future<Map<String, Object?>?> dialogue(String id) async =>
      _one('SELECT * FROM dialogues WHERE id = ?', [id]);

  Future<List<Map<String, Object?>>> dialogueLines(String dialogueId) async {
    final db = await _db;
    return db.query(
      'dialogue_lines',
      where: 'dialogue_id = ?',
      whereArgs: [dialogueId],
      orderBy: 'line_order',
    );
  }

  Future<List<Map<String, Object?>>> qaPairs(String categoryId) async {
    final db = await _db;
    return db.query(
      'question_answer_pairs',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'sort_order',
    );
  }

  Future<List<Map<String, Object?>>> vocabularyForCategory(
    String categoryId,
  ) async {
    final db = await _db;
    return db.rawQuery(
      '''
      SELECT v.*, t.somali_headword, t.somali_explanation, x.english_sentence, x.somali_sentence
      FROM vocabulary_entries v
      JOIN category_vocabulary cv ON cv.vocabulary_entry_id = v.id
      JOIN vocabulary_translations t ON t.vocabulary_entry_id = v.id AND t.is_primary = 1
      LEFT JOIN vocabulary_examples x ON x.vocabulary_entry_id = v.id AND x.sort_order = 1
      WHERE cv.category_id = ?
      ORDER BY v.alphabetical_key
    ''',
      [categoryId],
    );
  }

  Future<List<Map<String, Object?>>> englishWordlist({
    String query = '',
    String pos = '',
    String categoryId = '',
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <Object?>[];
    if (query.trim().isNotEmpty) {
      where.add('(v.english_headword LIKE ? OR t.somali_headword LIKE ?)');
      args.addAll(['%$query%', '%$query%']);
    }
    if (pos.isNotEmpty) {
      where.add('v.part_of_speech = ?');
      args.add(pos);
    }
    if (categoryId.isNotEmpty) {
      where.add(
        'EXISTS(SELECT 1 FROM category_vocabulary cv WHERE cv.vocabulary_entry_id = v.id AND cv.category_id = ?)',
      );
      args.add(categoryId);
    }
    return db.rawQuery('''
      SELECT v.*, t.somali_headword, t.somali_explanation, x.english_sentence, x.somali_sentence
      FROM vocabulary_entries v
      JOIN vocabulary_translations t ON t.vocabulary_entry_id = v.id AND t.is_primary = 1
      LEFT JOIN vocabulary_examples x ON x.vocabulary_entry_id = v.id AND x.sort_order = 1
      ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ORDER BY v.alphabetical_key
      LIMIT 250
    ''', args);
  }

  Future<List<Map<String, Object?>>> somaliWordlist({String query = ''}) async {
    final db = await _db;
    final normalized = _normalizeSomaliQuery(query);
    return db.rawQuery('''
      SELECT t.*, v.english_headword, v.part_of_speech, v.english_definition, x.english_sentence, x.somali_sentence
      FROM vocabulary_translations t
      JOIN vocabulary_entries v ON v.id = t.vocabulary_entry_id
      LEFT JOIN vocabulary_examples x ON x.vocabulary_entry_id = v.id AND x.sort_order = 1
      ${normalized.isEmpty ? '' : 'WHERE REPLACE(REPLACE(LOWER(t.somali_headword), "'
              '", ""), " ", "") LIKE ?'}
      ORDER BY t.somali_headword
      LIMIT 250
    ''', normalized.isEmpty ? [] : ['%$normalized%']);
  }

  Future<Map<String, Object?>?> vocabulary(String id) async => _one(
    '''
    SELECT v.*, t.somali_headword, t.somali_explanation, t.regional_variant,
      x.english_sentence, x.somali_sentence
    FROM vocabulary_entries v
    JOIN vocabulary_translations t ON t.vocabulary_entry_id = v.id AND t.is_primary = 1
    LEFT JOIN vocabulary_examples x ON x.vocabulary_entry_id = v.id AND x.sort_order = 1
    WHERE v.id = ?
  ''',
    [id],
  );

  Future<List<Map<String, Object?>>> signs() async {
    final db = await _db;
    return db.query('signs', orderBy: 'english_text');
  }

  Future<List<Map<String, Object?>>> units() async {
    final db = await _db;
    return db.query('units_of_measure', orderBy: 'unit_type, english_name');
  }

  Future<List<Map<String, Object?>>> search(String query) async {
    final db = await _db;
    final q = '%${query.trim()}%';
    if (query.trim().isEmpty) return [];
    await addSearchHistory(query);
    final rows = <Map<String, Object?>>[];
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT 'expression' AS type, id, english_text AS title, somali_text AS subtitle
      FROM expressions
      WHERE english_text LIKE ? OR somali_text LIKE ? OR search_text LIKE ?
      LIMIT 30
    ''',
        [q, q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT 'dialogue' AS type, id, english_title AS title, somali_title AS subtitle
      FROM dialogues
      WHERE english_title LIKE ? OR somali_title LIKE ? OR english_situation LIKE ? OR somali_situation LIKE ?
      LIMIT 30
    ''',
        [q, q, q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT DISTINCT 'dialogue_line' AS type, dialogue_id AS id, english_text AS title, somali_text AS subtitle
      FROM dialogue_lines
      WHERE english_text LIKE ? OR somali_text LIKE ?
      LIMIT 30
    ''',
        [q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT 'vocabulary' AS type, v.id, v.english_headword AS title, t.somali_headword AS subtitle
      FROM vocabulary_entries v
      JOIN vocabulary_translations t ON t.vocabulary_entry_id = v.id
      WHERE v.english_headword LIKE ? OR t.somali_headword LIKE ? OR v.english_definition LIKE ?
      LIMIT 50
    ''',
        [q, q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT 'sign' AS type, id, english_text AS title, somali_meaning AS subtitle
      FROM signs
      WHERE english_text LIKE ? OR somali_meaning LIKE ? OR somali_explanation LIKE ?
      LIMIT 20
    ''',
        [q, q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT type, id, english AS title, somali AS subtitle, explanation AS preview
      FROM reference_entries
      WHERE english LIKE ? OR somali LIKE ? OR explanation LIKE ? OR search_text LIKE ?
      LIMIT 50
    ''',
        [q, q, q, q],
      ),
    );
    rows.addAll(
      await db.rawQuery(
        '''
      SELECT 'category' AS type, id, english_title AS title, somali_title AS subtitle
      FROM categories
      WHERE english_title LIKE ? OR somali_title LIKE ? OR english_description LIKE ? OR somali_description LIKE ?
      LIMIT 20
    ''',
        [q, q, q, q],
      ),
    );
    return rows;
  }

  Future<void> toggleFavorite(String type, String itemId) async {
    final db = await _db;
    final existing = await db.query(
      'favorites',
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, itemId],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await db.delete(
        'favorites',
        where: 'item_type = ? AND item_id = ?',
        whereArgs: [type, itemId],
      );
      return;
    }
    await db.insert('favorites', {
      'id': 'fav_${type}_$itemId',
      'item_type': type,
      'item_id': itemId,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> isFavorite(String type, String itemId) async {
    final db = await _db;
    final rows = await db.query(
      'favorites',
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, itemId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> favorites() async {
    final db = await _db;
    return db.query('favorites', orderBy: 'created_at DESC');
  }

  Future<List<Map<String, Object?>>> favoriteItems() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT f.item_type, f.item_id, f.created_at,
        COALESCE(e.english_text, d.english_title, v.english_headword, c.english_title, s.english_text, r.english, f.item_id) AS title,
        COALESCE(e.somali_text, d.somali_title, vt.somali_headword, c.somali_title, s.somali_meaning, r.somali, '') AS subtitle
      FROM favorites f
      LEFT JOIN expressions e ON f.item_type = 'expression' AND e.id = f.item_id
      LEFT JOIN dialogues d ON f.item_type = 'dialogue' AND d.id = f.item_id
      LEFT JOIN vocabulary_entries v ON f.item_type = 'vocabulary' AND v.id = f.item_id
      LEFT JOIN vocabulary_translations vt ON vt.vocabulary_entry_id = v.id AND vt.is_primary = 1
      LEFT JOIN categories c ON f.item_type = 'category' AND c.id = f.item_id
      LEFT JOIN signs s ON f.item_type = 'sign' AND s.id = f.item_id
      LEFT JOIN reference_entries r ON f.item_type = r.type AND r.id = f.item_id
      WHERE title IS NOT NULL
      ORDER BY f.created_at DESC
    ''');
  }

  Future<void> markRecent(
    String type,
    String itemId,
    String title,
    String subtitle,
  ) async {
    final db = await _db;
    await db.insert('recent_items', {
      'id': 'recent_${type}_$itemId',
      'item_type': type,
      'item_id': itemId,
      'title': title,
      'subtitle': subtitle,
      'viewed_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> recent() async {
    final db = await _db;
    return db.query('recent_items', orderBy: 'viewed_at DESC', limit: 50);
  }

  Future<void> clearRecent() async => (await _db).delete('recent_items');

  Future<void> addSearchHistory(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;
    final db = await _db;
    await db.insert('search_history', {
      'id': 'search_${clean.toLowerCase().hashCode}',
      'query': clean,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearSearchHistory() async =>
      (await _db).delete('search_history');

  Future<List<Map<String, Object?>>> practiceQuestions({int limit = 10}) async {
    final db = await _db;
    return db.rawQuery(
      '''
      SELECT v.id, v.english_headword, t.somali_headword, x.english_sentence, x.somali_sentence
      FROM vocabulary_entries v
      JOIN vocabulary_translations t ON t.vocabulary_entry_id = v.id AND t.is_primary = 1
      LEFT JOIN vocabulary_examples x ON x.vocabulary_entry_id = v.id
      ORDER BY RANDOM()
      LIMIT ?
    ''',
      [limit],
    );
  }

  Future<void> savePracticeResult({
    required int correct,
    required int total,
  }) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    await db.insert('practice_sessions', {
      'id': 'session_${now.hashCode}',
      'started_at': now,
      'completed_at': now,
      'correct_count': correct,
      'total_count': total,
    });
  }

  Future<Map<String, int>> progressSummary() async {
    final db = await _db;
    final favoritesCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM favorites'),
        ) ??
        0;
    final recentCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM recent_items'),
        ) ??
        0;
    final sessions = await db.rawQuery(
      'SELECT SUM(correct_count) AS correct, SUM(total_count) AS total, COUNT(*) AS sessions FROM practice_sessions',
    );
    return {
      'favorites': favoritesCount,
      'recent': recentCount,
      'sessions': (sessions.first['sessions'] as int?) ?? 0,
      'correct': (sessions.first['correct'] as int?) ?? 0,
      'total': (sessions.first['total'] as int?) ?? 0,
    };
  }

  Future<Map<String, int>> counts() async {
    final db = await _db;
    Future<int> count(String table) async =>
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'),
        ) ??
        0;
    return {
      'categories': await count('categories'),
      'subcategories': await count('subcategories'),
      'expressions': await count('expressions'),
      'dialogues': await count('dialogues'),
      'dialogue_lines': await count('dialogue_lines'),
      'question_answer_pairs': await count('question_answer_pairs'),
      'vocabulary_entries': await count('vocabulary_entries'),
      'vocabulary_translations': await count('vocabulary_translations'),
      'vocabulary_examples': await count('vocabulary_examples'),
      'signs': await count('signs'),
      'reference_entries': await count('reference_entries'),
    };
  }

  Future<Map<String, Object?>?> _one(String sql, List<Object?> args) async {
    final db = await _db;
    final rows = await db.rawQuery(sql, args);
    return rows.isEmpty ? null : rows.first;
  }

  static String _normalizeSomaliQuery(String value) =>
      value.toLowerCase().replaceAll("'", '').replaceAll(' ', '').trim();
}
