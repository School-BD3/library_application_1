import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReturnDateScreen extends StatefulWidget {
  const ReturnDateScreen({super.key});

  @override
  State<ReturnDateScreen> createState() =>
      _ReturnDateScreenState();
}

class _ReturnDateScreenState extends State<ReturnDateScreen> {
  DateTime? _selectedDate;

  Future<void> _chooseDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дата повернення'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_month,
                size: 90,
                color: Colors.indigo,
              ),
              const SizedBox(height: 24),
              Text(
                _selectedDate == null
                    ? 'Дата ще не обрана'
                    : 'Обрана дата: '
                      '${_selectedDate!.day}.'
                      '${_selectedDate!.month}.'
                      '${_selectedDate!.year}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _chooseDate,
                child: const Text('Обрати дату'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _selectedDate == null
                    ? null
                    : () => context.pop(_selectedDate),
                icon: const Icon(Icons.check),
                label: const Text('Підтвердити'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
