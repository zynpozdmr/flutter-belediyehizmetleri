class ServiceModel {
  final String id; 
  final String name;
  final String description;
  final String? imageUrl; 
  final String? category; 

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.category,
  });

  factory ServiceModel.fromMap(String id, Map<String, dynamic> map) {
    return ServiceModel(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      category: map['category'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}
