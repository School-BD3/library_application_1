import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/book_data.dart';
import '../models/library_model.dart';

class MyBooksScreen extends StatelessWidget {
  final LibraryModel libraryModel;

  const MyBooksScreen({
    super.key,
    required this.libraryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої книги'),
      ),
      body: ListenableBuilder(
        listenable: libraryModel,
        builder: (context, child) {
          final reservations = libraryModel.reservations;

          if (reservations.isEmpty) {
            return const Center(
              child: Text(
                'У вас поки немає заброньованих книг',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final book = findBookById(reservation.bookId);

              if (book == null) {
                return const SizedBox.shrink();
              }

              final date = reservation.returnDate;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(book.title),
                  subtitle: Text(
                    'Повернути до: '
                    '${date.day}.${date.month}.${date.year}',
                  ),
                  onTap: () {
                    context.push('/catalog/book/${book.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
