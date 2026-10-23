import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/book.dart';
import '../models/book_data.dart';

class CatalogScreen extends StatefulWidget {
  final String? selectedGenre;

  const CatalogScreen({
    super.key,
    this.selectedGenre,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('CatalogScreen build');

    final genres = [
      'Усі',
      ...{for (final book in books) book.genre},
    ];

    final currentGenre = widget.selectedGenre ?? 'Усі';

    final List<Book> filteredBooks = currentGenre == 'Усі'
        ? books
        : books.where((book) => book.genre == currentGenre).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог бібліотеки'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              key: ValueKey(currentGenre),
              initialValue: genres.contains(currentGenre)
                  ? currentGenre
                  : 'Усі',
              decoration: const InputDecoration(
                labelText: 'Жанр книги',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list),
              ),
              items: genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (genre) {
                if (genre == null) return;

                if (genre == 'Усі') {
                  context.go('/catalog');
                } else {
                  context.go(
                    Uri(
                      path: '/catalog',
                      queryParameters: {'genre': genre},
                    ).toString(),
                  );
                }
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Знайдено книг: ${filteredBooks.length}'),
                const Spacer(),
                Text('Лічильник: $counter'),
                IconButton(
                  onPressed: () {
                    setState(() => counter++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Збільшити лічильник',
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView.builder(
              key: const PageStorageKey('catalog-list'),
              padding: const EdgeInsets.all(12),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${book.author}\n${book.genre} • ${book.year}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('/catalog/book/${book.id}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
