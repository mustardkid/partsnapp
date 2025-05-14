import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class GarageScreen extends StatefulWidget {
  @override
  _GarageScreenState createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

  Future<void> _openLink(String url, DocumentSnapshot part) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);

      if (_userId != null) {
        final clickRef = FirebaseFirestore.instance.collection('affiliate_clicks').doc();

        await clickRef.set({
          'user_id': _userId,
          'timestamp': FieldValue.serverTimestamp(),
          'part_id': part.id,
          'part_name': part['part_name'],
          'vehicle_id': part['vehicle_id'] ?? '',
          'affiliate_link': url,
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch link')),
      );
    }
  }

  Widget _buildSavedPartsList(String vehicleId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('garage')
          .doc(vehicleId)
          .collection('saved_parts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final parts = snapshot.data!.docs;

        if (parts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No saved parts for this vehicle.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parts.length,
          itemBuilder: (context, index) {
            final part = parts[index];
            return ListTile(
              title: Text(part['part_name']),
              subtitle: Text(part['category'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () => _openLink(part['affiliate_link'] ?? '', part),
                child: const Text('View'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGarageVehicles() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('garage')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final vehicles = snapshot.data!.docs;

        if (vehicles.isEmpty) {
          return const Center(child: Text('No vehicles in your garage.'));
        }

        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            final vehicleName = vehicle['name'] ?? 'Unnamed Vehicle';
            final vehicleId = vehicle.id;

            return ExpansionTile(
              title: Text(vehicleName),
              children: [
                _buildSavedPartsList(vehicleId),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Garage')),
      body: _userId == null
          ? const Center(child: Text('Please log in to view your garage.'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildGarageVehicles(),
            ),
    );
  }
}
