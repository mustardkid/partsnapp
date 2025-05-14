import 'part.dart';
import 'service_log.dart';

class Vehicle {
  final String id;
  final String year;
  final String make;
  final String model;
  final String nickname;

  List<Part> parts;
  List<ServiceLog> serviceLogs;

  Vehicle({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.nickname,
    List<Part>? parts,
    List<ServiceLog>? serviceLogs,
  })  : parts = parts ?? [],
        serviceLogs = serviceLogs ?? [];

  void addPart(Part part) {
    parts.add(part);
  }

  void addService(ServiceLog serviceLog) {
    serviceLogs.add(serviceLog);
  }

  // Convert from Firestore document
  factory Vehicle.fromMap(String id, Map<String, dynamic> data) {
    return Vehicle(
      id: id,
      year: data['year'] ?? '',
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      nickname: data['nickname'] ?? '',
      // parts and serviceLogs are handled separately
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'make': make,
      'model': model,
      'nickname': nickname,
      // parts and serviceLogs are not stored directly in vehicle doc
    };
  }
}
