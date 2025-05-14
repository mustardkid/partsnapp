class Part {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String compatibleWith;
  final double price;
  final String installDate;
  final String notes;

  Part({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.compatibleWith,
    required this.price,
    required this.installDate,
    required this.notes,
  });

  factory Part.fromMap(Map<String, dynamic> data) {
    return Part(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      category: data['category'],
      compatibleWith: data['compatibleWith'],
      price: (data['price'] ?? 0.0).toDouble(),
      installDate: data['installDate'] ?? '',
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'compatibleWith': compatibleWith,
      'price': price,
      'installDate': installDate,
      'notes': notes,
    };
  }
}
