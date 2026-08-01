import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../database/phrasebook_repository.dart';
import '../../features/categories/categories_feature.dart';
import '../../features/dialogues/dialogues_feature.dart';
import '../../features/expressions/expressions_feature.dart';
import '../../features/reference/reference_feature.dart';
import '../../features/vocabulary/vocabulary_feature.dart';

class VocabularyList extends StatelessWidget {
  const VocabularyList({super.key, required this.rows});
  final List<Map<String, Object?>> rows;
  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.only(bottom: 96),
    itemCount: rows.length,
    separatorBuilder: (_, _) => const Divider(height: 1),
    itemBuilder: (context, i) => BilingualRow(
      english: '${rows[i]['english_headword']} (${rows[i]['part_of_speech']})',
      somali: '${rows[i]['somali_headword']}',
      onTap: () =>
          context.push(VocabularyFeature.detailPath('${rows[i]['id']}')),
    ),
  );
}

class FutureView<T> extends StatelessWidget {
  const FutureView({super.key, required this.future, required this.builder});
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (snapshot.hasError) {
        return Scaffold(
          body: EmptyState(message: 'Something went wrong:\n${snapshot.error}'),
        );
      }
      return builder(context, snapshot.requireData);
    },
  );
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: Border.all(color: Theme.of(context).phrasebook.cardBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search phrases, words, signs...',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, required this.onChanged, required this.hint});
  final ValueChanged<String> onChanged;
  final String hint;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
      ?action,
    ],
  );
}

class BilingualBlock extends StatelessWidget {
  const BilingualBlock({
    super.key,
    required this.english,
    required this.somali,
  });
  final String english;
  final String somali;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          english,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        SelectableText(
          somali,
          style: TextStyle(color: Theme.of(context).phrasebook.success),
        ),
      ],
    ),
  );
}

class BilingualRow extends StatelessWidget {
  const BilingualRow({
    super.key,
    required this.english,
    required this.somali,
    this.onTap,
  });
  final String english;
  final String somali;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(english, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(somali),
    onTap: onTap,
  );
}

class DialogueLineTile extends StatelessWidget {
  const DialogueLineTile({super.key, required this.line});
  final Map<String, Object?> line;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 84, maxWidth: 112),
          child: Text(
            '${line['speaker']}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        Expanded(
          child: BilingualBlock(
            english: '${line['english_text']}',
            somali: '${line['somali_text']}',
          ),
        ),
      ],
    ),
  );
}

class IconBox extends StatelessWidget {
  const IconBox({super.key, required this.icon, this.backgroundColor});
  final IconData icon;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 44,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
      ),
    ),
  );
}

class ActionPill extends StatelessWidget {
  const ActionPill({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 40),
    child: ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: onTap,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide(color: Theme.of(context).phrasebook.cardBorder),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class PhrasebookScaffold extends StatelessWidget {
  const PhrasebookScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottomNavigationBar,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        title: title == null
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
        actions: actions,
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BlueHeader extends StatelessWidget {
  const BlueHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.child,
    this.headerStart,
    this.headerEnd,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final Color? headerStart;
  final Color? headerEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.phrasebook;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            headerStart ?? colors.headerStart,
            headerEnd ?? colors.headerEnd,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leading ?? const SizedBox(width: 48),
                  const Spacer(),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  height: 1.25,
                ),
              ),
              if (child != null) ...[const SizedBox(height: 18), child!],
            ],
          ),
        ),
      ),
    );
  }
}

class UiCard extends StatelessWidget {
  const UiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    return Card(
      shape: shape,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class PillLabel extends StatelessWidget {
  const PillLabel({super.key, required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.phrasebook.cardBorder),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class InlineTabBar extends StatelessWidget {
  const InlineTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 22),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return InkWell(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: selected ? 3 : 0,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface.withValues(alpha: 0),
                  ),
                ),
              ),
              child: Text(
                tabs[index],
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecentPreview extends ConsumerWidget {
  const RecentPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureView(
    future: ref.watch(repositoryProvider).recent(),
    builder: (context, rows) => rows.isEmpty
        ? const Text('No recent items yet.')
        : Column(
            children: rows
                .take(3)
                .map(
                  (row) => ListTile(
                    title: Text('${row['title']}'),
                    subtitle: Text('${row['subtitle']}'),
                  ),
                )
                .toList(),
          ),
  );
}

class FieldList extends StatelessWidget {
  const FieldList({super.key, required this.row, required this.fields});
  final Map<String, Object?> row;
  final List<String> fields;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final field in fields)
        if ('${row[field] ?? ''}'.trim().isNotEmpty)
          ListTile(
            dense: true,
            title: Text(field.replaceAll('_', ' ')),
            subtitle: Text('${row[field]}'),
          ),
    ],
  );
}

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label),
    trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
  );
}

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class MissingScaffold extends StatelessWidget {
  const MissingScaffold({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: EmptyState(message: 'This item is unavailable.'));
}

void openResult(BuildContext context, Map<String, Object?> row) {
  final type = '${row['type']}';
  final id = '${row['id']}';
  if (type == 'expression') context.push(ExpressionsFeature.detailPath(id));
  if (type == 'dialogue' || type == 'dialogue_line') {
    context.push(DialoguesFeature.detailPath(id));
  }
  if (type == 'vocabulary') context.push(VocabularyFeature.detailPath(id));
  if (type == 'category') context.push(CategoriesFeature.detailPath(id));
  if (type == 'sign') context.push(ReferenceFeature.signsRoute);
}

IconData iconFor(String key) => switch (key) {
  'translate' => Icons.translate,
  'handshake' => Icons.handshake,
  'person' => Icons.person,
  'signpost' => Icons.signpost,
  'scale' => Icons.scale,
  'numbers' => Icons.pin,
  'payments' => Icons.payments,
  'schedule' => Icons.schedule,
  'place' => Icons.place,
  'palette' => Icons.palette,
  'task' => Icons.task_alt,
  'directions_bus' => Icons.directions_bus,
  'mail' => Icons.mail,
  'medical_services' => Icons.medical_services,
  'restaurant' => Icons.restaurant,
  'checkroom' => Icons.checkroom,
  'home' => Icons.home,
  'work' => Icons.work,
  'school' => Icons.school,
  'login' => Icons.login,
  'logout' => Icons.logout,
  'emergency' => Icons.emergency,
  'open' => Icons.lock_open,
  'closed' => Icons.lock,
  'block' => Icons.block,
  'smoke_free' => Icons.smoke_free,
  'warning' => Icons.warning,
  'priority_high' => Icons.priority_high,
  'water_drop' => Icons.water_drop,
  'open_in_full' => Icons.open_in_full,
  'call_made' => Icons.call_made,
  'wc' => Icons.wc,
  'man' => Icons.man,
  'woman' => Icons.woman,
  'elevator' => Icons.elevator,
  'stairs' => Icons.stairs,
  'local_parking' => Icons.local_parking,
  'local_hospital' => Icons.local_hospital,
  'local_pharmacy' => Icons.local_pharmacy,
  'local_police' => Icons.local_police,
  'support_agent' => Icons.support_agent,
  'info' => Icons.info,
  _ => Icons.label,
};

const pagePadding = EdgeInsets.fromLTRB(16, 8, 16, 96);
