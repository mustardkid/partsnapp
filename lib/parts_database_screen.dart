import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'part.dart';

class PartsDatabaseScreen extends StatefulWidget {
  const PartsDatabaseScreen({super.key});

  @override
  State<PartsDatabaseScreen> createState() => _PartsDatabaseScreenState();
}

class _PartsDatabaseScreenState extends State<PartsDatabaseScreen> {
  List<Part> _allParts = [];
  List<Part> _filteredParts = [];
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadParts();
  }

  Future<void> _loadParts() async {
    final snapshot = await FirebaseFirestore.instance.collection('parts').get();
    final parts = snapshot.docs.map((doc) => Part.fromMap(doc.data())).toList();

    setState(() {
      _allParts = parts;
      _filteredParts = parts;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.toLowerCase();
      _filteredParts = _allParts.where((part) {
        return part.name.toLowerCase().contains(_searchTerm) ||
            part.compatibleWith.toLowerCase().contains(_searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parts Lookup')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search by name or vehicle',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredParts.isEmpty
                ? const Center(child: Text('No matching parts found.'))
                : ListView.builder(
                    itemCount: _filteredParts.length,
                    itemBuilder: (context, index) {
                      final part = _filteredParts[index];
                      return Card(
                        child: ListTile(
                          title: Text(part.name),
                          subtitle: Text('${part.category} • ${part.compatibleWith}'),
                          trailing: Text('\$${part.price.toStringAsFixed(2)}'),
                          onTap: () {
                            // TODO: Attach to vehicle or preview part
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
