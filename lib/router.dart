import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/catalog_screen.dart';
import 'screens/my_books_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/main_navigation.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/catalog',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) {
                return const CatalogScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-books',
              builder: (context, state) {
                return const MyBooksScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                return const ProfileScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помилка'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Сторінку не знайдено',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/catalog'),
              child: const Text('На головну'),
            ),
          ],
        ),
      ),
    );
  },
);
