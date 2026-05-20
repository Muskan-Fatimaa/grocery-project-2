// import 'package:flutter/material.dart';
// import 'package:grocery_app/screens/product_overview/product_overview.dart';
//
// // ── Popular / recent search suggestions ──────────────────────────────────────
// const List<String> _popularSearches = [
//   'Milk', 'Tomato', 'Bread', 'Rice', 'Chicken',
//   'Eggs', 'Ghee', 'Sugar', 'Atta', 'Green Tea',
// ];
//
// class Search extends StatefulWidget {
//   final List<ProductModel> allProducts;
//   const Search({super.key, required this.allProducts});
//
//   @override
//   State<Search> createState() => _SearchState();
// }
//
// class _SearchState extends State<Search> {
//   String query = '';
//   final TextEditingController _controller = TextEditingController();
//
//   List<ProductModel> get filteredProducts {
//     if (query.isEmpty) return [];
//     return widget.allProducts
//         .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool hasQuery = query.isNotEmpty;
//     final results = filteredProducts;
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.black),
//         titleSpacing: 0,
//         title: Container(
//           height: 42,
//           margin: const EdgeInsets.only(left: 4, right: 12),
//           decoration: BoxDecoration(
//             color: const Color(0xffF5F5F5),
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: TextField(
//             controller: _controller,
//             autofocus: true,
//             onChanged: (v) => setState(() => query = v),
//             style: const TextStyle(fontSize: 14, color: Colors.black87),
//             decoration: InputDecoration(
//               hintText: 'Search for items in the store...',
//               hintStyle:
//               const TextStyle(fontSize: 13, color: Colors.grey),
//               prefixIcon:
//               const Icon(Icons.search, color: Colors.grey, size: 20),
//               suffixIcon: hasQuery
//                   ? GestureDetector(
//                 onTap: () {
//                   _controller.clear();
//                   setState(() => query = '');
//                 },
//                 child: const Icon(Icons.close,
//                     color: Colors.grey, size: 18),
//               )
//                   : null,
//               border: InputBorder.none,
//               contentPadding:
//               const EdgeInsets.symmetric(vertical: 11),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel',
//                 style: TextStyle(
//                     color: Color(0xffe07b39),
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14)),
//           ),
//         ],
//       ),
//
//       body: hasQuery
//       // ── SEARCH RESULTS ────────────────────────────────────────────
//           ? results.isEmpty
//           ? _EmptyState(query: query)
//           : Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Result count bar
//           Container(
//             color: Colors.white,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 10),
//             child: Text(
//               '${results.length} result${results.length == 1 ? '' : 's'} for "$query"',
//               style: const TextStyle(
//                   fontSize: 13, color: Colors.grey),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.separated(
//               padding: EdgeInsets.zero,
//               itemCount: results.length,
//               separatorBuilder: (_, __) =>
//               const SizedBox(height: 1),
//               itemBuilder: (context, index) =>
//                   _SearchResultTile(
//                     product: results[index],
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ProductOverview(
//                             product: results[index]),
//                       ),
//                     ),
//                   ),
//             ),
//           ),
//         ],
//       )
//
//       // ── EMPTY STATE — show popular searches ───────────────────────
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Popular searches
//             const Text(
//               'Popular Searches',
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87),
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: _popularSearches.map((term) {
//                 return GestureDetector(
//                   onTap: () {
//                     _controller.text = term;
//                     setState(() => query = term);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: Colors.grey.shade300),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.trending_up,
//                             size: 14,
//                             color: Color(0xffe07b39)),
//                         const SizedBox(width: 5),
//                         Text(term,
//                             style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.black87)),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//
//             const SizedBox(height: 28),
//
//             // Categories quick links
//             const Text(
//               'Browse Categories',
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87),
//             ),
//             const SizedBox(height: 12),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 3,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               childAspectRatio: 1.1,
//               children: _quickCategories.map((cat) {
//                 return GestureDetector(
//                   onTap: () {
//                     _controller.text = cat['label']!;
//                     setState(() => query = cat['label']!);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                           color: Colors.grey.shade200),
//                     ),
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.center,
//                       children: [
//                         Text(cat['emoji']!,
//                             style:
//                             const TextStyle(fontSize: 26)),
//                         const SizedBox(height: 6),
//                         Text(
//                           cat['label']!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Quick category tiles for empty state ─────────────────────────────────────
// const List<Map<String, String>> _quickCategories = [
//   {'emoji': '🥛', 'label': 'Dairy'},
//   {'emoji': '🍎', 'label': 'Fruits'},
//   {'emoji': '🥦', 'label': 'Vegetables'},
//   {'emoji': '🍗', 'label': 'Meat'},
//   {'emoji': '🫙', 'label': 'Spices'},
//   {'emoji': '🧃', 'label': 'Beverages'},
//   {'emoji': '🍞', 'label': 'Bakery'},
//   {'emoji': '🛢️', 'label': 'Oils & Ghee'},
//   {'emoji': '🧴', 'label': 'Cleaning'},
// ];
//
// // ── Empty search result state ─────────────────────────────────────────────────
// class _EmptyState extends StatelessWidget {
//   final String query;
//   const _EmptyState({required this.query});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 90,
//             height: 90,
//             decoration: BoxDecoration(
//               color: const Color(0xffe07b39).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.search_off,
//                 size: 44, color: Color(0xffe07b39)),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No results for "$query"',
//             style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Try a different keyword or\nbrowse our categories',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 13, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Single search result tile ─────────────────────────────────────────────────
// class _SearchResultTile extends StatefulWidget {
//   final ProductModel product;
//   final VoidCallback onTap;
//   const _SearchResultTile({required this.product, required this.onTap});
//
//   @override
//   State<_SearchResultTile> createState() => _SearchResultTileState();
// }
//
// class _SearchResultTileState extends State<_SearchResultTile> {
//   int _qty = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         color: Colors.white,
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             // Product image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(
//                 widget.product.imageUrl,
//                 width: 70,
//                 height: 70,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   width: 70,
//                   height: 70,
//                   color: Colors.grey[100],
//                   child: const Icon(Icons.image,
//                       color: Colors.grey, size: 28),
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 14),
//
//             // Name, category, price
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category tag
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 7, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffe07b39).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       widget.product.category,
//                       style: const TextStyle(
//                           fontSize: 10,
//                           color: Color(0xffe07b39),
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     widget.product.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         color: Colors.black87),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Text(
//                         widget.product.price,
//                         style: const TextStyle(
//                             color: Color(0xff4CAF50),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13),
//                       ),
//                       const SizedBox(width: 8),
//                       // Unit pill
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 7, vertical: 2),
//                         decoration: BoxDecoration(
//                           border:
//                           Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(widget.product.unit,
//                                 style: const TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.black54)),
//                             const Icon(Icons.arrow_drop_down,
//                                 size: 14,
//                                 color: Color(0xffe07b39)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(width: 8),
//
//             // ADD / counter
//             _qty == 0
//                 ? GestureDetector(
//               onTap: () => setState(() => _qty = 1),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: const Color(0xffd6b738),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   '+ ADD',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12),
//                 ),
//               ),
//             )
//                 : Column(
//               children: [
//                 _CounterBtn(
//                     icon: Icons.add,
//                     onTap: () => setState(() => _qty++)),
//                 Padding(
//                   padding:
//                   const EdgeInsets.symmetric(vertical: 4),
//                   child: Text('$_qty',
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13)),
//                 ),
//                 _CounterBtn(
//                     icon: Icons.remove,
//                     onTap: () => setState(
//                             () => _qty = (_qty - 1).clamp(0, 99))),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Counter button ────────────────────────────────────────────────────────────
// class _CounterBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _CounterBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: const Color(0xffd6b738),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Icon(icon, size: 14, color: Colors.white),
//       ),
//     );
//   }
// }
//
//


import 'package:flutter/material.dart';

// ── Static product data for testing (simple map structure) ──────────────────
List<Map<String, dynamic>> getStaticProducts() {
  return [
    {
      'id': '1',
      'name': 'Fresh Milk',
      'weight': '1 Litre',
      'price': 60,
      'category': 'Dairy',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '2',
      'name': 'Tomato',
      'weight': '1 Kg',
      'price': 40,
      'category': 'Vegetables',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '3',
      'name': 'Bread',
      'weight': '400g',
      'price': 35,
      'category': 'Bakery',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '4',
      'name': 'Basmati Rice',
      'weight': '5 Kg',
      'price': 450,
      'category': 'Grains',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '5',
      'name': 'Chicken Breast',
      'weight': '500g',
      'price': 180,
      'category': 'Meat',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '6',
      'name': 'Eggs',
      'weight': '6 Pieces',
      'price': 48,
      'category': 'Dairy',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '7',
      'name': 'Ghee',
      'weight': '1 Litre',
      'price': 400,
      'category': 'Oils',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '8',
      'name': 'Sugar',
      'weight': '1 Kg',
      'price': 45,
      'category': 'Groceries',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '9',
      'name': 'Green Tea',
      'weight': '100g',
      'price': 150,
      'category': 'Beverages',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '10',
      'name': 'Apple',
      'weight': '1 Kg',
      'price': 120,
      'category': 'Fruits',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];
}

// ── Popular search suggestions ──────────────────────────────────────────────
const List<String> _popularSearches = [
  'Milk', 'Tomato', 'Bread', 'Rice', 'Chicken',
  'Eggs', 'Ghee', 'Sugar', 'Apple', 'Tea',
];

class Search extends StatefulWidget {
  final List<Map<String, dynamic>>? allProducts;
  const Search({super.key, this.allProducts});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Get products (either from passed list or static data)
  List<Map<String, dynamic>> get _products {
    if (widget.allProducts != null && widget.allProducts!.isNotEmpty) {
      return widget.allProducts!;
    }
    return getStaticProducts();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (query.isEmpty) return [];
    return _products
        .where((product) =>
        product['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Auto-focus after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasQuery = query.isNotEmpty;
    final List<Map<String, dynamic>> results = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 42,
          margin: const EdgeInsets.only(left: 4, right: 12),
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onChanged: (value) => setState(() => query = value),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Search for items...',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              suffixIcon: hasQuery
                  ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  setState(() => query = '');
                },
                child: const Icon(Icons.close, color: Colors.grey, size: 18),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xffe07b39),
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),
      body: hasQuery
      // ── SEARCH RESULTS ────────────────────────────────────────────
          ? results.isEmpty
          ? _EmptyState(query: query)
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result count bar
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Text(
              '${results.length} result${results.length == 1 ? '' : 's'} for "$query"',
              style: const TextStyle(
                  fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) => SearchResultTile(
                product: results[index],
                onTap: () {
                  // Navigate to product detail
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Viewing ${results[index]['name']}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )
      // ── EMPTY STATE — show popular searches ───────────────────────
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Popular Searches',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popularSearches.map((term) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = term;
                    setState(() => query = term);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up,
                            size: 14, color: Color(0xffe07b39)),
                        const SizedBox(width: 5),
                        Text(term,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            const Text(
              'Browse Categories',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
              children: _quickCategories.map((cat) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = cat['label']!;
                    setState(() => query = cat['label']!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['emoji']!,
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(
                          cat['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick category tiles ─────────────────────────────────────────────────────
const List<Map<String, String>> _quickCategories = [
  {'emoji': '🥛', 'label': 'Dairy'},
  {'emoji': '🍎', 'label': 'Fruits'},
  {'emoji': '🥦', 'label': 'Vegetables'},
  {'emoji': '🍗', 'label': 'Meat'},
  {'emoji': '🫙', 'label': 'Spices'},
  {'emoji': '🧃', 'label': 'Beverages'},
  {'emoji': '🍞', 'label': 'Bakery'},
  {'emoji': '🛢️', 'label': 'Oils'},
  {'emoji': '🧴', 'label': 'Cleaning'},
];

// ── Empty search result state ─────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xffe07b39).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off,
                size: 44, color: Color(0xffe07b39)),
          ),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different keyword',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Single search result tile ─────────────────────────────────────────────────
class SearchResultTile extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  const SearchResultTile({required this.product, required this.onTap});

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Product image placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xffe07b39).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_bag,
                  color: Color(0xffe07b39), size: 30),
            ),
            const SizedBox(width: 14),
            // Name, category, price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xffe07b39).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.product['category'].toString(),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xffe07b39),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product['name'].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${widget.product['price'].toString()}',
                        style: const TextStyle(
                            color: Color(0xff4CAF50),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(widget.product['weight'].toString(),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // ADD button
            GestureDetector(
              onTap: () => setState(() => _qty = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xffe07b39),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+ ADD',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}