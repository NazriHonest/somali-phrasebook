# Database Schema

Schema version: 1

Current seed version: 2

SQLite tables:

- `app_metadata`
- `categories`
- `subcategories`
- `expressions`
- `expression_examples`
- `dialogues`
- `dialogue_lines`
- `question_answer_pairs`
- `vocabulary_entries`
- `vocabulary_translations`
- `vocabulary_examples`
- `vocabulary_relations`
- `category_vocabulary`
- `expression_vocabulary`
- `dialogue_vocabulary`
- `signs`
- `units_of_measure`
- `number_lessons`
- `favorites`
- `recent_items`
- `bookmarks`
- `practice_sessions`
- `practice_questions`
- `practice_attempts`
- `search_history`
- `user_settings`

Foreign keys are enabled during database configuration. Seed content uses stable IDs and replace-on-conflict insertion. User state is stored separately so seed refreshes do not delete favorites, recents, bookmarks, settings, search history, or practice history.

When the app opens an existing database, it checks `app_metadata.seed_version`. If the stored value is older than the seed bundled with the app, only seed-owned tables are cleared and reinserted inside a transaction. User-progress tables are not part of the seed clear list.

Indexes exist for category ordering, category content lookup, dialogue line ordering, vocabulary alphabetical browsing, Somali translation browsing, and recent item sorting.
