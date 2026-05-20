class CartItemModel {
  final String id;
  final String name;
  final String weight;
  final double price;
  final String imageUrl;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory CartItemModel.fromMap(String id, Map<String, dynamic> data) {
    return CartItemModel(
      id: id,
      name: data['name'] ?? '',
      weight: data['weight'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'weight': weight,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
  };
}