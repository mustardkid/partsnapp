import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}


class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _saving = false;

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _saving = true;
      });

      final uuid = Uuid();
      final vehicleId = uuid.v4();

      final vehicleData = {
        'id': vehicleId,
        'make': _makeController.text.trim(),
        'model': _modelController.text.trim(),
        'year': _yearController.text.trim(),
        'nickname': _nicknameController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(vehicleId)
          .set(vehicleData);

      setState(() {
        _saving = false;
      });

      Navigator.pop(context); // or navigate to garage screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: _saving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: InputDecoration(labelText: 'Make'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter make' : null,
                    ),
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(labelText: 'Model'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter model' : null,
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter year' : null,
                    ),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(labelText: 'Nickname'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveVehicle,
                      child: Text('Save Vehicle'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
