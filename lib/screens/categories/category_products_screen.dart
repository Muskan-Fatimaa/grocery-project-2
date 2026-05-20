import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/review_cart/review_cart.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/models/cart_item_model.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String? filterCategory;
  const CategoryProductsScreen({super.key, this.filterCategory});

  @override
  State<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final FirestoreService _service = FirestoreService();

  Map<String, List<ProductModel>> _buildGrouped(List<ProductModel> products) {
    final Map<String, List<ProductModel>> grouped = {};
    for (final p in products) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final productStream = widget.filterCategory != null
        ? _service.getProductsByCategory(widget.filterCategory!)
        : _service.getProducts();

    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffe07b39),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.filterCategory ?? 'All Products',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        actions: [
          StreamBuilder<List<CartItemModel>>(
            stream: _service.getCartItems(),
            builder: (context, snap) {
              final count =
              (snap.data ?? []).fold<int>(0, (sum, i) => sum + i.quantity);
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReviewCart()),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: Center(
                          child: Text('$count',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<List<ProductModel>>(
        stream: productStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final grouped = _buildGrouped(snapshot.data!);
          final categories = grouped.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 110),
            itemCount: categories.length,
            itemBuilder: (context, catIndex) {
              final catName = categories[catIndex];
              final products = grouped[catName]!;

              // ── Each category is a card with spacing below ────────────
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Category heading ────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xff7A3200),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        border: const Border(
                          bottom: BorderSide(
                              color: Color(0xff5C2500), width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          // White accent bar
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Category name
                          Expanded(
                            child: Text(
                              catName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          // Item count pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.45),
                                  width: 1),
                            ),
                            child: Text(
                              '${products.length} items',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Products grid ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.55,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ProductCard(
                            key: ValueKey(product.id),
                            product: product,
                            isWishlisted: wishlist.isWishlisted(product.name),
                            onWishlistToggle: () => wishlist.toggle(
                              name: product.name,
                              weight: product.weight,
                              price: product.price,
                              imageUrl: product.imageUrl,
                              category: product.category,
                            ),
                            service: _service,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // ── Bottom View Cart bar ──────────────────────────────────────────
      bottomNavigationBar: StreamBuilder<List<CartItemModel>>(
        stream: _service.getCartItems(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) return const SizedBox.shrink();

          final totalCount =
          items.fold<int>(0, (sum, i) => sum + i.quantity);
          final totalPrice =
          items.fold<double>(0, (sum, i) => sum + i.price * i.quantity);

          return SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewCart()),
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffe07b39),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffe07b39).withOpacity(0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$totalCount ${totalCount == 1 ? 'item' : 'items'}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text(
                      'View Cart  →',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rs ${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _ProductCard
// ═══════════════════════════════════════════════════════════════════════════════

class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;
  final FirestoreService service;

  const _ProductCard({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onWishlistToggle,
    required this.service,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _loading = false;

  Future<void> _addToCart() async {
    setState(() => _loading = true);
    try {
      await widget.service.addToCart(
        name: widget.product.name,
        weight: widget.product.weight,
        price: widget.product.price,
        imageUrl: widget.product.imageUrl,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount =
        p.originalPrice != null && p.originalPrice! > p.price;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image area ─────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
                child: AspectRatio(
                  aspectRatio: 1.05,
                  child: Image.network(
                    p.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 36),
                    ),
                  ),
                ),
              ),
              // Discount badge
              if (p.discountPercent != null && p.discountPercent! > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${p.discountPercent}% OFF',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              // Wishlist heart
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: widget.onWishlistToggle,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isWishlisted
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 16,
                      color:
                      widget.isWishlisted ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Text & button area ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product name
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 3),
                // Weight pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    p.weight,
                    style:
                    const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 4),
                // Price row
                Row(
                  children: [
                    Text(
                      'Rs ${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 4),
                      Text(
                        'Rs ${p.originalPrice!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                // ADD button
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe07b39),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      '+ ADD',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



