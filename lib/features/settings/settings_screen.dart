import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/phrasebook_app.dart';
import '../../core/database/phrasebook_repository.dart';
import '../../core/reference/reference_library.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../progress/progress_feature.dart';
import '../recent/recent_feature.dart';
import '../reference/reference_feature.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.phrasebook.greenHeaderStart,
                  theme.phrasebook.greenHeaderEnd,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Row(
                  children: [
                    const AppMark(size: 42),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'More',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                const SettingsSectionTitle('Appearance'),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.language),
                  title: const Text('Language order'),
                  subtitle: const Text('English to Somali'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DisplayPreferenceScreen(),
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.brightness_6,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<ThemeMode>(
                          initialValue: themeMode,
                          isExpanded: true,
                          dropdownColor: theme.colorScheme.surfaceContainerLow,
                          iconEnabledColor: theme.colorScheme.onSurfaceVariant,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Theme',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text('System'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text('Dark'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            ref.read(themeModeProvider.notifier).setMode(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.text_fields),
                  title: const Text('Text size'),
                  subtitle: Slider(
                    value: ref.watch(textScaleProvider),
                    min: 1,
                    max: 1.6,
                    divisions: 3,
                    onChanged: (value) =>
                        ref.read(textScaleProvider.notifier).setScale(value),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  dense: true,
                  secondary: const Icon(Icons.translate),
                  title: const Text('Show Somali by default'),
                  value: ref.watch(showSomaliProvider),
                  onChanged: (value) =>
                      ref.read(showSomaliProvider.notifier).setVisible(value),
                ),
                const SizedBox(height: 8),
                const SettingsSectionTitle('Library'),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.menu_book_outlined),
                  title: const Text('Reference libraries'),
                  subtitle: const Text('Phrases, questions, idioms, and verbs'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(ReferenceFeature.route),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Statistics'),
                  subtitle: const Text('Progress and content counts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(ProgressFeature.route),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.history),
                  title: const Text('Recent'),
                  subtitle: const Text('Continue from viewed content'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RecentFeature.route),
                ),
                FutureBuilder<Map<String, int>>(
                  future: ref.watch(referenceLibraryProvider).counts(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.values.fold<int>(
                      0,
                      (total, value) => total + value,
                    );
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.storage_outlined),
                      title: const Text('Offline reference entries'),
                      trailing: Text(
                        count == null ? '' : '$count',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const SettingsSectionTitle('Data'),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.history),
                  title: const Text('Clear recent items'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ref.read(repositoryProvider).clearRecent(),
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.search_off),
                  title: const Text('Clear recent searches'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      ref.read(repositoryProvider).clearSearchHistory(),
                ),
                const SizedBox(height: 8),
                const SettingsSectionTitle('About'),
                const ListTile(
                  dense: true,
                  leading: Icon(Icons.info_outline),
                  title: Text('Somali Phrasebook'),
                  subtitle: Text(
                    'Offline English-Somali reference for everyday language.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPreferenceScreen extends ConsumerWidget {
  const DisplayPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showSomali = ref.watch(showSomaliProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('Language Order'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            'Choose how you want to see the content.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          _DisplayChoice(
            title: 'English to Somali',
            selected: showSomali,
            onTap: () => ref.read(showSomaliProvider.notifier).setVisible(true),
          ),
          _DisplayChoice(
            title: 'English only',
            selected: !showSomali,
            onTap: () =>
                ref.read(showSomaliProvider.notifier).setVisible(false),
          ),
        ],
      ),
    );
  }
}

class _DisplayChoice extends StatelessWidget {
  const _DisplayChoice({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: UiCard(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
    ),
  );
}
