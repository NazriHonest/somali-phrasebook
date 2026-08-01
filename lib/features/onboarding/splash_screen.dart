import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/phrasebook_repository.dart';
import '../home/home_feature.dart';
import 'onboarding_feature.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      await ref.read(repositoryProvider).categories();
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        context.go(
          prefs.getBool(OnboardingFeature.preferenceKey) == true
              ? HomeFeature.route
              : OnboardingFeature.onboardingRoute,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.translate,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'English-Somali Phrasebook',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Useful English. Somali support.\nIngiriisi waxtar leh. Taageero Somali ah.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
