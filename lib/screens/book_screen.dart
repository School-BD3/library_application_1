import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/book_data.dart';

class BookScreen extends StatelessWidget {
  final String bookId;

  const BookScreen({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final book = findBookById(bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Книгу не знайдено'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80),
              const SizedBox(height: 16),
              const Text('Такої книги не існує'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/catalog'),
                child: const Text('До каталогу'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Інформація про книгу'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 100,
                  color: Colors.indigo,
                ),

                const SizedBox(height: 24),

                Text(
                  book.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 16),

                Text(
                  'Автор: ${book.author}',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(
                  'Жанр: ${book.genre}',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(
                  'Рік видання: ${book.year}',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Опис',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  book.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Бронювання додамо на наступному етапі',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('Забронювати книгу'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
