import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/library_model.dart';

class ProfileScreen extends StatefulWidget {
  final LibraryModel libraryModel;

  const ProfileScreen({
    super.key,
    required this.libraryModel,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _cardController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.libraryModel.readerName,
    );

    _cardController = TextEditingController(
      text: widget.libraryModel.readerCard,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.libraryModel.updateProfile(
      name: _nameController.text.trim(),
      card: _cardController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профіль збережено'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль читача'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person,
                    size: 90,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ім’я',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введіть ім’я';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cardController,
                    decoration: const InputDecoration(
                      labelText: 'Номер читацького квитка',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введіть номер квитка';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Зберегти профіль'),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: widget.libraryModel,
                    builder: (context, child) {
                      final authenticated =
                          widget.libraryModel.isAuthenticated;

                      return OutlinedButton.icon(
                        onPressed: () {
                          if (authenticated) {
                            widget.libraryModel.logout();
                          } else {
                            context.push('/login');
                          }
                        },
                        icon: Icon(
                          authenticated
                              ? Icons.logout
                              : Icons.login,
                        ),
                        label: Text(
                          authenticated ? 'Вийти' : 'Увійти',
                        ),
                      );
                    },
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
