import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'vehicle.dart';
import 'part.dart';
import 'service_log.dart';
import 'add_part_screen.dart';
import 'add_service_screen.dart';

class VehicleProfileScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleProfileScreen({super.key, required this.vehicle});

  @override
  State<VehicleProfileScreen> createState() => _VehicleProfileScreenState();
}

class _VehicleProfileScreenState extends State<VehicleProfileScreen> {
  final String _userId = 'test_user';

  List<Part> _parts = [];
  List<ServiceLog> _serviceLogs = [];

  @override
  void initState() {
    super.initState();
    _loadRelatedData();
  }

  Future<void> _loadRelatedData() async {
    final partsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .doc(widget.vehicle.id)
        .collection('parts')
        .get();

    final serviceSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .doc(widget.vehicle.id)
        .collection('service_logs')
        .get();

    setState(() {
      _parts = partsSnapshot.docs
          .map((doc) => Part.fromMap(doc.data()))
          .toList();

      _serviceLogs = serviceSnapshot.docs
          .map((doc) => ServiceLog.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> _addPart() async {
    final newPart = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPartScreen()),
    );

    if (newPart is Part) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('vehicles')
          .doc(widget.vehicle.id)
          .collection('parts')
          .doc(newPart.id);

      await docRef.set(newPart.toMap());
      await _loadRelatedData();
    }
  }

  Future<void> _addService() async {
    final newService = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddServiceScreen()),
    );

    if (newService is ServiceLog) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('vehicles')
          .doc(widget.vehicle.id)
          .collection('service_logs')
          .doc(newService.id);

      await docRef.set(newService.toMap());
      await _loadRelatedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;

    return Scaffold(
      appBar: AppBar(title: Text('${v.nickname} Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${v.year} ${v.make} ${v.model}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (v.nickname.isNotEmpty)
              Text('Nickname: ${v.nickname}'),

            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addPart,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Part'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _addService,
                  icon: const Icon(Icons.build),
                  label: const Text('Add Service'),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              'Installed Parts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_parts.isEmpty)
              const Text('No parts added yet.')
            else
              ..._parts.map((p) => ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.installDate} — ${p.notes}'),
                    leading: const Icon(Icons.settings),
                  )),

            const Divider(height: 32),
            const Text(
              'Service History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_serviceLogs.isEmpty)
              const Text('No service records yet.')
            else
              ..._serviceLogs.map((s) => ListTile(
                    title: Text(s.description),
                    subtitle: Text('${s.date.toLocal()} — \$${s.cost.toStringAsFixed(2)}'),
                    leading: const Icon(Icons.history),
                  )),
          ],
        ),
      ),
    );
  }
}
