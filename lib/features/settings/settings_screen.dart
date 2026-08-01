import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/phrasebook_app.dart';
import '../../core/database/phrasebook_repository.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.phrasebook.slateHeaderStart,
                  theme.phrasebook.slateHeaderEnd,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Center(
                  child: Text(
                    'Settings',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
              children: [
                SettingsSectionTitle('Display'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        leading: Icon(Icons.brightness_6),
                        title: Text('Theme'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<ThemeMode>(
                            showSelectedIcon: false,
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: Text('System'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text('Light'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text('Dark'),
                              ),
                            ],
                            selected: {ref.watch(themeModeProvider)},
                            onSelectionChanged: (value) => ref
                                .read(themeModeProvider.notifier)
                                .setMode(value.first),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
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
                  secondary: const Icon(Icons.translate),
                  title: const Text('Show Somali by default'),
                  value: ref.watch(showSomaliProvider),
                  onChanged: (value) =>
                      ref.read(showSomaliProvider.notifier).setVisible(value),
                ),
                const SizedBox(height: 16),
                SettingsSectionTitle('Data'),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Clear recent items'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ref.read(repositoryProvider).clearRecent(),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.search_off),
                  title: const Text('Clear recent searches'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      ref.read(repositoryProvider).clearSearchHistory(),
                ),
                const SizedBox(height: 16),
                SettingsSectionTitle('About'),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('English-Somali Phrasebook'),
                  subtitle: Text(
                    'Offline bilingual phrasebook and wordlist with original authored content.',
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

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
    ),
  );
}
