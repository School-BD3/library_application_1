import 'package:flutter/material.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої книги'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 80),
            SizedBox(height: 16),
            Text(
              'Тут будуть заброньовані книги',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
