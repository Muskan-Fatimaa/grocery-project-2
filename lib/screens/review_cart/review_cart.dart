

import 'package:flutter/material.dart';
import 'package:grocery_app/models/cart_item_model.dart';
import 'package:grocery_app/screens/delivery_address/delivery_address_page.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/services/firestore_service.dart';

class ReviewCart extends StatefulWidget {
  const ReviewCart({super.key});

  @override
  State<ReviewCart> createState() => _ReviewCartState();
}

class _ReviewCartState extends State<ReviewCart> {
  final FirestoreService _service = FirestoreService();

  // Navigate to delivery address page (no direct order placement here)
  void _goToCheckout(List<CartItemModel> items, double totalPrice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryAddressPage(
          cartItems: items,
          totalPrice: totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffe07b39),
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<CartItemModel>>(
        stream: _service.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return _buildEmptyCart();
          }

          final totalPrice = items.fold<double>(
              0, (sum, i) => sum + i.price * i.quantity);
          final totalCount =
          items.fold<int>(0, (sum, i) => sum + i.quantity);

          return Column(
            children: [
              // ── Items List ─────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: Colors.grey[100],
                                child: const Icon(Icons.image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name + weight + price
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.weight,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Rs ${(item.price * item.quantity).toInt()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffe07b39),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Counter + Remove
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffe07b39),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _service.decrementCartItem(
                                              item.id, item.quantity),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8),
                                        child: Icon(Icons.remove,
                                            color: Colors.white,
                                            size: 16),
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _service.incrementCartItem(
                                              item.id, item.quantity),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8),
                                        child: Icon(Icons.add,
                                            color: Colors.white,
                                            size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () =>
                                    _service.removeCartItem(item.id),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Order Summary + Checkout ─────────────────────────────
              SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      bottomPadding > 0 ? bottomPadding : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Total Items row
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Items',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey)),
                          Text('$totalCount',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Total Price row
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Price',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            'Rs ${totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe07b39),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ✅ Navigate to Delivery Address Page
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xffe07b39),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14)),
                            elevation: 2,
                            shadowColor: const Color(0xffe07b39)
                                .withOpacity(0.4),
                          ),
                          onPressed: () =>
                              _goToCheckout(items, totalPrice),
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_shipping_outlined,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 64, color: Color(0xffe07b39)),
            ),
            const SizedBox(height: 28),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              "Let's fill it up by adding some items!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffe07b39),
                  padding:
                  const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HomeScreen()),
                ),
                child: const Text(
                  'Start Shopping',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

