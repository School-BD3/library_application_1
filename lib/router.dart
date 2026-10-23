import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/library_model.dart';

import 'screens/catalog_screen.dart';
import 'screens/book_screen.dart';
import 'screens/my_books_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/reserve_screen.dart';
import 'screens/return_date_screen.dart';

import 'widgets/main_navigation.dart';

final libraryModel = LibraryModel();

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/catalog',
  refreshListenable: libraryModel,

  redirect: (context, state) {
    final location = state.uri.toString();
    final isLoginPage = state.matchedLocation == '/login';

    final isProtectedRoute =
        state.matchedLocation.contains('/reserve');

    if (!libraryModel.isAuthenticated && isProtectedRoute) {
      return Uri(
        path: '/login',
        queryParameters: {
          'from': location,
        },
      ).toString();
    }

    if (libraryModel.isAuthenticated && isLoginPage) {
      final destination = state.uri.queryParameters['from'];

      if (destination != null &&
          destination.startsWith('/') &&
          !destination.startsWith('//') &&
          !destination.startsWith('/login')) {
        return destination;
      }

      return '/catalog';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginScreen(
          libraryModel: libraryModel,
          redirectTo: state.uri.queryParameters['from'],
        );
      },
    ),

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
                return CatalogScreen(
                  selectedGenre:
                      state.uri.queryParameters['genre'],
                );
              },
              routes: [
                GoRoute(
                  path: 'book/:bookId',
                  builder: (context, state) {
                    return BookScreen(
                      bookId: state.pathParameters['bookId']!,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'reserve',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        return ReserveScreen(
                          bookId: state.pathParameters['bookId']!,
                          libraryModel: libraryModel,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'date',
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (context, state) {
                            return const ReturnDateScreen();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-books',
              builder: (context, state) {
                return MyBooksScreen(
                  libraryModel: libraryModel,
                );
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                return ProfileScreen(
                  libraryModel: libraryModel,
                );
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
