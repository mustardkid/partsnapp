import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PartsCatalogScreen extends StatefulWidget {
  @override
  _PartsCatalogScreenState createState() => _PartsCatalogScreenState();
}

class _PartsCatalogScreenState extends State<PartsCatalogScreen> {
  String? _vehicleId;
  String? _userId;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadUserAndVehicle();
  }

  Future<void> _loadUserAndVehicle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _vehicleId = 'vehicle_1'; // Change if dynamic selection is added
      });
    }
  }

  Future<void> _savePartToGarage(DocumentSnapshot part) async {
    if (_vehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No vehicle found in garage')),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('garage')
        .doc(_vehicleId)
        .collection('saved_parts')
        .doc(part.id);

    final docSnap = await docRef.get();
    if (docSnap.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${part['part_name']} is already saved.')),
      );
      return;
    }

    await docRef.set(part.data() as Map<String, dynamic>);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${part['part_name']} saved to garage.')),
    );
    setState(() {});
  }

  Future<void> _openLink(String url, DocumentSnapshot part) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final clickRef = FirebaseFirestore.instance.collection('affiliate_clicks').doc();

        await clickRef.set({
          'user_id': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'part_id': part.id,
          'part_name': part['part_name'],
          'vehicle_id': _vehicleId ?? '',
          'affiliate_link': url,
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final partsRef = FirebaseFirestore.instance.collection('parts_catalog');

    Query partsQuery = partsRef;
    if (_selectedCategory != 'All') {
      partsQuery = partsQuery.where('category', isEqualTo: _selectedCategory);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts Catalog'),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            items: ['All', 'Brakes', 'Suspension', 'Tires', 'Lighting']
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search parts...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: partsQuery.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final parts = snapshot.data!.docs.where((doc) {
                  final partName = doc['part_name'].toString().toLowerCase();
                  return partName.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final part = parts[index];
                    final link = part['affiliate_link'] ?? '';

                    return ListTile(
                      title: Text(part['part_name']),
                      subtitle: Text(part['category']),
                      trailing: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _openLink(link, part),
                            child: const Text('View'),
                          ),
                          const SizedBox(height: 6),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_userId)
                                .collection('garage')
                                .doc(_vehicleId)
                                .collection('saved_parts')
                                .doc(part.id)
                                .get(),
                            builder: (context, snapshot) {
                              final isSaved = snapshot.data?.exists ?? false;
                              return IconButton(
                                icon: Icon(
                                  isSaved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                                  color: isSaved ? Colors.green : Colors.grey,
                                ),
                                onPressed: () {
                                  if (!isSaved) _savePartToGarage(part);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
