import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/shared_widgets.dart';
import '../home/home_feature.dart';
import 'onboarding_feature.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;

  Future<void> done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingFeature.preferenceKey, true);
    if (mounted) context.go(HomeFeature.route);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: done, child: const Text('Skip')),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (value) => setState(() => page = value),
                children: const [
                  OnboardingPage(
                    icon: Icons.forum,
                    title: 'Your everyday English-Somali reference',
                    body:
                        'Find words, phrases, conversations, and more. All offline.',
                  ),
                  OnboardingPage(
                    icon: Icons.search,
                    title: 'Fast search for real situations',
                    body:
                        'Search English or Somali and open the exact phrase, word, or conversation.',
                  ),
                  OnboardingPage(
                    icon: Icons.school,
                    title: 'Save, review, and practice',
                    body:
                        'Keep favorites, revisit recent items, and build confidence with practice.',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: page == i ? 18 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: page == i
                          ? theme.colorScheme.primary
                          : theme.phrasebook.cardBorder,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: page == 2
                      ? done
                      : () => controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                  child: Text(page == 2 ? 'Start' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 156,
          height: 156,
          decoration: BoxDecoration(
            color: Theme.of(context).phrasebook.brandSoft,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const AppMark(size: 58),
              Positioned(
                right: 28,
                top: 38,
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}
