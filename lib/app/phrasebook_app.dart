import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
final textScaleProvider = NotifierProvider<TextScaleController, double>(
  TextScaleController.new,
);
final showSomaliProvider = NotifierProvider<ShowSomaliController, bool>(
  ShowSomaliController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'themeMode';

  @override
  ThemeMode build() {
    unawaited(_load());
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    final mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    state = mode;
  }

  Future<void> setMode(ThemeMode value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value.name);
  }
}

class TextScaleController extends Notifier<double> {
  static const _key = 'textScale';

  @override
  double build() {
    unawaited(_load());
    return 1;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getDouble(_key) ?? 1).clamp(1, 1.6).toDouble();
  }

  Future<void> setScale(double value) async {
    final normalized = value.clamp(1, 1.6).toDouble();
    state = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, normalized);
  }
}

class ShowSomaliController extends Notifier<bool> {
  static const _key = 'showSomali';

  @override
  bool build() {
    unawaited(_load());
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> setVisible(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

class PhrasebookApp extends ConsumerWidget {
  const PhrasebookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = ref.watch(textScaleProvider);
    return MaterialApp.router(
      title: 'Somali Phrasebook',
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeModeProvider),
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(
              media.textScaler.scale(scale).clamp(1, 2.2),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
