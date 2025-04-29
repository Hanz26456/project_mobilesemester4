class ServiceModel {
  final int id; // ✅ Tambahkan field id
  final String name;
  final String description;
  final double price;
  final String imageAsset;
 

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
     price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageAsset: json['image_asset'] ?? '',
    );
  }
}
