import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save or update UTV
  Future<void> saveUTV({
    required String userId,
    required String utvId,
    required String name,
    required String model,
    required String vin,
    required String imageUrl,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('utvs')
        .doc(utvId)
        .set({
      'name': name,
      'model': model,
      'vin': vin,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Fetch UTVs
  Stream<QuerySnapshot> getUTVs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('utvs')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
