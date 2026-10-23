import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Бібліотека коледжу',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
