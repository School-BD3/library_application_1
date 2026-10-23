import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/book_data.dart';
import '../models/library_model.dart';

class ReserveScreen extends StatefulWidget {
  final String bookId;
  final LibraryModel libraryModel;

  const ReserveScreen({
    super.key,
    required this.bookId,
    required this.libraryModel,
  });

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  DateTime? _returnDate;
  final _commentController = TextEditingController();

  bool _saved = false;
  bool _allowExit = false;

  bool get _hasUnsavedChanges =>
      !_saved &&
      (_returnDate != null ||
          _commentController.text.trim().isNotEmpty);

  Future<void> _confirmExit() async {
    if (!_hasUnsavedChanges) {
      setState(() => _allowExit = true);
      if (mounted) context.pop();
      return;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Незбережені зміни'),
          content: const Text(
            'Вийти без збереження бронювання?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Вийти'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldExit != true) return;

    setState(() => _allowExit = true);
    context.pop();
  }

  Future<void> _selectReturnDate() async {
    final result = await context.push<DateTime>(
      '/catalog/book/${widget.bookId}/reserve/date',
    );

    if (!mounted || result == null) return;

    setState(() {
      _returnDate = result;
    });
  }

  void _saveReservation() {
    if (_returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Спочатку оберіть дату повернення'),
        ),
      );
      return;
    }

    widget.libraryModel.reserveBook(
      widget.bookId,
      _returnDate!,
    );

    setState(() {
      _saved = true;
      _allowExit = true;
    });

    context.go('/my-books');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = findBookById(widget.bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Помилка'),
        ),
        body: const Center(
          child: Text('Книгу не знайдено'),
        ),
      );
    }

    return PopScope(
      canPop: _allowExit || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmExit();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Бронювання книги'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Автор: ${book.author}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _selectReturnDate,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Обрати дату повернення'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _returnDate == null
                        ? 'Дата не обрана'
                        : 'Повернути до: '
                          '${_returnDate!.day}.'
                          '${_returnDate!.month}.'
                          '${_returnDate!.year}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Коментар (необов’язково)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _saveReservation,
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Підтвердити бронювання'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
