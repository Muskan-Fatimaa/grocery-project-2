// import 'package:flutter/material.dart';
// import '../screens/categories/category_products_screen.dart';
// import '../screens/home/home_data.dart';
//
// class CategoryAccordionRow extends StatelessWidget {
//   final Category category;
//   final bool isExpanded;
//   final VoidCallback onTap;
//
//   const CategoryAccordionRow({
//     super.key,
//     required this.category,
//     required this.isExpanded,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ── Header Row ────────────────────────────────────────────────────
//         InkWell(
//           onTap: () {
//             // Expand/collapse accordion AND navigate to products screen
//             onTap();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CategoryProductsScreen(
//                   filterCategory: category.name,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             color: isExpanded ? const Color(0xFFFFFDE7) : Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             child: Row(
//               children: [
//                 // Category image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     category.imageUrl,
//                     width: 64,
//                     height: 64,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 64,
//                       height: 64,
//                       color: Colors.grey[200],
//                       child: const Icon(Icons.image, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//
//                 // Title + description
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         category.name,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         category.description,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Arrow icon
//                 Icon(
//                   isExpanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: const Color(0xffe07b39),
//                   size: 22,
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // ── Subcategory Grid (expanded) ───────────────────────────────────
//         AnimatedCrossFade(
//           firstChild: const SizedBox.shrink(),
//           secondChild: _SubCategoryGrid(
//             subCategories: category.subCategories,
//             parentCategoryName: category.name,
//           ),
//           crossFadeState:
//           isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//           duration: const Duration(milliseconds: 250),
//         ),
//
//         const Divider(height: 1, thickness: 1, color: Color(0xffE0E0E0)),
//       ],
//     );
//   }
// }
//
// // ── SubCategory Grid ──────────────────────────────────────────────────────────
//
// class _SubCategoryGrid extends StatelessWidget {
//   final List<SubCategory> subCategories;
//   final String parentCategoryName;
//
//   const _SubCategoryGrid({
//     required this.subCategories,
//     required this.parentCategoryName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: subCategories.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 0.85,
//         ),
//         itemBuilder: (context, index) {
//           final sub = subCategories[index];
//           return GestureDetector(
//             onTap: () {
//               // Navigate to products filtered by parent category
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CategoryProductsScreen(
//                     filterCategory: parentCategoryName,
//                   ),
//                 ),
//               );
//             },
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       sub.imageUrl,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.image, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   sub.name,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/categories/category_products_screen.dart';
import 'package:grocery_app/screens/home/home_data.dart';

class CategoryAccordionRow extends StatelessWidget {
  final Category category;
  final bool isExpanded;
  final VoidCallback onTap;

  const CategoryAccordionRow({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header Row — only expands/collapses, does NOT navigate ────────
        InkWell(
          onTap: onTap, // just toggles accordion
          child: Container(
            color: isExpanded ? const Color(0xFFFFFDE7) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    category.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xffe07b39),
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // ── Subcategory Grid (expanded) ───────────────────────────────────
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _SubCategoryGrid(
            subCategories: category.subCategories,
            parentCategoryName: category.name,
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xffE0E0E0)),
      ],
    );
  }
}

// ── SubCategory Grid ──────────────────────────────────────────────────────────

class _SubCategoryGrid extends StatelessWidget {
  final List<SubCategory> subCategories;
  final String parentCategoryName;

  const _SubCategoryGrid({
    required this.subCategories,
    required this.parentCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final sub = subCategories[index];
          return GestureDetector(
            // tapping subcategory item navigates to products
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryProductsScreen(
                  filterCategory: parentCategoryName,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      sub.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  sub.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}