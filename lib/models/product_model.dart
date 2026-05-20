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


// ── firestore_service.dart ────────────────────────────────────────────────────
// Save this file as: lib/services/firestore_service.dart
// (Keep this in a separate file in your project — shown together here for clarity)

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/product_model.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Stream<List<ProductModel>> getProducts() {
//     return _db.collection('products').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return ProductModel.fromMap(doc.id, doc.data());
//       }).toList();
//     });
//   }
//
//   Stream<List<ProductModel>> getProductsByCategory(String category) {
//     return _db
//         .collection('products')
//         .where('category', isEqualTo: category)
//         .snapshots()
//         .map((snap) =>
//             snap.docs.map((doc) => ProductModel.fromMap(doc.id, doc.data())).toList());
//   }
//
//   Future<void> addProduct(ProductModel product) {
//     return _db.collection('products').add(product.toMap());
//   }
// }
