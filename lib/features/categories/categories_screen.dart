import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../dialogues/dialogues_feature.dart';
import '../expressions/expressions_feature.dart';
import '../home/home_feature.dart';
import '../search/search_feature.dart';
import '../vocabulary/vocabulary_feature.dart';
import 'categories_feature.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).categories(),
    builder: (context, rows) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(HomeFeature.route),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push(SearchFeature.route),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final row = rows[index];
          return CategoryGridCard(
            index: index + 1,
            icon: iconFor('${row['icon_key']}'),
            title: _compactCategoryTitle('${row['english_title']}'),
            countLabel: _countLabel(
              row['expression_count'] as int? ?? 0,
              row['dialogue_count'] as int? ?? 0,
              '${row['english_title']}',
            ),
            onTap: () =>
                context.push(CategoriesFeature.detailPath('${row['id']}')),
          );
        },
      ),
    ),
  );
}

class CategoryGridCard extends StatelessWidget {
  const CategoryGridCard({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.countLabel,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String title;
  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.phrasebook.categoryTiles;
    final tone = colors[(index - 1).clamp(0, colors.length - 1)];
    return UiCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index',
            style: theme.textTheme.labelLarge?.copyWith(
              color: tone,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Center(child: Icon(icon, color: tone, size: 28)),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              countLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySubcategoryCard extends StatelessWidget {
  const _CategorySubcategoryCard({
    required this.title,
    required this.itemCount,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final int itemCount;
  final IconData icon;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          IconBox(
            icon: icon,
            backgroundColor: tone.withValues(alpha: 0.12),
            iconColor: tone,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text('$itemCount items', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class CategoryDetailScreen extends ConsumerStatefulWidget {
  const CategoryDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).category(widget.id),
      ref.read(repositoryProvider).subcategories(widget.id),
      ref.read(repositoryProvider).expressions(widget.id),
      ref.read(repositoryProvider).dialogues(widget.id),
      ref.read(repositoryProvider).qaPairs(widget.id),
      ref.read(repositoryProvider).vocabularyForCategory(widget.id),
      ref.read(repositoryProvider).isFavorite('category', widget.id),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final category = data[0] as Map<String, Object?>?;
      if (category == null) return const MissingScaffold();
      final subcategories = data[1] as List<Map<String, Object?>>;
      final expressions = data[2] as List<Map<String, Object?>>;
      final dialogues = data[3] as List<Map<String, Object?>>;
      final qa = data[4] as List<Map<String, Object?>>;
      final vocabulary = data[5] as List<Map<String, Object?>>;
      final visibleSubcategories = subcategories.where((subcategory) {
        final subId = subcategory['id'];
        return expressions.any((row) => row['subcategory_id'] == subId) ||
            dialogues.any((row) => row['subcategory_id'] == subId) ||
            qa.any((row) => row['subcategory_id'] == subId) ||
            vocabulary.any((row) => row['subcategory_id'] == subId);
      }).toList();
      ref
          .watch(repositoryProvider)
          .markRecent(
            'category',
            '${category['id']}',
            '${category['english_title']}',
            '${category['somali_title']}',
          );
      final theme = Theme.of(context);
      final title = _displayCategoryTitle('${category['english_title']}');
      final tone =
          theme.phrasebook.categoryTiles[((category['sort_order'] as int? ??
                      1) -
                  1)
              .clamp(0, theme.phrasebook.categoryTiles.length - 1)];
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left),
          ),
          title: Text(title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => SharePlus.instance.share(
                ShareParams(
                  text:
                      '$title\n${category['english_description']}\n${category['somali_title']}',
                ),
              ),
              icon: const Icon(Icons.share_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            CategoryHeroArt(
              icon: _categoryDisplayIcon(
                '${category['english_title']}',
                '${category['icon_key']}',
              ),
              tone: tone,
              imageAsset: _categoryHeroAsset(category),
              height: 165,
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < visibleSubcategories.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CategorySubcategoryCard(
                  title: '${visibleSubcategories[i]['english_title']}',
                  itemCount: _subcategoryItemCount(
                    '${visibleSubcategories[i]['id']}',
                    expressions,
                    dialogues,
                    qa,
                    vocabulary,
                  ),
                  icon: subcategoryIconFor(
                    '${visibleSubcategories[i]['english_title']} ${category['english_title']}',
                  ),
                  tone: theme
                      .phrasebook
                      .categoryTiles[i % theme.phrasebook.categoryTiles.length],
                  onTap: () => context.push(
                    CategoriesFeature.subcategoryPath(
                      '${category['id']}',
                      '${visibleSubcategories[i]['id']}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class SubcategoryContentScreen extends ConsumerStatefulWidget {
  const SubcategoryContentScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
  });

  final String categoryId;
  final String subcategoryId;

  @override
  ConsumerState<SubcategoryContentScreen> createState() =>
      _SubcategoryContentScreenState();
}

class _SubcategoryContentScreenState
    extends ConsumerState<SubcategoryContentScreen> {
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).category(widget.categoryId),
      ref.read(repositoryProvider).subcategories(widget.categoryId),
      ref.read(repositoryProvider).expressions(widget.categoryId),
      ref.read(repositoryProvider).dialogues(widget.categoryId),
      ref.read(repositoryProvider).qaPairs(widget.categoryId),
      ref.read(repositoryProvider).vocabularyForCategory(widget.categoryId),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final category = data[0] as Map<String, Object?>?;
      if (category == null) return const MissingScaffold();
      final subcategories = data[1] as List<Map<String, Object?>>;
      final subcategory = subcategories.firstWhere(
        (row) => row['id'] == widget.subcategoryId,
        orElse: () => const <String, Object?>{},
      );
      if (subcategory.isEmpty) return const MissingScaffold();
      final expressions = (data[2] as List<Map<String, Object?>>)
          .where((row) => row['subcategory_id'] == widget.subcategoryId)
          .toList();
      final dialogues = (data[3] as List<Map<String, Object?>>)
          .where((row) => row['subcategory_id'] == widget.subcategoryId)
          .toList();
      final qa = (data[4] as List<Map<String, Object?>>)
          .where((row) => row['subcategory_id'] == widget.subcategoryId)
          .toList();
      final vocabulary = (data[5] as List<Map<String, Object?>>)
          .where((row) => row['subcategory_id'] == widget.subcategoryId)
          .toList();
      final theme = Theme.of(context);
      final tone =
          theme.phrasebook.categoryTiles[((category['sort_order'] as int? ??
                      1) -
                  1)
              .clamp(0, theme.phrasebook.categoryTiles.length - 1)];
      final tiles = <_ContentTypeTileData>[
        if (vocabulary.isNotEmpty)
          _ContentTypeTileData(
            icon: Icons.bookmark,
            title: 'Vocabulary',
            subtitle: '${vocabulary.length} words',
            tone: theme.phrasebook.categoryTiles[3],
            onTap: () => context.push(
              VocabularyFeature.detailPath('${vocabulary.first['id']}'),
            ),
          ),
        if (expressions.isNotEmpty)
          _ContentTypeTileData(
            icon: Icons.notes_outlined,
            title: 'Phrases',
            subtitle: '${expressions.length} phrases',
            tone: theme.phrasebook.categoryTiles[0],
            onTap: () => context.push(
              ExpressionsFeature.listPath(
                widget.categoryId,
                widget.subcategoryId,
              ),
            ),
          ),
        if (dialogues.isNotEmpty)
          _ContentTypeTileData(
            icon: Icons.forum,
            title: 'Conversations',
            subtitle: '${dialogues.length} conversations',
            tone: theme.phrasebook.categoryTiles[4],
            onTap: () => dialogues.length == 1
                ? context.push(
                    DialoguesFeature.detailPath('${dialogues.first['id']}'),
                  )
                : context.push(DialoguesFeature.listPath(widget.categoryId)),
          ),
        if (qa.isNotEmpty)
          _ContentTypeTileData(
            icon: Icons.help_outline,
            title: 'Common Questions',
            subtitle: '${qa.length} questions',
            tone: theme.phrasebook.categoryTiles[5],
            onTap: () => context.push(
              ExpressionsFeature.listPath(
                widget.categoryId,
                widget.subcategoryId,
              ),
            ),
          ),
      ];
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left),
          ),
          title: Column(
            children: [
              Text(
                '${subcategory['english_title']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Choose what you want to explore',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            CategoryHeroArt(
              icon: subcategoryIconFor(
                '${subcategory['english_title']} ${category['english_title']}',
              ),
              tone: tone,
              imageAsset: _categoryHeroAsset(category),
              height: 132,
            ),
            const SizedBox(height: 14),
            for (final tile in tiles)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ContentTypeTile(data: tile),
              ),
          ],
        ),
      );
    },
  );
}

class _ContentTypeTileData {
  const _ContentTypeTileData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;
  final VoidCallback onTap;
}

class _ContentTypeTile extends StatelessWidget {
  const _ContentTypeTile({required this.data});

  final _ContentTypeTileData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      onTap: data.onTap,
      child: Row(
        children: [
          IconBox(
            icon: data.icon,
            backgroundColor: data.tone.withValues(alpha: 0.12),
            iconColor: data.tone,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(data.subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class CategoryExpressionsScreen extends ConsumerStatefulWidget {
  const CategoryExpressionsScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
  });

  final String categoryId;
  final String subcategoryId;

  @override
  ConsumerState<CategoryExpressionsScreen> createState() =>
      _CategoryExpressionsScreenState();
}

class _CategoryExpressionsScreenState
    extends ConsumerState<CategoryExpressionsScreen> {
  int selectedTab = 0;
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).category(widget.categoryId),
      ref.read(repositoryProvider).expressions(widget.categoryId),
      ref.read(repositoryProvider).qaPairs(widget.categoryId),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final category = data[0] as Map<String, Object?>?;
      if (category == null) return const MissingScaffold();
      final allExpressions = data[1] as List<Map<String, Object?>>;
      final qa = data[2] as List<Map<String, Object?>>;
      final expressions = widget.subcategoryId.isEmpty
          ? allExpressions
          : allExpressions
                .where((row) => row['subcategory_id'] == widget.subcategoryId)
                .toList();
      final filteredQa = widget.subcategoryId.isEmpty
          ? qa
          : qa
                .where((row) => row['subcategory_id'] == widget.subcategoryId)
                .toList();
      final allCards = [
        ...expressions.map((row) => _ExpressionListItem.expression(row)),
        ...filteredQa.map((row) => _ExpressionListItem.qa(row)),
      ];
      final tabs = [
        'All',
        if (expressions.isNotEmpty) 'Expressions',
        if (filteredQa.isNotEmpty) 'Questions',
        if (expressions.any((row) => row['formality'] == 'polite')) 'Polite',
      ];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
      final selected = tabs[selectedTab];
      final cards = switch (selected) {
        'Expressions' =>
          expressions
              .map((row) => _ExpressionListItem.expression(row))
              .toList(),
        'Questions' =>
          filteredQa.map((row) => _ExpressionListItem.qa(row)).toList(),
        'Polite' =>
          expressions
              .where((row) => row['formality'] == 'polite')
              .map((row) => _ExpressionListItem.expression(row))
              .toList(),
        _ => allCards,
      };
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
                    theme.phrasebook.greenHeaderEnd,
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
                              _shortTitle('${category['english_title']}'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${category['somali_title']}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(SearchFeature.route),
                        icon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: InlineTabBar(
                tabs: tabs,
                selectedIndex: selectedTab,
                onSelected: (index) => setState(() => selectedTab = index),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                itemCount: cards.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = cards[index];
                  return ExpressionCard(
                    id: item.expressionId,
                    english: item.english,
                    somali: item.somali,
                    chips: item.chips,
                    onTap: item.expressionId == null
                        ? null
                        : () => context.push(
                            ExpressionsFeature.detailPath(item.expressionId!),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class CategoryListCard extends StatelessWidget {
  const CategoryListCard({
    super.key,
    this.index,
    required this.icon,
    required this.englishTitle,
    required this.somaliTitle,
    required this.description,
    required this.expressionCount,
    required this.dialogueCount,
    required this.onTap,
  });

  final int? index;
  final IconData icon;
  final String englishTitle;
  final String somaliTitle;
  final String description;
  final int expressionCount;
  final int dialogueCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.phrasebook.categoryTiles;
    final tileColor = colors[((index ?? 1) - 1).clamp(0, colors.length - 1)];
    return UiCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        children: [
          IconBox(icon: icon, backgroundColor: tileColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == null ? englishTitle : '$index. $englishTitle',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _countLabel(expressionCount, dialogueCount, englishTitle),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.items});
  final List<StatSummary> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            for (final item in items) ...[
              Expanded(
                child: Column(
                  children: [
                    Text(
                      item.value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.label, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              if (item != items.last)
                SizedBox(
                  height: 32,
                  child: VerticalDivider(color: theme.phrasebook.cardBorder),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatSummary {
  const StatSummary(this.value, this.label);
  final String value;
  final String label;
}

class SubcategoryTile extends StatelessWidget {
  const SubcategoryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: theme.phrasebook.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class CategoryDialogueListScreen extends ConsumerStatefulWidget {
  const CategoryDialogueListScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  ConsumerState<CategoryDialogueListScreen> createState() =>
      _CategoryDialogueListScreenState();
}

class _CategoryDialogueListScreenState
    extends ConsumerState<CategoryDialogueListScreen> {
  int selectedTab = 0;
  late final Future<List<Object?>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait<Object?>([
      ref.read(repositoryProvider).category(widget.categoryId),
      ref.read(repositoryProvider).dialogues(widget.categoryId),
    ]);
  }

  @override
  Widget build(BuildContext context) => FutureView(
    future: _future,
    builder: (context, data) {
      final category = data[0] as Map<String, Object?>?;
      if (category == null) return const MissingScaffold();
      final dialogues = data[1] as List<Map<String, Object?>>;
      final levels = dialogues
          .map((row) => '${row['difficulty']}')
          .where((value) => value.trim().isNotEmpty)
          .toSet()
          .toList();
      final tabs = ['All', ...levels];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
      final selected = tabs[selectedTab];
      final rows = selected == 'All'
          ? dialogues
          : dialogues
                .where((row) => '${row['difficulty']}' == selected)
                .toList();
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
                    theme.phrasebook.greenHeaderEnd,
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
                              '${category['english_title']} Dialogues',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${category['somali_title']}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push(SearchFeature.route),
                        icon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: InlineTabBar(
                tabs: tabs,
                selectedIndex: selectedTab,
                onSelected: (index) => setState(() => selectedTab = index),
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const EmptyState(message: 'No dialogues in this filter.')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => DialogueSummaryCard(
                        dialogue: rows[index],
                        onTap: () => context.push(
                          DialoguesFeature.detailPath('${rows[index]['id']}'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

class DialogueSummaryCard extends StatelessWidget {
  const DialogueSummaryCard({
    super.key,
    required this.dialogue,
    required this.onTap,
  });

  final Map<String, Object?> dialogue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(
            icon: Icons.forum,
            backgroundColor: theme.phrasebook.categoryTiles[8],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dialogue['english_title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${dialogue['somali_title']}',
                  style: TextStyle(
                    color: theme.phrasebook.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${dialogue['english_situation']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                PillLabel(label: '${dialogue['difficulty']}'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class ExpressionCard extends StatelessWidget {
  const ExpressionCard({
    super.key,
    required this.id,
    required this.english,
    required this.somali,
    required this.chips,
    this.onTap,
  });

  final String? id;
  final String english;
  final String somali;
  final List<String> chips;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UiCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  english,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  somali,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.phrasebook.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final chip in chips)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.phrasebook.infoSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(chip, style: theme.textTheme.labelSmall),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              if (id == null)
                Icon(
                  Icons.star_border,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              else
                _ExpressionFavoriteButton(id: id!),
              const SizedBox(height: 18),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpressionFavoriteButton extends ConsumerStatefulWidget {
  const _ExpressionFavoriteButton({required this.id});

  final String id;

  @override
  ConsumerState<_ExpressionFavoriteButton> createState() =>
      _ExpressionFavoriteButtonState();
}

class _ExpressionFavoriteButtonState
    extends ConsumerState<_ExpressionFavoriteButton> {
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<bool> _load() =>
      ref.read(repositoryProvider).isFavorite('expression', widget.id);

  Future<void> _toggle() async {
    await ref.read(repositoryProvider).toggleFavorite('expression', widget.id);
    if (!mounted) return;
    final favorite = await _load();
    if (!mounted) return;
    setState(() => _future = Future.value(favorite));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          favorite ? 'Added to favorites' : 'Removed from favorites',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        final favorite = snapshot.data ?? false;
        return IconButton(
          tooltip: favorite ? 'Remove from favorites' : 'Add to favorites',
          onPressed: _toggle,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            favorite ? Icons.star : Icons.star_border,
            color: favorite
                ? theme.phrasebook.favorite
                : theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }
}

class _ExpressionListItem {
  const _ExpressionListItem({
    required this.english,
    required this.somali,
    required this.chips,
    this.expressionId,
  });

  factory _ExpressionListItem.expression(Map<String, Object?> row) =>
      _ExpressionListItem(
        english: '${row['english_text']}',
        somali: '${row['somali_text']}',
        chips: ['${row['formality']}', '${row['difficulty']}'],
        expressionId: '${row['id']}',
      );

  factory _ExpressionListItem.qa(Map<String, Object?> row) =>
      _ExpressionListItem(
        english: '${row['english_question']}',
        somali: '${row['somali_question']}',
        chips: const ['Question', 'A1'],
      );

  final String english;
  final String somali;
  final List<String> chips;
  final String? expressionId;
}

String _countLabel(int expressionCount, int dialogueCount, String title) {
  if (title.contains('Signs')) return '$expressionCount signs';
  if (title.contains('Measures')) return '$expressionCount items';
  return '$expressionCount expressions • $dialogueCount dialogues';
}

String _shortTitle(String title) {
  if (title == 'Food') return 'Grocery Shopping';
  return title.replaceFirst('Coping with the ', '');
}

String _displayCategoryTitle(String title) => title
    .replaceFirst('Coping with the Language Barrier', 'Travel')
    .replaceFirst('Useful Forms of Etiquette', 'Health')
    .replaceFirst('Giving Information About Yourself', 'People')
    .replaceFirst('Recognizing Signs', 'Services')
    .replaceFirst('Weights and Measures', 'Shopping')
    .replaceFirst('Using Numbers', 'Money')
    .replaceFirst('Dealing with Time', 'Time')
    .replaceFirst('About Schools', 'Education');

IconData _categoryDisplayIcon(String title, String iconKey) {
  final display = _displayCategoryTitle(title).toLowerCase();
  if (display == 'travel') return Icons.flight;
  if (display == 'health') return Icons.health_and_safety;
  if (display == 'food') return Icons.restaurant;
  if (display == 'shopping') return Icons.shopping_bag;
  if (display == 'accommodation') return Icons.bed;
  if (display == 'money') return Icons.payments;
  if (display == 'education') return Icons.school;
  if (display == 'people') return Icons.groups;
  return iconFor(iconKey);
}

String? _categoryHeroAsset(Map<String, Object?> category) {
  final code = '${category['code']}';
  final assetName = switch (code) {
    'language_barrier' => 'Language and Barrier.png',
    'greetings_etiquette' => 'Greetings.png',
    'personal_information' => 'Personal Information.png',
    'public_signs' => 'Public Signs.png',
    'measurements' => 'Measurements.png',
    'numbers' => 'Numbers.png',
    'money' => 'Money.png',
    'time' => 'Time.png',
    'locations' => 'Locations.png',
    'daily_activities' => 'Daily Activities.png',
    'transportation' => 'Travel.png',
    'communication' => 'Communications.png',
    'health' => 'Health.png',
    'food' => 'Food and Dining.png',
    'clothing' => 'Clothing.png',
    'housing' => 'Housing.png',
    'jobs' => 'Jobs.png',
    'school' => 'School.png',
    'descriptions' => 'Shopping.png',
    _ => '',
  };
  return assetName.isEmpty ? null : 'assets/hero_images/$assetName';
}

int _subcategoryItemCount(
  String subcategoryId,
  List<Map<String, Object?>> expressions,
  List<Map<String, Object?>> dialogues,
  List<Map<String, Object?>> qa,
  List<Map<String, Object?>> vocabulary,
) {
  bool matches(Map<String, Object?> row) =>
      row['subcategory_id'] == subcategoryId;
  return expressions.where(matches).length +
      dialogues.where(matches).length +
      qa.where(matches).length +
      vocabulary.where(matches).length;
}

String _compactCategoryTitle(String title) {
  return title
      .replaceFirst('Coping with the ', '')
      .replaceFirst('Useful Forms of ', '')
      .replaceFirst('Giving Information About Yourself', 'Personal Information')
      .replaceFirst('Dealing with ', '')
      .replaceFirst(
        'Describing Things and People',
        'Describing Things and People',
      )
      .replaceFirst('About Schools', 'Schools');
}
