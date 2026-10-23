import 'package:flutter/material.dart';

class BookReservation {
  final String bookId;
  final DateTime returnDate;

  const BookReservation({
    required this.bookId,
    required this.returnDate,
  });
}

class LibraryModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _readerName = 'Студент';
  String _readerCard = 'LIB-001';

  final List<BookReservation> _reservations = [];

  bool get isAuthenticated => _isAuthenticated;
  String get readerName => _readerName;
  String get readerCard => _readerCard;

  List<BookReservation> get reservations =>
      List.unmodifiable(_reservations);

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String card,
  }) {
    _readerName = name;
    _readerCard = card;
    notifyListeners();
  }

  void reserveBook(String bookId, DateTime returnDate) {
    _reservations.removeWhere(
      (reservation) => reservation.bookId == bookId,
    );

    _reservations.add(
      BookReservation(
        bookId: bookId,
        returnDate: returnDate,
      ),
    );

    notifyListeners();
  }

  bool isReserved(String bookId) {
    return _reservations.any(
      (reservation) => reservation.bookId == bookId,
    );
  }
}
