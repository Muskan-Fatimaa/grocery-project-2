class WishlistItemModel {
  final String id;
  final String name;
  final String weight;
  final double price;
  final String imageUrl;
  final String category;

  WishlistItemModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory WishlistItemModel.fromMap(
      String id, Map<String, dynamic> data) {
    return WishlistItemModel(
      id: id,
      name: data['name'] ?? '',
      weight: data['weight'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'weight': weight,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
  };
}