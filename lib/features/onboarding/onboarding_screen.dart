import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) => Scaffold(
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
                  title: 'Practical everyday phrases',
                  body:
                      'Short English phrases with clear Somali meaning for daily situations.',
                ),
                OnboardingPage(
                  icon: Icons.menu_book,
                  title: 'Dialogues and wordlists',
                  body:
                      'Browse bilingual dialogues, English-Somali words, and Somali-English entries offline.',
                ),
                OnboardingPage(
                  icon: Icons.school,
                  title: 'Search, save, and practice',
                  body:
                      'Find content quickly, save useful items, and review with lightweight practice.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
        ],
      ),
    ),
  );
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
        Icon(icon, size: 92, color: Theme.of(context).colorScheme.primary),
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
