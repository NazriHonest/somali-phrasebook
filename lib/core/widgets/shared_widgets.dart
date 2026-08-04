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
        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const Center(child: CircularProgressIndicator()),
        );
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
              'Search words, phrases, dialogues...',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.phrasebook.greenHeaderStart,
            theme.phrasebook.greenHeaderEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: theme.colorScheme.onPrimary,
        size: size * 0.56,
      ),
    );
  }
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
  const IconBox({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.phrasebook.brandSoft;
    return SizedBox.square(
      dimension: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
        ),
      ),
    );
  }
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

class CategoryHeroArt extends StatelessWidget {
  const CategoryHeroArt({
    super.key,
    required this.icon,
    required this.tone,
    this.height = 92,
  });

  final IconData icon;
  final Color tone;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.phrasebook.brandSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.phrasebook.cardBorder),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 18,
            bottom: 24,
            child: Divider(color: tone.withValues(alpha: 0.35), thickness: 3),
          ),
          Positioned(
            right: 16,
            top: 15,
            child: Icon(icon, size: 48, color: tone),
          ),
          Positioned(
            left: 16,
            bottom: 18,
            child: Icon(Icons.location_city, size: 36, color: tone),
          ),
        ],
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
  if (ReferenceFeature.isReferenceType(type)) {
    context.push(ReferenceFeature.detailPath(type, id));
  }
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

IconData subcategoryIconFor(String text) {
  final value = text.toLowerCase();
  if (value.contains('repeat')) return Icons.replay;
  if (value.contains('slow')) return Icons.speed;
  if (value.contains('meaning')) return Icons.help_outline;
  if (value.contains('spelling')) return Icons.spellcheck;
  if (value.contains('pronunciation')) return Icons.record_voice_over;
  if (value.contains('understand')) return Icons.psychology_outlined;
  if (value.contains('interpreter')) return Icons.translate;
  if (value.contains('confirm')) return Icons.verified;
  if (value.contains('write')) return Icons.edit_note;
  if (value.contains('english level')) return Icons.school;
  if (value.contains('greeting')) return Icons.waving_hand;
  if (value.contains('introduction')) return Icons.person_add;
  if (value.contains('goodbye')) return Icons.logout;
  if (value.contains('thank')) return Icons.volunteer_activism;
  if (value.contains('apolog')) return Icons.sentiment_dissatisfied;
  if (value.contains('congrat')) return Icons.emoji_events;
  if (value.contains('invitation')) return Icons.mark_email_unread;
  if (value.contains('accepting')) return Icons.check_circle;
  if (value.contains('declining')) return Icons.cancel_outlined;
  if (value.contains('respect')) return Icons.handshake;
  if (value.contains('name')) return Icons.badge;
  if (value.contains('age')) return Icons.cake;
  if (value.contains('nationality')) return Icons.flag;
  if (value.contains('address')) return Icons.location_on;
  if (value.contains('phone number')) return Icons.pin;
  if (value.contains('family')) return Icons.family_restroom;
  if (value.contains('marital')) return Icons.favorite_border;
  if (value.contains('occupation')) return Icons.work;
  if (value.contains('languages')) return Icons.language;
  if (value.contains('emergency contact')) return Icons.contact_emergency;
  if (value.contains('road sign')) return Icons.traffic;
  if (value.contains('hospital sign')) return Icons.local_hospital;
  if (value.contains('airport sign')) return Icons.flight_takeoff;
  if (value.contains('school sign')) return Icons.school;
  if (value.contains('safety sign')) return Icons.health_and_safety;
  if (value.contains('office sign')) return Icons.business;
  if (value.contains('hotel sign')) return Icons.hotel;
  if (value.contains('shopping sign')) return Icons.storefront;
  if (value.contains('warning sign')) return Icons.warning_amber;
  if (value.contains('emergency sign')) return Icons.emergency;
  if (value == 'length') return Icons.straighten;
  if (value == 'weight') return Icons.monitor_weight;
  if (value == 'volume') return Icons.local_drink;
  if (value == 'temperature') return Icons.thermostat;
  if (value == 'distance') return Icons.route;
  if (value.contains('clothing sizes')) return Icons.checkroom;
  if (value.contains('shoe sizes')) return Icons.hiking;
  if (value.contains('cooking measurements')) return Icons.soup_kitchen;
  if (value.contains('time measurement')) return Icons.timer;
  if (value.contains('counting')) return Icons.pin;
  if (value.contains('ordinal')) return Icons.format_list_numbered;
  if (value.contains('numbered prices')) return Icons.sell;
  if (value.contains('telephone numbers')) return Icons.dialpad;
  if (value == 'dates') return Icons.calendar_month;
  if (value == 'years') return Icons.event;
  if (value.contains('fractions')) return Icons.pie_chart_outline;
  if (value.contains('percent')) return Icons.percent;
  if (value.contains('room numbers')) return Icons.meeting_room;
  if (value == 'cash') return Icons.payments;
  if (value.contains('credit card')) return Icons.credit_card;
  if (value.contains('mobile payment')) return Icons.phone_android;
  if (value == 'bank') return Icons.account_balance;
  if (value == 'atm') return Icons.atm;
  if (value.contains('exchange')) return Icons.currency_exchange;
  if (value == 'bills') return Icons.receipt_long;
  if (value.contains('receipt')) return Icons.receipt;
  if (value.contains('refund')) return Icons.assignment_return;
  if (value.contains('discount')) return Icons.discount;
  if (value.contains('telling time')) return Icons.schedule;
  if (value == 'days') return Icons.today;
  if (value == 'months') return Icons.date_range;
  if (value.contains('appointment')) return Icons.event_available;
  if (value.contains('opening hours')) return Icons.access_time;
  if (value.contains('scheduling')) return Icons.edit_calendar;
  if (value.contains('late')) return Icons.timer_off;
  if (value.contains('frequency')) return Icons.repeat;
  if (value.contains('holiday')) return Icons.celebration;
  if (value.contains('asking directions')) return Icons.assistant_direction;
  if (value == 'buildings') return Icons.location_city;
  if (value == 'rooms') return Icons.meeting_room;
  if (value == 'furniture') return Icons.chair;
  if (value == 'position') return Icons.open_with;
  if (value.contains('left and right')) return Icons.compare_arrows;
  if (value == 'maps') return Icons.map;
  if (value.contains('lost')) return Icons.find_replace;
  if (value.contains('nearby')) return Icons.near_me;
  if (value == 'people') return Icons.groups;
  if (value == 'appearance') return Icons.face;
  if (value == 'personality') return Icons.psychology;
  if (value.contains('colour')) return Icons.palette;
  if (value == 'shapes') return Icons.category;
  if (value.contains('object sizes')) return Icons.photo_size_select_large;
  if (value == 'feelings') return Icons.mood;
  if (value == 'emotions') return Icons.sentiment_satisfied;
  if (value == 'weather') return Icons.wb_sunny;
  if (value == 'objects') return Icons.widgets;
  if (value == 'home') return Icons.home;
  if (value == 'cooking') return Icons.restaurant_menu;
  if (value == 'cleaning') return Icons.cleaning_services;
  if (value == 'shopping') return Icons.shopping_bag;
  if (value == 'working') return Icons.work_history;
  if (value == 'studying') return Icons.menu_book;
  if (value == 'travelling') return Icons.luggage;
  if (value == 'exercise') return Icons.fitness_center;
  if (value == 'hobbies') return Icons.sports_esports;
  if (value == 'technology') return Icons.devices;
  if (value == 'bus') return Icons.directions_bus;
  if (value == 'taxi') return Icons.local_taxi;
  if (value == 'train') return Icons.train;
  if (value == 'airport') return Icons.flight_takeoff;
  if (value == 'tickets') return Icons.confirmation_number;
  if (value == 'driving') return Icons.directions_car;
  if (value == 'fuel') return Icons.local_gas_station;
  if (value == 'parking') return Icons.local_parking;
  if (value.contains('route directions')) return Icons.route;
  if (value.contains('ride sharing')) return Icons.hail;
  if (value.contains('phone calls')) return Icons.phone_in_talk;
  if (value.contains('text messages')) return Icons.sms;
  if (value == 'emails') return Icons.alternate_email;
  if (value == 'meetings') return Icons.groups_2;
  if (value == 'instructions') return Icons.integration_instructions;
  if (value.contains('asking questions')) return Icons.quiz;
  if (value.contains('giving information')) return Icons.info_outline;
  if (value.contains('online communication')) return Icons.public;
  if (value.contains('body parts')) return Icons.accessibility_new;
  if (value == 'symptoms') return Icons.sick;
  if (value.contains('doctor')) return Icons.medical_services;
  if (value == 'pharmacy') return Icons.local_pharmacy;
  if (value == 'hospital') return Icons.local_hospital;
  if (value == 'medicine') return Icons.medication;
  if (value.contains('dental')) return Icons.medical_information;
  if (value == 'emergency') return Icons.emergency;
  if (value == 'pregnancy') return Icons.pregnant_woman;
  if (value.contains('child care')) return Icons.child_care;
  if (value.contains('restaurant')) return Icons.restaurant;
  if (value.contains('fast food')) return Icons.fastfood;
  if (value.contains('grocery')) return Icons.local_grocery_store;
  if (value == 'fruits') return Icons.apple;
  if (value == 'vegetables') return Icons.eco;
  if (value == 'meat') return Icons.set_meal;
  if (value == 'drinks') return Icons.local_cafe;
  if (value == 'desserts') return Icons.icecream;
  if (value == 'allergies') return Icons.warning_amber;
  if (value.contains('cooking food')) return Icons.soup_kitchen;
  if (value.contains('kitchen tools')) return Icons.kitchen;
  if (value.contains('paying the bill')) return Icons.payments;
  if (value.contains('ordering food')) return Icons.room_service;
  if (value.contains('food storage')) return Icons.inventory_2;
  if (value == 'shirts') return Icons.dry_cleaning;
  if (value == 'pants') return Icons.checkroom;
  if (value == 'shoes') return Icons.hiking;
  if (value == 'accessories') return Icons.watch;
  if (value.contains('clothing colours')) return Icons.palette;
  if (value == 'sizes') return Icons.straighten;
  if (value.contains('clothes shopping')) return Icons.shopping_bag;
  if (value == 'laundry') return Icons.local_laundry_service;
  if (value == 'tailoring') return Icons.content_cut;
  if (value.contains('weather clothing')) return Icons.umbrella;
  if (value == 'renting') return Icons.real_estate_agent;
  if (value == 'buying') return Icons.house;
  if (value.contains('home furniture')) return Icons.chair;
  if (value == 'kitchen') return Icons.kitchen;
  if (value == 'bathroom') return Icons.bathtub;
  if (value == 'repairs') return Icons.handyman;
  if (value == 'utilities') return Icons.bolt;
  if (value == 'moving') return Icons.move_up;
  if (value == 'neighbours') return Icons.diversity_3;
  if (value.contains('home safety')) return Icons.security;
  if (value.contains('job search')) return Icons.manage_search;
  if (value == 'applications') return Icons.description;
  if (value == 'cv') return Icons.article;
  if (value == 'interviews') return Icons.record_voice_over;
  if (value == 'office') return Icons.business_center;
  if (value.contains('work meetings')) return Icons.groups_2;
  if (value == 'salary') return Icons.attach_money;
  if (value == 'leave') return Icons.event_busy;
  if (value.contains('workplace safety')) return Icons.health_and_safety;
  if (value == 'promotions') return Icons.trending_up;
  if (value == 'classroom') return Icons.co_present;
  if (value == 'subjects') return Icons.subject;
  if (value == 'homework') return Icons.assignment;
  if (value == 'teachers') return Icons.school;
  if (value == 'students') return Icons.groups;
  if (value == 'exams') return Icons.edit_document;
  if (value == 'attendance') return Icons.fact_check;
  if (value.contains('school supplies')) return Icons.backpack;
  if (value == 'university') return Icons.account_balance;
  if (value.contains('online learning')) return Icons.computer;
  if (value.contains('airport') || value.contains('plane')) return Icons.flight;
  if (value.contains('bus')) return Icons.directions_bus;
  if (value.contains('taxi')) return Icons.local_taxi;
  if (value.contains('direction') || value.contains('location')) {
    return Icons.map;
  }
  if (value.contains('restaurant') || value.contains('food')) {
    return Icons.restaurant;
  }
  if (value.contains('fruit') || value.contains('vegetable')) return Icons.eco;
  if (value.contains('drink')) return Icons.local_cafe;
  if (value.contains('shirt') || value.contains('clothing')) {
    return Icons.checkroom;
  }
  if (value.contains('shoe')) return Icons.hiking;
  if (value.contains('doctor') || value.contains('health')) {
    return Icons.local_hospital;
  }
  if (value.contains('medicine') || value.contains('pharmacy')) {
    return Icons.medication;
  }
  if (value.contains('money') || value.contains('bank')) {
    return Icons.account_balance;
  }
  if (value.contains('school') || value.contains('class')) return Icons.school;
  if (value.contains('home') || value.contains('rent')) return Icons.home;
  if (value.contains('work') || value.contains('job')) return Icons.work;
  if (value.contains('time') || value.contains('date')) return Icons.schedule;
  if (value.contains('phone') || value.contains('call')) return Icons.phone;
  if (value.contains('email') || value.contains('message')) return Icons.mail;
  if (value.contains('family') || value.contains('people')) return Icons.groups;
  if (value.contains('weather')) return Icons.wb_sunny;
  if (value.contains('emergency')) return Icons.emergency;
  return Icons.topic_outlined;
}

const pagePadding = EdgeInsets.fromLTRB(16, 8, 16, 96);
