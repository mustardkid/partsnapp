import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'service_log.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _costController = TextEditingController();

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final newService = ServiceLog(
        id: const Uuid().v4(),
        vehicleId: 'test_vehicle_id', // Replace or pass dynamically
        serviceType: _serviceTypeController.text.trim(),
        description: _descriptionController.text.trim(),
        notes: _notesController.text.trim(),
        date: DateTime.now(),
        cost: double.tryParse(_costController.text.trim()) ?? 0.0,
        partIds: [],
      );

      // TODO: Save to Firestore or return

      Navigator.pop(context, newService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceTypeController,
                decoration: const InputDecoration(labelText: 'Service Type'),
                validator: (value) => value!.isEmpty ? 'Enter type' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveService,
                child: const Text('Save Service Log'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
