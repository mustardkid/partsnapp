import 'package:flutter/material.dart';
import 'vehicle_store.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Firestore Flow')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await VehicleStore.loadDummyData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dummy data uploaded!')),
            );
          },
          child: const Text('Upload Dummy Vehicle'),
        ),
      ),
    );
  }
}
