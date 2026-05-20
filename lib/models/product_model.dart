// ── product_model.dart ────────────────────────────────────────────────────────
// Save this file as: lib/models/product_model.dart

class ProductModel {
final String id;
final String name;
final String imageUrl;
final String weight;
final double price;
final double? originalPrice;     // optional
final int? discountPercent;      // optional
final String category;

ProductModel({
required this.id,
required this.name,
required this.imageUrl,
required this.weight,
required this.price,
this.originalPrice,
this.discountPercent,
required this.category,
});

factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
return ProductModel(
id: id,
name: data['name'] ?? '',
imageUrl: data['imageUrl'] ?? '',
weight: data['weight'] ?? '',
price: (data['price'] as num?)?.toDouble() ?? 0.0,
originalPrice: (data['originalPrice'] as num?)?.toDouble(),
discountPercent: (data['discountPercent'] as num?)?.toInt(),
category: data['category'] ?? '',
);
}

Map<String, dynamic> toMap() {
return {
'name': name,
'imageUrl': imageUrl,
'weight': weight,
'price': price,
if (originalPrice != null) 'originalPrice': originalPrice,
if (discountPercent != null) 'discountPercent': discountPercent,
'category': category,
};
}
}


