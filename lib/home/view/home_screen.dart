import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Flutter Boilerplate!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is a boilerplate Flutter app with:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.login,
              title: 'Authentication',
              description: 'User login/logout with secure storage',
            ),
            const SizedBox(height: 8),
            _FeatureCard(
              icon: Icons.navigation,
              title: 'Navigation',
              description: 'GoRouter for declarative routing',
            ),
            const SizedBox(height: 8),
            _FeatureCard(
              icon: Icons.memory,
              title: 'State Management',
              description: 'Riverpod for reactive state management',
            ),
            const SizedBox(height: 8),
            _FeatureCard(
              icon: Icons.api,
              title: 'API Integration',
              description: 'Dio for HTTP requests and API calls',
            ),
            const SizedBox(height: 8),
            _FeatureCard(
              icon: Icons.design_services,
              title: 'Modern UI',
              description: 'Material Design 3 components',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
      ),
    );
  }
}