import 'package:flutter/material.dart';

// ── Product Model ─────────────────────────────────────────────────────────────

class ProductModel {
  final String name;
  final String price;
  final String unit;
  final String imageUrl;
  final String description;
  final String category;

  const ProductModel({
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.description,
    required this.category,
  });
}

// ── Product Data ──────────────────────────────────────────────────────────────

const Map<String, String> productDescriptions = {
  'Fresh Basil':
  'Originally native to India, Asia, and Africa, basil was held to be a sacred and noble herb. In fact, the word "basil" comes from the ancient Greek "basilikhon" which means "royal".\n\nToday, Ocimum basilicum (the scientific name for sweet basil) is one of the most beloved culinary herbs worldwide. It is rich in vitamins A, K, and C, and is known for its anti-inflammatory and antioxidant properties. Fresh basil adds a bright, peppery-sweet flavor to salads, pastas, and sauces.',
  'Fresh Mint':
  'Mint has been used for thousands of years for its refreshing aroma and medicinal properties. Ancient Greeks and Romans used mint to scent their baths and flavor their foods.\n\nPeppermint and spearmint are the most common varieties. Fresh mint is rich in menthol, antioxidants, and vitamins. It aids digestion, freshens breath, and soothes headaches. Perfect for teas, desserts, salads, and garnishes.',
  'Coriander':
  'Coriander (Coriandrum sativum), also known as cilantro or Chinese parsley, is one of the world\'s oldest spices — seeds have been found in ancient Egyptian tombs dating back 3,000 years.\n\nEvery part of the plant is edible. The fresh leaves (cilantro) offer a bright, citrusy flavor essential in Mexican, Indian, and Southeast Asian cuisines. Coriander is packed with vitamins C, K, and B, and has strong antimicrobial and anti-inflammatory properties.',
  'Berries':
  'Berries are nature\'s superfoods — small but extraordinarily rich in nutrients. Blueberries, strawberries, raspberries, and blackberries are among the most antioxidant-dense foods on the planet.\n\nThey are loaded with fiber, vitamins C and K, manganese, and powerful antioxidants including anthocyanins, which give berries their vibrant colors. Regular consumption is linked to improved heart health, sharper cognition, and reduced inflammation.',
  'Watermelon':
  'Watermelon (Citrullus lanatus) originated in the Kalahari Desert of Africa and has been cultivated for over 5,000 years. Ancient Egyptians placed watermelons in the tombs of kings.\n\nAbout 92% water, watermelon is one of the most hydrating fruits you can eat. It is rich in lycopene — a powerful antioxidant that gives it its red color — as well as vitamins A, B6, and C. Perfect for summer refreshment and natural hydration.',
  'Pomegranate':
  'Pomegranate (Punica granatum) is one of humanity\'s oldest fruits, cultivated since ancient times and mentioned in the Bible, Quran, and ancient Sanskrit texts. It has long symbolized prosperity and fertility.\n\nPomegranate seeds (arils) are bursting with antioxidants — particularly punicalagins and punicic acid — which are uniquely powerful. It supports heart health, reduces inflammation, may help fight prostate cancer, and is rich in fiber, vitamins C and K, folate, and potassium.',
  'Fennel':
  'Fennel (Foeniculum vulgare) is a flowering plant species in the carrot family. It originated in the Mediterranean and has been used in cooking and medicine since ancient Greek and Roman times.\n\nEvery part of the fennel plant — bulb, stalks, leaves, and seeds — is edible. It has a mild anise-like flavor and is an excellent source of fiber, vitamin C, potassium, and manganese. Fennel supports digestive health, reduces inflammation, and may have cancer-protective properties.',
  'Green Garlic':
  'Green garlic is simply young garlic harvested before the bulb has fully matured and segmented into cloves. It has a milder, fresher flavor than mature garlic with a pleasant grassy quality.\n\nLike mature garlic, green garlic contains allicin — a potent sulfur compound with antibacterial, antiviral, and antifungal properties. It is rich in vitamins C and B6, manganese, and selenium. Green garlic is a spring delicacy prized by chefs for its versatility and gentle heat.',
  'Beetroot':
  'Beetroot (Beta vulgaris) has been consumed since ancient times. The ancient Romans valued it as an aphrodisiac, and it has been used medicinally across centuries for conditions ranging from fever to digestive ailments.\n\nBeetroot is exceptionally rich in inorganic nitrates, which convert to nitric oxide in the body — widening blood vessels and lowering blood pressure. It is also packed with folate, manganese, copper, potassium, and the unique antioxidant betalain which gives beets their deep crimson color.',
};

// ── Product Overview Screen ───────────────────────────────────────────────────

class ProductOverview extends StatefulWidget {
  final ProductModel product;

  const ProductOverview({super.key, required this.product});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  int _qty = 0;
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final description =
        productDescriptions[product.name] ?? 'No description available.';

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffd6b738),
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Product Overview',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? Colors.red : Colors.black,
            ),
            onPressed: () => setState(() => _isWishlisted = !_isWishlisted),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name & Price ──────────────────────────────────────────────
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xffd6b738),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // ── Product Image ─────────────────────────────────────────────
            Center(
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image,
                          size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Available Options ─────────────────────────────────────────
            const Text(
              'Available Options',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Radio dot
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xffd6b738), width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffd6b738),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    product.unit,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '\$${product.price.split('\$').last.split('/').first.trim()}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),

                  // ADD / Counter
                  _qty == 0
                      ? GestureDetector(
                    onTap: () => setState(() => _qty = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffd6b738),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '+ ADD',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CounterBtn(
                        icon: Icons.remove,
                        onTap: () => setState(
                                () => _qty = (_qty - 1).clamp(0, 99)),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$_qty',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      _CounterBtn(
                        icon: Icons.add,
                        onTap: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── About This Product ────────────────────────────────────────
            const Text(
              'About This Product',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ── Bottom Bar ────────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add To Wishlist
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isWishlisted
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: _isWishlisted ? Colors.red : Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Add To Wishlist',
                        style:
                        TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Go To Cart
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_qty == 0) setState(() => _qty = 1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart!'),
                      backgroundColor: const Color(0xffd6b738),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  color: const Color(0xffd6b738),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Go To Cart',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Counter Button ────────────────────────────────────────────────────────────

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xffd6b738),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
