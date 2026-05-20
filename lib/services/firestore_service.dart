
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/models/cart_item_model.dart';
import 'package:grocery_app/models/delivery_address_model.dart';
import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/models/wishlist_item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current user's UID ────────────────────────────────────────────────────
  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    return user.uid;
  }

  // ── Collection references scoped to logged-in user ────────────────────────
  CollectionReference<Map<String, dynamic>> get _cartRef =>
      _db.collection('users').doc(_uid).collection('cart');

  CollectionReference<Map<String, dynamic>> get _wishlistRef =>
      _db.collection('users').doc(_uid).collection('wishlist');

  CollectionReference<Map<String, dynamic>> get _ordersRef =>
      _db.collection('users').doc(_uid).collection('orders');

  CollectionReference<Map<String, dynamic>> get _addressRef =>
      _db.collection('users').doc(_uid).collection('addresses');

  // ── Save / update user profile on every login ─────────────────────────────
  Future<void> saveUserProfile() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).set(
      {
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'provider': user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : 'unknown',
        'lastLoginAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['createdAt'] == null) {
      await _db.collection('users').doc(user.uid).update({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ── Products (shared — not per-user) ──────────────────────────────────────
  Stream<List<ProductModel>> getProducts() {
    return _db.collection('products').snapshots().map(
          (snap) => snap.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  // ── Cart ──────────────────────────────────────────────────────────────────

  Stream<List<CartItemModel>> getCartItems() {
    return _cartRef.snapshots().map(
          (snap) => snap.docs
          .map((doc) => CartItemModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addToCart({
    required String name,
    required String weight,
    required double price,
    required String imageUrl,
  }) async {
    final existing = await _cartRef.where('name', isEqualTo: name).get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final currentQty = (doc.data()['quantity'] as num?)?.toInt() ?? 1;
      await _cartRef.doc(doc.id).update({'quantity': currentQty + 1});
    } else {
      await _cartRef.add({
        'name': name,
        'weight': weight,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> incrementCartItem(String docId, int currentQty) async {
    await _cartRef.doc(docId).update({'quantity': currentQty + 1});
  }

  Future<void> decrementCartItem(String docId, int currentQty) async {
    if (currentQty <= 1) {
      await _cartRef.doc(docId).delete();
    } else {
      await _cartRef.doc(docId).update({'quantity': currentQty - 1});
    }
  }

  Future<void> removeCartItem(String docId) async {
    await _cartRef.doc(docId).delete();
  }

  Future<void> clearCart() async {
    final snap = await _cartRef.get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Delivery Addresses ────────────────────────────────────────────────────

  Stream<List<DeliveryAddressModel>> getAddresses() {
    return _addressRef
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => DeliveryAddressModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<DeliveryAddressModel?> getDefaultAddress() async {
    final snap =
    await _addressRef.where('isDefault', isEqualTo: true).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return DeliveryAddressModel.fromMap(
        snap.docs.first.id, snap.docs.first.data());
  }

  Future<String> saveAddress(DeliveryAddressModel address) async {
    // If this is being set as default, clear existing defaults first
    if (address.isDefault) {
      await _clearDefaultAddresses();
    }

    if (address.id.isEmpty) {
      // New address
      final docRef = await _addressRef.add({
        ...address.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } else {
      // Update existing
      await _addressRef.doc(address.id).update(address.toMap());
      return address.id;
    }
  }

  Future<void> setDefaultAddress(String docId) async {
    await _clearDefaultAddresses();
    await _addressRef.doc(docId).update({'isDefault': true});
  }

  Future<void> _clearDefaultAddresses() async {
    final snap =
    await _addressRef.where('isDefault', isEqualTo: true).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    await batch.commit();
  }

  Future<void> deleteAddress(String docId) async {
    await _addressRef.doc(docId).delete();
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  Stream<List<OrderModel>> getOrders() {
    return _ordersRef
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  /// Places an order with delivery address and payment method.
  /// Returns the new order ID.
  Future<String> placeOrder({
    required DeliveryAddressModel deliveryAddress,
    required String paymentMethod,
  }) async {
    final cartSnap = await _cartRef.get();
    if (cartSnap.docs.isEmpty) throw Exception('Cart is empty');

    final items = cartSnap.docs
        .map((doc) => CartItemModel.fromMap(doc.id, doc.data()))
        .toList();

    final double total = items.fold(
      0,
          (sum, item) => sum + item.price * item.quantity,
    );

    // Generate a short readable order number
    final orderNumber = _generateOrderNumber();

    final docRef = await _ordersRef.add({
      'items': items.map((i) => i.toMap()).toList(),
      'total': total,
      'status': 'confirmed',
      'placedAt': FieldValue.serverTimestamp(),
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod,
      'orderNumber': orderNumber,
      'estimatedDelivery': _estimatedDelivery(),
    });

    await clearCart();
    return docRef.id;
  }

  String _generateOrderNumber() {
    final now = DateTime.now();
    final ms = now.millisecondsSinceEpoch.toString();
    return 'GRO-${ms.substring(ms.length - 6)}';
  }

  String _estimatedDelivery() {
    final now = DateTime.now();
    final delivery = now.add(const Duration(hours: 2));
    final h = delivery.hour > 12 ? delivery.hour - 12 : delivery.hour;
    final m = delivery.minute.toString().padLeft(2, '0');
    final ampm = delivery.hour >= 12 ? 'PM' : 'AM';
    return 'Today by $h:$m $ampm';
  }

  // ── Wishlist ──────────────────────────────────────────────────────────────

  Stream<List<WishlistItemModel>> getWishlistItems() {
    return _wishlistRef.snapshots().map(
          (snap) => snap.docs
          .map((doc) => WishlistItemModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> toggleWishlist({
    required String name,
    required String weight,
    required double price,
    required String imageUrl,
    required String category,
  }) async {
    final existing =
    await _wishlistRef.where('name', isEqualTo: name).get();

    if (existing.docs.isNotEmpty) {
      await _wishlistRef.doc(existing.docs.first.id).delete();
    } else {
      await _wishlistRef.add({
        'name': name,
        'weight': weight,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeWishlistItem(String docId) async {
    await _wishlistRef.doc(docId).delete();
  }
}