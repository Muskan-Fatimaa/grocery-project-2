

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:grocery_app/providers/cart_provider.dart';
// import 'package:grocery_app/providers/wishlist_provider.dart';
// import 'package:grocery_app/screens/home/drawer_side.dart';
// import 'package:grocery_app/screens/search/search.dart';
// import 'package:grocery_app/screens/categories/category_products_screen.dart';
// import 'package:grocery_app/widgets/category_accordion_row.dart';
// import 'package:grocery_app/screens/review_cart/review_cart.dart';
//  import 'package:grocery_app/screens/wishlist/wishlist.dart';
// import 'package:grocery_app/services/firestore_service.dart';
// import 'package:grocery_app/models/product_model.dart';
// import 'home_data.dart';
// import 'home_widget.dart';
//
// const List<String> _midBannerImages = [
//   'https://pictures.grocerapps.com/original/grocerapp-lipton-69c609e00dd8f.jpeg',
//   'https://pictures.grocerapps.com/original/grocerapp-qarshi-69ce3943e0cc1.png',
//   'https://pictures.grocerapps.com/original/grocerapp-dipitt-69ce38dd91934.jpeg',
// ];
//
// // ═══════════════════════════════════════════════════════════════════════════
// // TRENDING LIST — separate widget so banner rebuilds never touch it
// // ═══════════════════════════════════════════════════════════════════════════
// class _TrendingProductsList extends StatefulWidget {
//   const _TrendingProductsList();
//
//   @override
//   State<_TrendingProductsList> createState() =>
//       _TrendingProductsListState();
// }
//
// class _TrendingProductsListState
//     extends State<_TrendingProductsList> {
//   final FirestoreService _service = FirestoreService();
//   List<ProductModel> _products = [];
//   StreamSubscription<List<ProductModel>>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     _sub = _service.getProducts().listen((products) {
//       if (mounted) setState(() => _products = products);
//     });
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_products.isEmpty) {
//       return const SizedBox(
//         height: 235,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return SizedBox(
//       height: 235,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: _products.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final p = _products[index];
//           return TrendingCard(
//             product: TrendingProduct(
//               name: p.name,
//               weight: p.weight,
//               price: p.price,
//               imageUrl: p.imageUrl,
//               originalPrice: p.originalPrice,
//               discountPercent: p.discountPercent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════
// // HOME SCREEN
// // ═══════════════════════════════════════════════════════════════════════════
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentBanner = 0;
//   final PageController _bannerController =
//   PageController(viewportFraction: 0.88);
//   Timer? _bannerTimer;
//
//   int _currentMidBanner = 0;
//   final PageController _midBannerController = PageController();
//   Timer? _midBannerTimer;
//
//   int _expandedCategoryIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBannerAutoSlide();
//     _startMidBannerAutoSlide();
//   }
//
//   void _startBannerAutoSlide() {
//     _bannerTimer =
//         Timer.periodic(const Duration(seconds: 3), (_) {
//           if (!mounted) return;
//           final next = (_currentBanner + 1) % homeBanners.length;
//           _bannerController.animateToPage(next,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut);
//         });
//   }
//
//   void _startMidBannerAutoSlide() {
//     _midBannerTimer =
//         Timer.periodic(const Duration(seconds: 3), (_) {
//           if (!mounted) return;
//           final next =
//               (_currentMidBanner + 1) % _midBannerImages.length;
//           _midBannerController.animateToPage(next,
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut);
//         });
//   }
//
//   @override
//   void dispose() {
//     _bannerTimer?.cancel();
//     _midBannerTimer?.cancel();
//     _bannerController.dispose();
//     _midBannerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       drawer: DrawerSide(),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffe07b39),
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.white),
//         titleSpacing: 0,
//         title: GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) =>
//                     Search(allProducts: const [])),
//           ),
//           child: Container(
//             height: 40,
//             margin: const EdgeInsets.only(left: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xffF5F5F5),
//               borderRadius: BorderRadius.circular(22),
//               border:
//               Border.all(color: Colors.grey.shade300),
//             ),
//             child: const Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search,
//                     color: Colors.grey, size: 20),
//                 SizedBox(width: 8),
//                 Text('What are you looking for?',
//                     style: TextStyle(
//                         color: Colors.grey, fontSize: 14)),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           // ── Wishlist badge ─────────────────────────────────────
//           Selector<WishlistProvider, int>(
//             selector: (_, w) => w.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.favorite_border,
//                         color: Colors.white, size: 26),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) =>
//                            WishlistPage()),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 6,
//                       right: 6,
//                       child: Container(
//                         width: 15,
//                         height: 15,
//                         decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 9)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//
//           // ── Cart badge ─────────────────────────────────────────
//           Selector<CartProvider, int>(
//             selector: (_, cart) => cart.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) =>
//                           const ReviewCart()),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 8),
//                       child: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Colors.white,
//                           size: 28),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 4,
//                       right: 6,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ════════════════════════════════════════════
//             // 1. TOP BANNER
//             // ════════════════════════════════════════════
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 165,
//               child: PageView.builder(
//                 controller: _bannerController,
//                 itemCount: homeBanners.length,
//                 onPageChanged: (i) =>
//                     setState(() => _currentBanner = i),
//                 itemBuilder: (context, index) {
//                   final b = homeBanners[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 5),
//                     child: ClipRRect(
//                       borderRadius:
//                       BorderRadius.circular(12),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.network(b['imageUrl']!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   Container(
//                                       color: const Color(
//                                           0xffd6b738))),
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.black
//                                       .withOpacity(0.55),
//                                   Colors.transparent,
//                                 ],
//                                 begin:
//                                 Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment
//                                       .start,
//                                   children: [
//                                     Container(
//                                       height: 56,
//                                       width: 68,
//                                       decoration:
//                                       const BoxDecoration(
//                                         color: Color(
//                                             0xffd1ad17),
//                                         borderRadius:
//                                         BorderRadius
//                                             .only(
//                                           bottomRight: Radius
//                                               .circular(50),
//                                           bottomLeft: Radius
//                                               .circular(50),
//                                         ),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           b['label']!,
//                                           style: const TextStyle(
//                                               fontSize: 17,
//                                               color: Colors
//                                                   .white,
//                                               fontWeight:
//                                               FontWeight
//                                                   .bold),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets
//                                           .only(left: 12),
//                                       child: Text(
//                                         b['discount']!,
//                                         style: TextStyle(
//                                           fontSize: 32,
//                                           color: Colors
//                                               .green[300],
//                                           fontWeight:
//                                           FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets
//                                           .only(left: 14),
//                                       child: Text(
//                                         b['subtitle']!,
//                                         style: const TextStyle(
//                                             color:
//                                             Colors.green,
//                                             fontSize: 12),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Expanded(
//                                   child: SizedBox()),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 homeBanners.length,
//                     (i) => AnimatedContainer(
//                   duration:
//                   const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 3),
//                   width: _currentBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 14),
//
//             // ════════════════════════════════════════════
//             // 2. TRENDING PRODUCTS
//             // ════════════════════════════════════════════
//             Container(
//               color: Colors.white,
//               padding:
//               const EdgeInsets.fromLTRB(14, 14, 0, 14),
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:
//                     const EdgeInsets.only(right: 14),
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Trending Products',
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87)),
//                         GestureDetector(
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) =>
//                                     CategoryProductsScreen()),
//                           ),
//                           child: const Row(
//                             children: [
//                               Text('View all',
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       color:
//                                       Colors.black54)),
//                               Icon(Icons.arrow_forward,
//                                   size: 16,
//                                   color: Colors.black54),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const _TrendingProductsList(),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // ════════════════════════════════════════════
//             // 3. SHOP BY CATEGORIES
//             // ════════════════════════════════════════════
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 14, vertical: 4),
//               child: Row(
//                 mainAxisAlignment:
//                 MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Shop by Categories',
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87)),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) =>
//                               CategoryProductsScreen()),
//                     ),
//                     child: const Row(
//                       children: [
//                         Text('View all',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.black54)),
//                         Icon(Icons.arrow_forward,
//                             size: 16,
//                             color: Colors.black54),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 4),
//
//             ...List.generate(homeCategories.length,
//                     (index) {
//                   return CategoryAccordionRow(
//                     category: homeCategories[index],
//                     isExpanded:
//                     _expandedCategoryIndex == index,
//                     onTap: () => setState(
//                           () => _expandedCategoryIndex =
//                       _expandedCategoryIndex == index
//                           ? -1
//                           : index,
//                     ),
//                   );
//                 }),
//
//             const SizedBox(height: 16),
//
//             // ════════════════════════════════════════════
//             // 4. MID BANNER
//             // ════════════════════════════════════════════
//             SizedBox(
//               height: 260,
//               child: PageView.builder(
//                 controller: _midBannerController,
//                 itemCount: _midBannerImages.length,
//                 onPageChanged: (i) => setState(
//                         () => _currentMidBanner = i),
//                 itemBuilder: (context, index) =>
//                     Image.network(
//                       _midBannerImages[index],
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       errorBuilder: (_, __, ___) =>
//                           Container(color: Colors.grey[200]),
//                     ),
//               ),
//             ),
//
//             // Mid banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _midBannerImages.length,
//                     (i) => AnimatedContainer(
//                   duration:
//                   const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 3),
//                   width: _currentMidBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentMidBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ════════════════════════════════════════════
//             // 5. WHY SHOP WITH US
//             // ════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(
//                   horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color:
//                       Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text("Why Shop With Us?",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       _whyShopTile(
//                           icon: Icons
//                               .local_shipping_outlined,
//                           label: 'Fast Delivery',
//                           color:
//                           const Color(0xff4CAF50)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.verified_outlined,
//                           label: 'Quality Assured',
//                           color:
//                           const Color(0xffe07b39)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.currency_rupee,
//                           label: 'Best Prices',
//                           color:
//                           const Color(0xff2196F3)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffF6F6F6),
//                       borderRadius:
//                       BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 65,
//                           width: 65,
//                           decoration: const BoxDecoration(
//                             color: Color(0xffe07b39),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                               Icons.support_agent,
//                               color: Colors.white,
//                               size: 32),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text("HAVE QUESTIONS?",
//                             style: TextStyle(
//                                 fontWeight:
//                                 FontWeight.bold,
//                                 fontSize: 15)),
//                         const SizedBox(height: 5),
//                         const Text(
//                           "Excellent Customer Service – We're here and happy to help!",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // ════════════════════════════════════════════
//             // 6. CONTACT US
//             // ════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(
//                   horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color:
//                       Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: const Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//                 children: [
//                   Text("CONTACT US",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.phone,
//                         color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("0348 9991979 / 0334 8788950"),
//                   ]),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.email,
//                         color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("customerservice@qne.com.pk"),
//                   ]),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _whyShopTile({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(10),
//           border:
//           Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 26),
//             const SizedBox(height: 6),
//             Text(label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 11,
//                     color: color,
//                     fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:grocery_app/providers/cart_provider.dart';
// import 'package:grocery_app/providers/wishlist_provider.dart';
// import 'package:grocery_app/screens/home/drawer_side.dart';
// import 'package:grocery_app/screens/search/search.dart';
// import 'package:grocery_app/screens/categories/category_products_screen.dart';
// import 'package:grocery_app/widgets/category_accordion_row.dart';
// import 'package:grocery_app/screens/review_cart/review_cart.dart';
// import 'package:grocery_app/screens/wishlist/wishlist.dart';
// import 'package:grocery_app/services/firestore_service.dart';
// import 'package:grocery_app/models/product_model.dart';
// import 'home_data.dart';
// import 'home_widget.dart';
//
// const List<String> _midBannerImages = [
//   'https://pictures.grocerapps.com/original/grocerapp-lipton-69c609e00dd8f.jpeg',
//   'https://pictures.grocerapps.com/original/grocerapp-qarshi-69ce3943e0cc1.png',
//   'https://pictures.grocerapps.com/original/grocerapp-dipitt-69ce38dd91934.jpeg',
// ];
//
// // ══════════════════════════════════════════════════════════════════════════════
// // TRENDING PRODUCTS LIST  — live from Firestore
// // ══════════════════════════════════════════════════════════════════════════════
// class _TrendingProductsList extends StatefulWidget {
//   const _TrendingProductsList();
//
//   @override
//   State<_TrendingProductsList> createState() => _TrendingProductsListState();
// }
//
// class _TrendingProductsListState extends State<_TrendingProductsList> {
//   final FirestoreService _service = FirestoreService();
//   List<ProductModel> _products = [];
//   StreamSubscription<List<ProductModel>>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     _sub = _service.getProducts().listen((products) {
//       if (mounted) setState(() => _products = products);
//     });
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_products.isEmpty) {
//       return const SizedBox(
//         height: 248,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return SizedBox(
//       height: 248,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 14),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: _products.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final p = _products[index];
//           return TrendingCard(
//             product: TrendingProduct(
//               name: p.name,
//               weight: p.weight,
//               price: p.price,
//               imageUrl: p.imageUrl,
//               originalPrice: p.originalPrice,
//               discountPercent: p.discountPercent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // NEW ARRIVALS LIST  — live from Firestore (last 8 products by timestamp)
// // ══════════════════════════════════════════════════════════════════════════════
// class _NewArrivalsList extends StatefulWidget {
//   const _NewArrivalsList();
//
//   @override
//   State<_NewArrivalsList> createState() => _NewArrivalsListState();
// }
//
// class _NewArrivalsListState extends State<_NewArrivalsList> {
//   final FirestoreService _service = FirestoreService();
//   List<ProductModel> _products = [];
//   StreamSubscription<List<ProductModel>>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     // Re-use getProducts but reverse to get "newest" first (Firestore order).
//     // If you later add a 'createdAt' index, swap for a proper query.
//     _sub = _service.getProducts().listen((products) {
//       if (mounted) {
//         setState(() {
//           // Show products in reverse order so last-added appear first
//           _products = products.reversed.take(12).toList();
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_products.isEmpty) {
//       return const SizedBox(
//         height: 248,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return SizedBox(
//       height: 248,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 14),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: _products.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final p = _products[index];
//           return NewArrivalCard(
//             product: NewArrivalProduct(
//               name: p.name,
//               weight: p.weight,
//               price: p.price,
//               imageUrl: p.imageUrl,
//               originalPrice: p.originalPrice,
//               discountPercent: p.discountPercent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // HOME SCREEN
// // ══════════════════════════════════════════════════════════════════════════════
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentBanner = 0;
//   final PageController _bannerController =
//   PageController(viewportFraction: 0.88);
//   Timer? _bannerTimer;
//
//   int _currentMidBanner = 0;
//   final PageController _midBannerController = PageController();
//   Timer? _midBannerTimer;
//
//   int _expandedCategoryIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBannerAutoSlide();
//     _startMidBannerAutoSlide();
//   }
//
//   void _startBannerAutoSlide() {
//     _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       if (!mounted) return;
//       final next = (_currentBanner + 1) % homeBanners.length;
//       _bannerController.animateToPage(next,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut);
//     });
//   }
//
//   void _startMidBannerAutoSlide() {
//     _midBannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       if (!mounted) return;
//       final next = (_currentMidBanner + 1) % _midBannerImages.length;
//       _midBannerController.animateToPage(next,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut);
//     });
//   }
//
//   @override
//   void dispose() {
//     _bannerTimer?.cancel();
//     _midBannerTimer?.cancel();
//     _bannerController.dispose();
//     _midBannerController.dispose();
//     super.dispose();
//   }
//
//   // ── Section header helper ────────────────────────────────────────────────
//   Widget _sectionHeader({
//     required String title,
//     required VoidCallback onViewAll,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87),
//           ),
//           GestureDetector(
//             onTap: onViewAll,
//             child: const Text(
//               'View All',
//               style: TextStyle(
//                   fontSize: 13,
//                   color: Color(0xff4CAF50),
//                   fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       drawer: DrawerSide(),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffe07b39),
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.white),
//         titleSpacing: 0,
//         title: GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => Search(allProducts: const [])),
//           ),
//           child: Container(
//             height: 40,
//             margin: const EdgeInsets.only(left: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xffF5F5F5),
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: const Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search, color: Colors.grey, size: 20),
//                 SizedBox(width: 8),
//                 Text('What are you looking for?',
//                     style: TextStyle(color: Colors.grey, fontSize: 14)),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           // ── Wishlist badge ───────────────────────────────────────────
//           Selector<WishlistProvider, int>(
//             selector: (_, w) => w.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.favorite_border,
//                         color: Colors.white, size: 26),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => WishlistPage()),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 6,
//                       right: 6,
//                       child: Container(
//                         width: 15,
//                         height: 15,
//                         decoration: const BoxDecoration(
//                             color: Colors.red, shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white, fontSize: 9)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//
//           // ── Cart badge ───────────────────────────────────────────────
//           Selector<CartProvider, int>(
//             selector: (_, cart) => cart.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const ReviewCart()),
//                     ),
//                     child: const Padding(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                       child: Icon(Icons.shopping_cart_outlined,
//                           color: Colors.white, size: 28),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 4,
//                       right: 6,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                             color: Colors.green, shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white, fontSize: 10)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ══════════════════════════════════════════════════════════
//             // 1. TOP BANNER SLIDER
//             // ══════════════════════════════════════════════════════════
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 165,
//               child: PageView.builder(
//                 controller: _bannerController,
//                 itemCount: homeBanners.length,
//                 onPageChanged: (i) => setState(() => _currentBanner = i),
//                 itemBuilder: (context, index) {
//                   final b = homeBanners[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.network(b['imageUrl']!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Container(
//                                   color: const Color(0xffd6b738))),
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.black.withOpacity(0.55),
//                                   Colors.transparent,
//                                 ],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: 56,
//                                       width: 68,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xffd1ad17),
//                                         borderRadius: BorderRadius.only(
//                                           bottomRight: Radius.circular(50),
//                                           bottomLeft: Radius.circular(50),
//                                         ),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           b['label']!,
//                                           style: const TextStyle(
//                                               fontSize: 17,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(left: 12),
//                                       child: Text(
//                                         b['discount']!,
//                                         style: TextStyle(
//                                           fontSize: 32,
//                                           color: Colors.green[300],
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(left: 14),
//                                       child: Text(
//                                         b['subtitle']!,
//                                         style: const TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 12),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Expanded(child: SizedBox()),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 homeBanners.length,
//                     (i) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 14),
//
//             // ══════════════════════════════════════════════════════════
//             // 2. TRENDING PRODUCTS
//             // ══════════════════════════════════════════════════════════
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _sectionHeader(
//                     title: 'Trending Products',
//                     onViewAll: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                   ),
//                   const _TrendingProductsList(),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // ══════════════════════════════════════════════════════════
//             // 3. SHOP BY CATEGORIES
//             // ══════════════════════════════════════════════════════════
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Shop by Categories',
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87)),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                     child: const Text(
//                       'View All',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Color(0xff4CAF50),
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 4),
//
//             ...List.generate(homeCategories.length, (index) {
//               return CategoryAccordionRow(
//                 category: homeCategories[index],
//                 isExpanded: _expandedCategoryIndex == index,
//                 onTap: () => setState(
//                       () => _expandedCategoryIndex =
//                   _expandedCategoryIndex == index ? -1 : index,
//                 ),
//               );
//             }),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 4. PROMO BANNER  (dark-green, like reference image 2)
//             // ══════════════════════════════════════════════════════════
//             _PromoBanner(
//               onOrderTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => CategoryProductsScreen()),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 5. NEW ARRIVALS  (second product row — live from Firestore)
//             // ══════════════════════════════════════════════════════════
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _sectionHeader(
//                     title: 'New Arrivals',
//                     onViewAll: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                   ),
//                   const _NewArrivalsList(),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 6. MID BANNER
//             // ══════════════════════════════════════════════════════════
//             SizedBox(
//               height: 260,
//               child: PageView.builder(
//                 controller: _midBannerController,
//                 itemCount: _midBannerImages.length,
//                 onPageChanged: (i) =>
//                     setState(() => _currentMidBanner = i),
//                 itemBuilder: (context, index) => Image.network(
//                   _midBannerImages[index],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (_, __, ___) =>
//                       Container(color: Colors.grey[200]),
//                 ),
//               ),
//             ),
//
//             // Mid banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _midBannerImages.length,
//                     (i) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentMidBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentMidBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 7. WHY SHOP WITH US
//             // ══════════════════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text("Why Shop With Us?",
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       _whyShopTile(
//                           icon: Icons.local_shipping_outlined,
//                           label: 'Fast Delivery',
//                           color: const Color(0xff4CAF50)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.verified_outlined,
//                           label: 'Quality Assured',
//                           color: const Color(0xffe07b39)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.currency_rupee,
//                           label: 'Best Prices',
//                           color: const Color(0xff2196F3)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffF6F6F6),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 65,
//                           width: 65,
//                           decoration: const BoxDecoration(
//                             color: Color(0xffe07b39),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.support_agent,
//                               color: Colors.white, size: 32),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text("HAVE QUESTIONS?",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15)),
//                         const SizedBox(height: 5),
//                         const Text(
//                           "Excellent Customer Service – We're here and happy to help!",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // ══════════════════════════════════════════════════════════
//             // 8. CONTACT US
//             // ══════════════════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("CONTACT US",
//                       style: TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.phone, color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("0348 9991979 / 0334 8788950"),
//                   ]),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.email, color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("customerservice@qne.com.pk"),
//                   ]),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _whyShopTile({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 26),
//             const SizedBox(height: 6),
//             Text(label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 11,
//                     color: color,
//                     fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // PROMO BANNER  — dark green card inspired by reference image 2
// // ══════════════════════════════════════════════════════════════════════════════
// class _PromoBanner extends StatelessWidget {
//   final VoidCallback onOrderTap;
//   const _PromoBanner({required this.onOrderTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       height: 120,
//       decoration: BoxDecoration(
//         color: const Color(0xff1B5E20), // deep green
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xff1B5E20).withOpacity(0.35),
//             blurRadius: 12,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Row(
//           children: [
//             // ── Text side ─────────────────────────────────────────
//             Expanded(
//               flex: 5,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Order Groceries\nfor Same Day Delivery',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: onOrderTap,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 7),
//                         decoration: BoxDecoration(
//                           color: const Color(0xff4CAF50),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text(
//                           'Order today',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Grocery image side ────────────────────────────────
//             Expanded(
//               flex: 4,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
//                   fit: BoxFit.cover,
//                   height: double.infinity,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: const Color(0xff2E7D32),
//                     child: const Icon(Icons.local_grocery_store,
//                         color: Colors.white54, size: 48),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//





// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:grocery_app/providers/cart_provider.dart';
// import 'package:grocery_app/providers/wishlist_provider.dart';
// import 'package:grocery_app/screens/home/drawer_side.dart';
// import 'package:grocery_app/screens/search/search.dart';
// import 'package:grocery_app/screens/categories/category_products_screen.dart';
// import 'package:grocery_app/widgets/category_accordion_row.dart';
// import 'package:grocery_app/screens/review_cart/review_cart.dart';
// import 'package:grocery_app/screens/wishlist/wishlist.dart';
// import 'package:grocery_app/services/firestore_service.dart';
// import 'package:grocery_app/models/product_model.dart';
// import 'home_data.dart';
// import 'home_widget.dart';
//
// const List<String> _midBannerImages = [
//   'https://pictures.grocerapps.com/original/grocerapp-lipton-69c609e00dd8f.jpeg',
//   'https://pictures.grocerapps.com/original/grocerapp-qarshi-69ce3943e0cc1.png',
//   'https://pictures.grocerapps.com/original/grocerapp-dipitt-69ce38dd91934.jpeg',
// ];
//
// // ══════════════════════════════════════════════════════════════════════════════
// // TRENDING PRODUCTS LIST  — live from Firestore
// // ══════════════════════════════════════════════════════════════════════════════
// class _TrendingProductsList extends StatefulWidget {
//   const _TrendingProductsList();
//
//   @override
//   State<_TrendingProductsList> createState() => _TrendingProductsListState();
// }
//
// class _TrendingProductsListState extends State<_TrendingProductsList> {
//   final FirestoreService _service = FirestoreService();
//   List<ProductModel> _products = [];
//   StreamSubscription<List<ProductModel>>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     _sub = _service.getProducts().listen((products) {
//       if (mounted) setState(() => _products = products);
//     });
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_products.isEmpty) {
//       return const SizedBox(
//         height: 248,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return SizedBox(
//       height: 248,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 14),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: _products.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final p = _products[index];
//           return TrendingCard(
//             product: TrendingProduct(
//               name: p.name,
//               weight: p.weight,
//               price: p.price,
//               imageUrl: p.imageUrl,
//               originalPrice: p.originalPrice,
//               discountPercent: p.discountPercent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // NEW ARRIVALS LIST  — live from Firestore (last 8 products by timestamp)
// // ══════════════════════════════════════════════════════════════════════════════
// class _NewArrivalsList extends StatefulWidget {
//   const _NewArrivalsList();
//
//   @override
//   State<_NewArrivalsList> createState() => _NewArrivalsListState();
// }
//
// class _NewArrivalsListState extends State<_NewArrivalsList> {
//   final FirestoreService _service = FirestoreService();
//   List<ProductModel> _products = [];
//   StreamSubscription<List<ProductModel>>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     // Re-use getProducts but reverse to get "newest" first (Firestore order).
//     // If you later add a 'createdAt' index, swap for a proper query.
//     _sub = _service.getProducts().listen((products) {
//       if (mounted) {
//         setState(() {
//           // Show products in reverse order so last-added appear first
//           _products = products.reversed.take(12).toList();
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_products.isEmpty) {
//       return const SizedBox(
//         height: 248,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return SizedBox(
//       height: 248,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 14),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: _products.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final p = _products[index];
//           return NewArrivalCard(
//             product: NewArrivalProduct(
//               name: p.name,
//               weight: p.weight,
//               price: p.price,
//               imageUrl: p.imageUrl,
//               originalPrice: p.originalPrice,
//               discountPercent: p.discountPercent,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // HOME SCREEN
// // ══════════════════════════════════════════════════════════════════════════════
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _currentBanner = 0;
//   final PageController _bannerController =
//   PageController(viewportFraction: 0.88);
//   Timer? _bannerTimer;
//
//   int _currentMidBanner = 0;
//   final PageController _midBannerController = PageController();
//   Timer? _midBannerTimer;
//
//   int _expandedCategoryIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBannerAutoSlide();
//     _startMidBannerAutoSlide();
//   }
//
//   void _startBannerAutoSlide() {
//     _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       if (!mounted) return;
//       final next = (_currentBanner + 1) % homeBanners.length;
//       _bannerController.animateToPage(next,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut);
//     });
//   }
//
//   void _startMidBannerAutoSlide() {
//     _midBannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       if (!mounted) return;
//       final next = (_currentMidBanner + 1) % _midBannerImages.length;
//       _midBannerController.animateToPage(next,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut);
//     });
//   }
//
//   @override
//   void dispose() {
//     _bannerTimer?.cancel();
//     _midBannerTimer?.cancel();
//     _bannerController.dispose();
//     _midBannerController.dispose();
//     super.dispose();
//   }
//
//   // ── Section header helper ────────────────────────────────────────────────
//   Widget _sectionHeader({
//     required String title,
//     required VoidCallback onViewAll,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87),
//           ),
//           GestureDetector(
//             onTap: onViewAll,
//             child: const Text(
//               'View All',
//               style: TextStyle(
//                   fontSize: 13,
//                   color: Color(0xff4CAF50),
//                   fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       drawer: DrawerSide(),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffe07b39),
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.white),
//         titleSpacing: 0,
//         title: GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => Search(allProducts: const [])),
//           ),
//           child: Container(
//             height: 40,
//             margin: const EdgeInsets.only(left: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xffF5F5F5),
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: const Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search, color: Colors.grey, size: 20),
//                 SizedBox(width: 8),
//                 Text('What are you looking for?',
//                     style: TextStyle(color: Colors.grey, fontSize: 14)),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           // ── Wishlist badge ───────────────────────────────────────────
//           Selector<WishlistProvider, int>(
//             selector: (_, w) => w.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.favorite_border,
//                         color: Colors.white, size: 26),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => WishlistPage()),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 6,
//                       right: 6,
//                       child: Container(
//                         width: 15,
//                         height: 15,
//                         decoration: const BoxDecoration(
//                             color: Colors.red, shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white, fontSize: 9)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//
//           // ── Cart badge ───────────────────────────────────────────────
//           Selector<CartProvider, int>(
//             selector: (_, cart) => cart.totalCount,
//             builder: (context, count, _) {
//               return Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const ReviewCart()),
//                     ),
//                     child: const Padding(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                       child: Icon(Icons.shopping_cart_outlined,
//                           color: Colors.white, size: 28),
//                     ),
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       top: 4,
//                       right: 6,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                             color: Colors.green, shape: BoxShape.circle),
//                         child: Center(
//                           child: Text('$count',
//                               style: const TextStyle(
//                                   color: Colors.white, fontSize: 10)),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ══════════════════════════════════════════════════════════
//             // 1. TOP BANNER SLIDER
//             // ══════════════════════════════════════════════════════════
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 165,
//               child: PageView.builder(
//                 controller: _bannerController,
//                 itemCount: homeBanners.length,
//                 onPageChanged: (i) => setState(() => _currentBanner = i),
//                 itemBuilder: (context, index) {
//                   final b = homeBanners[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.network(b['imageUrl']!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Container(
//                                   color: const Color(0xffd6b738))),
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.black.withOpacity(0.55),
//                                   Colors.transparent,
//                                 ],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: 56,
//                                       width: 68,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xffd1ad17),
//                                         borderRadius: BorderRadius.only(
//                                           bottomRight: Radius.circular(50),
//                                           bottomLeft: Radius.circular(50),
//                                         ),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           b['label']!,
//                                           style: const TextStyle(
//                                               fontSize: 17,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(left: 12),
//                                       child: Text(
//                                         b['discount']!,
//                                         style: TextStyle(
//                                           fontSize: 32,
//                                           color: Colors.green[300],
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(left: 14),
//                                       child: Text(
//                                         b['subtitle']!,
//                                         style: const TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 12),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Expanded(child: SizedBox()),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 homeBanners.length,
//                     (i) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 14),
//
//             // ══════════════════════════════════════════════════════════
//             // 2. TRENDING PRODUCTS
//             // ══════════════════════════════════════════════════════════
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _sectionHeader(
//                     title: 'Trending Products',
//                     onViewAll: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                   ),
//                   const _TrendingProductsList(),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // ══════════════════════════════════════════════════════════
//             // 3. SHOP BY CATEGORIES
//             // ══════════════════════════════════════════════════════════
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Shop by Categories',
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87)),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                     child: const Text(
//                       'View All',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Color(0xff4CAF50),
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 4),
//
//             ...List.generate(homeCategories.length, (index) {
//               return CategoryAccordionRow(
//                 category: homeCategories[index],
//                 isExpanded: _expandedCategoryIndex == index,
//                 onTap: () => setState(
//                       () => _expandedCategoryIndex =
//                   _expandedCategoryIndex == index ? -1 : index,
//                 ),
//               );
//             }),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 4. PROMO BANNER  (dark-green, like reference image 2)
//             // ══════════════════════════════════════════════════════════
//             _PromoBanner(
//               onOrderTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => CategoryProductsScreen()),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 5. NEW ARRIVALS  (second product row — live from Firestore)
//             // ══════════════════════════════════════════════════════════
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _sectionHeader(
//                     title: 'New Arrivals',
//                     onViewAll: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => CategoryProductsScreen()),
//                     ),
//                   ),
//                   const _NewArrivalsList(),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 6. MID BANNER
//             // ══════════════════════════════════════════════════════════
//             SizedBox(
//               height: 260,
//               child: PageView.builder(
//                 controller: _midBannerController,
//                 itemCount: _midBannerImages.length,
//                 onPageChanged: (i) =>
//                     setState(() => _currentMidBanner = i),
//                 itemBuilder: (context, index) => Image.network(
//                   _midBannerImages[index],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (_, __, ___) =>
//                       Container(color: Colors.grey[200]),
//                 ),
//               ),
//             ),
//
//             // Mid banner dots
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _midBannerImages.length,
//                     (i) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentMidBanner == i ? 18 : 7,
//                   height: 7,
//                   decoration: BoxDecoration(
//                     color: _currentMidBanner == i
//                         ? const Color(0xffe07b39)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // ══════════════════════════════════════════════════════════
//             // 7. WHY SHOP WITH US
//             // ══════════════════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text("Why Shop With Us?",
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       _whyShopTile(
//                           icon: Icons.local_shipping_outlined,
//                           label: 'Fast Delivery',
//                           color: const Color(0xff4CAF50)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.verified_outlined,
//                           label: 'Quality Assured',
//                           color: const Color(0xffe07b39)),
//                       const SizedBox(width: 10),
//                       _whyShopTile(
//                           icon: Icons.currency_rupee,
//                           label: 'Best Prices',
//                           color: const Color(0xff2196F3)),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffF6F6F6),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 65,
//                           width: 65,
//                           decoration: const BoxDecoration(
//                             color: Color(0xffe07b39),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.support_agent,
//                               color: Colors.white, size: 32),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text("HAVE QUESTIONS?",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15)),
//                         const SizedBox(height: 5),
//                         const Text(
//                           "Excellent Customer Service – We're here and happy to help!",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // ══════════════════════════════════════════════════════════
//             // 8. CONTACT US
//             // ══════════════════════════════════════════════════════════
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("CONTACT US",
//                       style: TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.phone, color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("0348 9991979 / 0334 8788950"),
//                   ]),
//                   SizedBox(height: 10),
//                   Row(children: [
//                     Icon(Icons.email, color: Color(0xffe07b39)),
//                     SizedBox(width: 10),
//                     Text("customerservice@qne.com.pk"),
//                   ]),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _whyShopTile({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 26),
//             const SizedBox(height: 6),
//             Text(label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 11,
//                     color: color,
//                     fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ══════════════════════════════════════════════════════════════════════════════
// // PROMO BANNER  — dark green card inspired by reference image 2
// // ══════════════════════════════════════════════════════════════════════════════
// class _PromoBanner extends StatelessWidget {
//   final VoidCallback onOrderTap;
//   const _PromoBanner({required this.onOrderTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       height: 120,
//       decoration: BoxDecoration(
//         color: const Color(0xff1B5E20), // deep green
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xff1B5E20).withOpacity(0.35),
//             blurRadius: 12,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Row(
//           children: [
//             // ── Text side ─────────────────────────────────────────
//             Expanded(
//               flex: 5,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Order Groceries\nfor Same Day Delivery',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: onOrderTap,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 7),
//                         decoration: BoxDecoration(
//                           color: const Color(0xff4CAF50),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text(
//                           'Order today',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Grocery image side ────────────────────────────────
//             Expanded(
//               flex: 4,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
//                   fit: BoxFit.cover,
//                   height: double.infinity,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: const Color(0xff2E7D32),
//                     child: const Icon(Icons.local_grocery_store,
//                         color: Colors.white54, size: 48),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/home/drawer_side.dart';
import 'package:grocery_app/screens/search/search.dart';
import 'package:grocery_app/screens/categories/category_products_screen.dart';
import 'package:grocery_app/widgets/category_accordion_row.dart';
import 'package:grocery_app/screens/review_cart/review_cart.dart';
import 'package:grocery_app/screens/wishlist/wishlist.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/models/product_model.dart';
import 'home_data.dart';
import 'home_widget.dart';

// ── Mid-banner images (3 banners after New Arrivals) ─────────────────────────
const List<Map<String, String>> _midBanners = [
  {
    'imageUrl':
    'https://pictures.grocerapps.com/original/grocerapp-lipton-69c609e00dd8f.jpeg',
    'label': 'Lipton',
    'tag': 'Hot Deal',
  },
  {
    'imageUrl':
    'https://pictures.grocerapps.com/original/grocerapp-qarshi-69ce3943e0cc1.png',
    'label': 'Qarshi',
    'tag': 'New',
  },
  {
    'imageUrl':
    'https://pictures.grocerapps.com/original/grocerapp-dipitt-69ce38dd91934.jpeg',
    'label': 'Dipitt',
    'tag': 'Sale',
  },
];

// ══════════════════════════════════════════════════════════════════════════════
// TRENDING PRODUCTS LIST  — live from Firestore
// ══════════════════════════════════════════════════════════════════════════════
class _TrendingProductsList extends StatefulWidget {
  const _TrendingProductsList();

  @override
  State<_TrendingProductsList> createState() => _TrendingProductsListState();
}

class _TrendingProductsListState extends State<_TrendingProductsList> {
  final FirestoreService _service = FirestoreService();
  List<ProductModel> _products = [];
  StreamSubscription<List<ProductModel>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _service.getProducts().listen((products) {
      if (mounted) setState(() => _products = products);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return const SizedBox(
        height: 248,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 14),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final p = _products[index];
          return TrendingCard(
            product: TrendingProduct(
              name: p.name,
              weight: p.weight,
              price: p.price,
              imageUrl: p.imageUrl,
              originalPrice: p.originalPrice,
              discountPercent: p.discountPercent,
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// NEW ARRIVALS LIST  — live from Firestore
// ══════════════════════════════════════════════════════════════════════════════
class _NewArrivalsList extends StatefulWidget {
  const _NewArrivalsList();

  @override
  State<_NewArrivalsList> createState() => _NewArrivalsListState();
}

class _NewArrivalsListState extends State<_NewArrivalsList> {
  final FirestoreService _service = FirestoreService();
  List<ProductModel> _products = [];
  StreamSubscription<List<ProductModel>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _service.getProducts().listen((products) {
      if (mounted) {
        setState(() {
          _products = products.reversed.take(12).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return const SizedBox(
        height: 248,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 14),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final p = _products[index];
          return NewArrivalCard(
            product: NewArrivalProduct(
              name: p.name,
              weight: p.weight,
              price: p.price,
              imageUrl: p.imageUrl,
              originalPrice: p.originalPrice,
              discountPercent: p.discountPercent,
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MID BANNER SLIDER  — peek-style like GrocerApp reference image 2
// ══════════════════════════════════════════════════════════════════════════════
class _MidBannerSlider extends StatefulWidget {
  const _MidBannerSlider();

  @override
  State<_MidBannerSlider> createState() => _MidBannerSliderState();
}

class _MidBannerSliderState extends State<_MidBannerSlider> {
  int _current = 0;
  // viewportFraction < 1 makes next card peek from the right
  final PageController _ctrl =
  PageController(viewportFraction: 0.88, initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _midBanners.length;
      _ctrl.animateToPage(next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Peek PageView ─────────────────────────────────────────────
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: _midBanners.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              final banner = _midBanners[index];
              final isActive = index == _current;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isActive ? 0 : 10, // inactive cards slightly smaller
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner image
                      Image.network(
                        banner['imageUrl']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xffe07b39).withOpacity(0.2),
                          child: const Icon(Icons.image,
                              color: Colors.grey, size: 48),
                        ),
                      ),

                      // Subtle dark gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),

                      // Tag pill (top-left)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xffe07b39),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            banner['tag']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // ── Dot indicators ────────────────────────────────────────────
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _midBanners.length,
                (i) => GestureDetector(
              onTap: () => _ctrl.animateToPage(i,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _current == i ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _current == i
                      ? const Color(0xffe07b39)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HOME SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final PageController _bannerController =
  PageController(viewportFraction: 0.88);
  Timer? _bannerTimer;

  int _expandedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    _startBannerAutoSlide();
  }

  void _startBannerAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % homeBanners.length;
      _bannerController.animateToPage(next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  Widget _sectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              'View All',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff4CAF50),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      drawer: DrawerSide(),
      appBar: AppBar(
        backgroundColor: const Color(0xffe07b39),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Search(allProducts: const [])),
          ),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.search, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text('What are you looking for?',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ),
        actions: [
          Selector<WishlistProvider, int>(
            selector: (_, w) => w.totalCount,
            builder: (context, count, _) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WishlistPage()),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Center(
                          child: Text('$count',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 9)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Selector<CartProvider, int>(
            selector: (_, cart) => cart.totalCount,
            builder: (context, count, _) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReviewCart()),
                    ),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 28),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 4,
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

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── 1. TOP BANNER SLIDER ──────────────────────────────────
            const SizedBox(height: 10),
            SizedBox(
              height: 165,
              child: PageView.builder(
                controller: _bannerController,
                itemCount: homeBanners.length,
                onPageChanged: (i) =>
                    setState(() => _currentBanner = i),
                itemBuilder: (context, index) {
                  final b = homeBanners[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(b['imageUrl']!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: const Color(0xffd6b738))),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.55),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 68,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffd1ad17),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          b['label']!,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 12),
                                      child: Text(
                                        b['discount']!,
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: Colors.green[300],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 14),
                                      child: Text(
                                        b['subtitle']!,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Banner dots
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                homeBanners.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentBanner == i ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _currentBanner == i
                        ? const Color(0xffe07b39)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── 2. TRENDING PRODUCTS ──────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    title: 'Trending Products',
                    onViewAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoryProductsScreen()),
                    ),
                  ),
                  const _TrendingProductsList(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── 3. SHOP BY CATEGORIES ─────────────────────────────────
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shop by Categories',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoryProductsScreen()),
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff4CAF50),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            ...List.generate(homeCategories.length, (index) {
              return CategoryAccordionRow(
                category: homeCategories[index],
                isExpanded: _expandedCategoryIndex == index,
                onTap: () => setState(
                      () => _expandedCategoryIndex =
                  _expandedCategoryIndex == index ? -1 : index,
                ),
              );
            }),

            const SizedBox(height: 16),

            // ── 4. PROMO BANNER ───────────────────────────────────────
            _PromoBanner(
              onOrderTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen()),
              ),
            ),

            const SizedBox(height: 16),

            // ── 5. NEW ARRIVALS ───────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    title: 'New Arrivals',
                    onViewAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoryProductsScreen()),
                    ),
                  ),
                  const _NewArrivalsList(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 6. MID BANNERS — peek-style slider (3 banners) ────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Brands',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffe07b39).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Swipe →',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xffe07b39),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // The actual peek-slider
                  const _MidBannerSlider(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 7. WHY SHOP WITH US ───────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text("Why Shop With Us?",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _whyShopTile(
                          icon: Icons.local_shipping_outlined,
                          label: 'Fast Delivery',
                          color: const Color(0xff4CAF50)),
                      const SizedBox(width: 10),
                      _whyShopTile(
                          icon: Icons.verified_outlined,
                          label: 'Quality Assured',
                          color: const Color(0xffe07b39)),
                      const SizedBox(width: 10),
                      _whyShopTile(
                          icon: Icons.currency_rupee,
                          label: 'Best Prices',
                          color: const Color(0xff2196F3)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: const BoxDecoration(
                            color: Color(0xffe07b39),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.support_agent,
                              color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 10),
                        const Text("HAVE QUESTIONS?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 5),
                        const Text(
                          "Excellent Customer Service – We're here and happy to help!",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── 8. CONTACT US ─────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CONTACT US",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.phone, color: Color(0xffe07b39)),
                    SizedBox(width: 10),
                    Text("0348 9991979 / 0334 8788950"),
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.email, color: Color(0xffe07b39)),
                    SizedBox(width: 10),
                    Text("customerservice@qne.com.pk"),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _whyShopTile({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PROMO BANNER
// ══════════════════════════════════════════════════════════════════════════════
class _PromoBanner extends StatelessWidget {
  final VoidCallback onOrderTap;
  const _PromoBanner({required this.onOrderTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xff1B5E20),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1B5E20).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Order Groceries\nfor Same Day Delivery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: onOrderTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xff4CAF50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Order today',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xff2E7D32),
                    child: const Icon(Icons.local_grocery_store,
                        color: Colors.white54, size: 48),
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