
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'home_data.dart';

// ── Trending Card — UNCHANGED ─────────────────────────────────────────────────
class TrendingCard extends StatelessWidget {
  final TrendingProduct product;
  const TrendingCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.name);
    final cartItem = cart.itemOf(product.name);

    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── IMAGE ──────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey[100],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              if (product.discountPercent != null)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${product.discountPercent}% OFF',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              // ADD button — only when not in cart
              if (qty == 0)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => cart.addToCart(
                      name: product.name,
                      weight: product.weight,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    ),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xffe07b39),
                        shape: BoxShape.circle,
                      ),
                      child:
                      const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),

          // ── DETAILS ────────────────────────────────────────────
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(product.weight,
                    style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rs ${product.price.toInt()}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        if (product.originalPrice != null)
                          Text(
                            'Rs ${product.originalPrice!.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    if (qty > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe07b39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => cart.decrement(
                                  cartItem!.id, cartItem.quantity),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Icon(Icons.remove,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                            Text('$qty',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            GestureDetector(
                              onTap: () => cart.increment(
                                  cartItem!.id, cartItem.quantity),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── New Arrival Card — IDENTICAL to TrendingCard, only adds NEW badge ─────────
class NewArrivalCard extends StatelessWidget {
  final NewArrivalProduct product;
  const NewArrivalCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.name);
    final cartItem = cart.itemOf(product.name);

    return Container(
      width: 155,                                   // same as TrendingCard
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),    // same
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── IMAGE ──────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,                      // same
                  width: double.infinity,
                  fit: BoxFit.cover,                // same
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey[100],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),

              // NEW badge — top-left (always shown)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xffe07b39),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Discount badge — top-right (only when discount exists)
              if (product.discountPercent != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${product.discountPercent}% OFF',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              // ADD button — same position and style as TrendingCard
              if (qty == 0)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => cart.addToCart(
                      name: product.name,
                      weight: product.weight,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    ),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xffe07b39),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),

          // ── DETAILS — identical to TrendingCard ───────────────
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(product.weight,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rs ${product.price.toInt()}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        if (product.originalPrice != null)
                          Text(
                            'Rs ${product.originalPrice!.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    if (qty > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffe07b39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => cart.decrement(
                                  cartItem!.id, cartItem.quantity),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Icon(Icons.remove,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                            Text('$qty',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            GestureDetector(
                              onTap: () => cart.increment(
                                  cartItem!.id, cartItem.quantity),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared: light-green add button pill ──────────────────────────────────────
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffE8F5E9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xff81C784), width: 1),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Color(0xff4CAF50), size: 18),
        ),
      ),
    );
  }
}

// ── Shared: orange counter pill ───────────────────────────────────────────────
class _CounterPill extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _CounterPill({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xffe07b39),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.remove, color: Colors.white, size: 14),
            ),
          ),
          Text(
            '$qty',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kept for backward compatibility ──────────────────────────────────────────
class CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CounterBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xffe07b39),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 13, color: Colors.white),
      ),
    );
  }
}