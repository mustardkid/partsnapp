import 'package:cloud_firestore/cloud_firestore.dart';
import 'vehicle.dart';
import 'part.dart';
import 'service_log.dart';

class VehicleStore {
  static List<Vehicle> vehicles = [];

  static final _firestore = FirebaseFirestore.instance;
  static final _userId = 'test_user'; // Replace with auth UID later

  static Future<void> loadVehicles() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .get();

    vehicles = snapshot.docs
        .map((doc) => Vehicle.fromMap(doc.id, doc.data()))
        .toList();
  }

  static Future<void> addVehicle(Vehicle vehicle) async {
    final ref = _firestore
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .doc(vehicle.id);

    await ref.set(vehicle.toMap());
    vehicles.add(vehicle);
  }

  static Future<void> loadDummyData() async {
    final dummyVehicle = Vehicle(
      id: 'rzr_2023_001',
      year: '2023',
      make: 'Polaris',
      model: 'RZR XP 1000',
      nickname: 'Mud Slayer',
    );

    await addVehicle(dummyVehicle);

    final dummyParts = [
      Part(
        id: 'part_001',
        name: 'SuperATV High Clearance A-Arms',
        description: 'Heavy duty high clearance A-arms.',
        imageUrl: '',
        category: 'Suspension',
        compatibleWith: 'Polaris RZR XP 1000',
        price: 399.99,
        installDate: '2024-03-12',
        notes: 'Replaced stock arms for 2" lift and better clearance.',
      ),
      Part(
        id: 'part_002',
        name: 'K&N Performance Air Filter',
        description: 'Reusable air filter for performance.',
        imageUrl: '',
        category: 'Intake',
        compatibleWith: 'Polaris RZR XP 1000',
        price: 69.95,
        installDate: '2024-04-05',
        notes: 'Improved airflow, reusable after cleaning.',
      ),
      Part(
        id: 'part_003',
        name: 'Rigid Industries Light Bar',
        description: 'LED light bar for night riding.',
        imageUrl: '',
        category: 'Lighting',
        compatibleWith: 'Polaris RZR XP 1000',
        price: 299.99,
        installDate: '2024-05-01',
        notes: 'Mounted to front bumper. Bright as hell.',
      ),
    ];

    final partsRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .doc(dummyVehicle.id)
        .collection('parts');

    for (final part in dummyParts) {
      await partsRef.doc(part.id).set(part.toMap());
    }

    final dummyServices = [
      ServiceLog(
        id: 'service_001',
        vehicleId: dummyVehicle.id,
        serviceType: 'Oil Change',
        description: 'Oil Change & Filter',
        notes: 'Used synthetic 10W-40.',
        date: DateTime(2024, 03, 20),
        cost: 75.00,
        partIds: [],
      ),
      ServiceLog(
        id: 'service_002',
        vehicleId: dummyVehicle.id,
        serviceType: 'Inspection',
        description: 'CVT Belt Inspection',
        notes: 'No signs of wear.',
        date: DateTime(2024, 04, 10),
        cost: 0.00,
        partIds: [],
      ),
      ServiceLog(
        id: 'service_003',
        vehicleId: dummyVehicle.id,
        serviceType: 'Flush',
        description: 'Rear Differential Flush',
        notes: 'Flushed and refilled with synthetic gear oil.',
        date: DateTime(2024, 05, 15),
        cost: 110.00,
        partIds: [],
      ),
    ];

    final serviceRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('vehicles')
        .doc(dummyVehicle.id)
        .collection('service_logs');

    for (final log in dummyServices) {
      await serviceRef.doc(log.id).set(log.toMap());
    }

    dummyVehicle.serviceLogs.addAll(dummyServices);
    vehicles.add(dummyVehicle);
  }
}
