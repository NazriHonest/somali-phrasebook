import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class CategoryDetailScreen extends ConsumerStatefulWidget {
  const CategoryDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  int selectedTab = 0;
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
      final favorite = data[6] as bool;
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
      final tabs = [
        'All',
        if (expressions.isNotEmpty) 'Expressions',
        if (dialogues.isNotEmpty) 'Dialogs',
        if (qa.isNotEmpty) 'Q & A',
        if (vocabulary.isNotEmpty) 'Vocab',
      ];
      selectedTab = selectedTab.clamp(0, tabs.length - 1);
      return Scaffold(
        body: Column(
          children: [
            BlueHeader(
              title: '${category['sort_order']}. ${category['english_title']}',
              subtitle: '${category['english_description']}',
              headerStart: theme.phrasebook.greenHeaderStart,
              headerEnd: theme.phrasebook.greenHeaderEnd,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              trailing: IconButton(
                onPressed: () => ref
                    .read(repositoryProvider)
                    .toggleFavorite('category', '${category['id']}'),
                icon: Icon(
                  favorite ? Icons.bookmark : Icons.bookmark_border,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              child: StatsCard(
                items: [
                  StatSummary('${subcategories.length}', 'Subcategories'),
                  StatSummary('${expressions.length}', 'Expressions'),
                  StatSummary('${dialogues.length}', 'Dialogues'),
                ],
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
              child: _CategoryTabContent(
                tab: tabs[selectedTab],
                category: category,
                subcategories: visibleSubcategories,
                expressions: expressions,
                dialogues: dialogues,
                qa: qa,
                vocabulary: vocabulary,
              ),
            ),
          ],
        ),
      );
    },
  );
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
                    theme.phrasebook.headerEnd,
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

class _CategoryTabContent extends StatelessWidget {
  const _CategoryTabContent({
    required this.tab,
    required this.category,
    required this.subcategories,
    required this.expressions,
    required this.dialogues,
    required this.qa,
    required this.vocabulary,
  });

  final String tab;
  final Map<String, Object?> category;
  final List<Map<String, Object?>> subcategories;
  final List<Map<String, Object?>> expressions;
  final List<Map<String, Object?>> dialogues;
  final List<Map<String, Object?>> qa;
  final List<Map<String, Object?>> vocabulary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[];
    if (tab == 'All') {
      children.addAll([
        Text(
          'Subcategories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        for (final subcategory in subcategories)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SubcategoryTile(
              icon: iconFor('${category['icon_key']}'),
              title: '${subcategory['english_title']}',
              subtitle: '${subcategory['somali_title']}',
              onTap: () {
                final subId = subcategory['id'];
                final hasPhraseContent =
                    expressions.any((row) => row['subcategory_id'] == subId) ||
                    qa.any((row) => row['subcategory_id'] == subId);
                final hasDialogueContent = dialogues.any(
                  (row) => row['subcategory_id'] == subId,
                );
                context.push(
                  hasPhraseContent
                      ? ExpressionsFeature.listPath(
                          '${category['id']}',
                          '$subId',
                        )
                      : hasDialogueContent
                      ? DialoguesFeature.listPath('${category['id']}')
                      : ExpressionsFeature.listPath('${category['id']}', 'all'),
                );
              },
            ),
          ),
      ]);
    }
    if (tab == 'All' || tab == 'Expressions') {
      children.addAll([
        if (tab == 'All') const SizedBox(height: 10),
        SectionHeader(title: 'Expressions'),
        const SizedBox(height: 8),
        for (final expression in expressions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpressionCard(
              english: '${expression['english_text']}',
              somali: '${expression['somali_text']}',
              chips: [
                '${expression['formality']}',
                '${expression['difficulty']}',
              ],
              onTap: () => context.push(
                ExpressionsFeature.detailPath('${expression['id']}'),
              ),
            ),
          ),
      ]);
    }
    if (tab == 'All' || tab == 'Dialogs') {
      children.addAll([
        if (tab == 'All') const SizedBox(height: 10),
        SectionHeader(title: 'Dialogs'),
        const SizedBox(height: 8),
        for (final dialogue in dialogues)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DialogueSummaryCard(
              dialogue: dialogue,
              onTap: () => context.push(
                DialoguesFeature.detailPath('${dialogue['id']}'),
              ),
            ),
          ),
      ]);
    }
    if (tab == 'All' || tab == 'Q & A') {
      children.addAll([
        if (tab == 'All') const SizedBox(height: 10),
        SectionHeader(title: 'Q & A'),
        const SizedBox(height: 8),
        for (final item in qa)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpressionCard(
              english: '${item['english_question']}',
              somali: '${item['somali_question']}',
              chips: const ['Question'],
            ),
          ),
      ]);
    }
    if (tab == 'All' || tab == 'Vocab') {
      children.addAll([
        if (tab == 'All') const SizedBox(height: 10),
        SectionHeader(title: 'Vocabulary'),
        const SizedBox(height: 8),
        for (final word in vocabulary)
          BilingualRow(
            english: '${word['english_headword']}',
            somali: '${word['somali_headword']}',
            onTap: () =>
                context.push(VocabularyFeature.detailPath('${word['id']}')),
          ),
      ]);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      children: children,
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
                    theme.phrasebook.headerEnd,
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
    required this.english,
    required this.somali,
    required this.chips,
    this.onTap,
  });

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
              Icon(
                Icons.star_border,
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
