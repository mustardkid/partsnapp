import 'package:cloud_firestore/cloud_firestore.dart';
import 'part.dart';

Future<void> addPartToFirestore(String userId, String vehicleId, Part part) async {
  final partsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('vehicles')
      .doc(vehicleId)
      .collection('parts');

  await partsRef.add(part.toMap());
}

Future<List<Part>> loadPartsFromFirestore(String userId, String vehicleId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('vehicles')
      .doc(vehicleId)
      .collection('parts')
      .get();

  return snapshot.docs.map((doc) => Part.fromMap(doc.data())).toList();
}
