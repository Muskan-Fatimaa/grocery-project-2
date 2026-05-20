
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/wishlist_item_model.dart';
import 'package:grocery_app/services/firestore_service.dart';

class WishlistProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<WishlistItemModel> _items = [];
  StreamSubscription<List<WishlistItemModel>>? _sub;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<WishlistItemModel> get items => _items;

  int get totalCount => _items.length;

  bool isWishlisted(String name) => _items.any((i) => i.name == name);

  WishlistItemModel? itemOf(String name) {
    try {
      return _items.firstWhere((i) => i.name == name);
    } catch (_) {
      return null;
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Call after user logs in — subscribes to the Firestore wishlist stream.
  void startListening() {
    _sub?.cancel();
    _sub = _service.getWishlistItems().listen((items) {
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

  Future<void> toggle({
    required String name,
    required String weight,
    required double price,
    required String imageUrl,
    required String category,
  }) =>
      _service.toggleWishlist(
        name: name,
        weight: weight,
        price: price,
        imageUrl: imageUrl,
        category: category,
      );

  Future<void> remove(String docId) => _service.removeWishlistItem(docId);

  // ── Static helper ──────────────────────────────────────────────────────────

  static WishlistProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<WishlistProvider>(context, listen: listen);
}