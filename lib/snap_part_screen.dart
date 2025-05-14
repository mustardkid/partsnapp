import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SnapPartScreen extends StatefulWidget {
  const SnapPartScreen({super.key});

  @override
  State<SnapPartScreen> createState() => _SnapPartScreenState();
}

class _SnapPartScreenState extends State<SnapPartScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snap a Part')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, width: 300, height: 300, fit: BoxFit.cover)
            else
              const Text('No image selected.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Choose Image'),
              onPressed: _pickImage,
            ),
          ],
        ),
      ),
    );
  }
}
