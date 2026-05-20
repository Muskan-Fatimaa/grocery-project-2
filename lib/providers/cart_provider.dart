

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/cart_item_model.dart';
import 'package:grocery_app/services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<CartItemModel> _items = [];
  StreamSubscription<List<CartItemModel>>? _sub;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<CartItemModel> get items => _items;

  int get totalCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  int quantityOf(String name) {
    try {
      return _items.firstWhere((i) => i.name == name).quantity;
    } catch (_) {
      return 0;
    }
  }

  CartItemModel? itemOf(String name) {
    try {
      return _items.firstWhere((i) => i.name == name);
    } catch (_) {
      return null;
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Call after user logs in — subscribes to the Firestore cart stream.
  void startListening() {
    _sub?.cancel();
    _sub = _service.getCartItems().listen((items) {
      _items = items;
      notifyListeners();
    });
  }

  /// Call after user logs out — cancels subscription and clears local state.
  void reset() {
    _sub?.cancel();
    _sub = null;
    _items = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // ── Write operations ───────────────────────────────────────────────────────
  // All writes go directly to Firestore.
  // Firestore update → stream fires → _items updates → notifyListeners()

  Future<void> addToCart({
    required String name,
    required String weight,
    required double price,
    required String imageUrl,
  }) =>
      _service.addToCart(
        name: name,
        weight: weight,
        price: price,
        imageUrl: imageUrl,
      );

  Future<void> increment(String docId, int currentQty) =>
      _service.incrementCartItem(docId, currentQty);

  Future<void> decrement(String docId, int currentQty) =>
      _service.decrementCartItem(docId, currentQty);

  Future<void> remove(String docId) => _service.removeCartItem(docId);

  // NOTE: placeOrder() is intentionally removed from CartProvider.
  // Order placement now happens in DeliveryAddressPage via FirestoreService
  // directly, because it requires a deliveryAddress and paymentMethod.

  // ── Static helper ──────────────────────────────────────────────────────────

  static CartProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<CartProvider>(context, listen: listen);
}