import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceLog {
  final String id;
  final String vehicleId;
  final String serviceType;
  final String description;
  final String notes;
  final DateTime date;
  final double cost;
  final List<String> partIds;

  ServiceLog({
    required this.id,
    required this.vehicleId,
    required this.serviceType,
    required this.description,
    required this.notes,
    required this.date,
    required this.cost,
    required this.partIds,
  });

  factory ServiceLog.fromMap(Map<String, dynamic> data) {
    return ServiceLog(
      id: data['id'],
      vehicleId: data['vehicleId'],
      serviceType: data['serviceType'],
      description: data['description'] ?? '',
      notes: data['notes'],
      date: (data['date'] as Timestamp).toDate(),
      cost: (data['cost'] ?? 0.0).toDouble(),
      partIds: List<String>.from(data['partIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'serviceType': serviceType,
      'description': description,
      'notes': notes,
      'date': date,
      'cost': cost,
      'partIds': partIds,
    };
  }
}
