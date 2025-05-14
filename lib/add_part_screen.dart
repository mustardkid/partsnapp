import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'part.dart';

class AddPartScreen extends StatefulWidget {
  const AddPartScreen({super.key});

  @override
  State<AddPartScreen> createState() => _AddPartScreenState();
}

class _AddPartScreenState extends State<AddPartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _installDateController = TextEditingController();

  void _savePart() {
    if (_formKey.currentState!.validate()) {
      final part = Part(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: '',
        category: 'General',
        compatibleWith: 'Unknown',
        price: 0.0,
        installDate: _installDateController.text.trim(),
        notes: _notesController.text.trim(),
      );

      // TODO: Save `part` to Firestore or pass it back

      Navigator.pop(context, part);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Part')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Part Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _installDateController,
                decoration: const InputDecoration(labelText: 'Install Date'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePart,
                child: const Text('Save Part'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
