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
  static const _splashAsset = 'assets/branding/splash_logo.png';

  @override
  void initState() {
    super.initState();
    _continueAfterWarmup();
  }

  Future<void> _continueAfterWarmup() async {
    var hasCompletedOnboarding = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      hasCompletedOnboarding =
          prefs.getBool(OnboardingFeature.preferenceKey) == true;
      await ref.read(repositoryProvider).categories();
    } catch (_) {
      hasCompletedOnboarding = false;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    context.go(
      hasCompletedOnboarding
          ? HomeFeature.route
          : OnboardingFeature.onboardingRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final logoSize = (constraints.biggest.shortestSide * 0.68).clamp(
            220.0,
            360.0,
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(logoSize * 0.18),
                    child: Image.asset(
                      _splashAsset,
                      width: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Somali\nPhrasebook',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'English-Somali\nEveryday Reference',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
