
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/avatar_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/my_profile/my_profile.dart';
import 'package:grocery_app/screens/about_us/about_us.dart';
import 'package:grocery_app/screens/wishlist/wishlist.dart';
import 'package:grocery_app/screens/complaint/complain_page.dart';
import 'package:grocery_app/screens/review_cart/review_cart.dart';
import 'package:grocery_app/screens/faq/faq.dart';
import 'package:grocery_app/screens/rating/rating.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({super.key});

  Widget _listTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? color,
  }) {
    final itemColor = color ?? Colors.black87;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 26, color: itemColor),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    Navigator.of(context).pop();
    context.read<CartProvider>().reset();
    context.read<WishlistProvider>().reset();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // ✅ Watch AvatarProvider — auto-rebuilds when profile photo changes
    final avatarBase64 = context.watch<AvatarProvider>().avatarBase64;

    final String displayName =
    (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : (user?.email ?? 'Guest');

    final String email = user?.email ?? '';
    final String? photoUrl = user?.photoURL;
    final String avatarLetter =
    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    // Local base64 takes priority over Firebase photoURL
    ImageProvider? avatarImage;
    if (avatarBase64 != null) {
      try {
        avatarImage = MemoryImage(base64Decode(avatarBase64));
      } catch (_) {}
    } else if (photoUrl != null && photoUrl.isNotEmpty) {
      avatarImage = NetworkImage(photoUrl);
    }

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Header ────────────────────────────────────────────────
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffe07b39), Color(0xffC4601F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 43,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? Text(
                        avatarLetter,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffe07b39),
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null ? 'Welcome back!' : 'Welcome Guest',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu Items ────────────────────────────────────────────
            _listTile(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _listTile(
              icon: Icons.shop_outlined,
              title: 'Review Cart',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReviewCart()));
              },
            ),
            _listTile(
              icon: Icons.person_outline,
              title: 'My Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyProfileScreen()),
                );
              },
            ),
            _listTile(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                );
              },
            ),
            _listTile(
              icon: Icons.favorite_outline,
              title: 'Wishlist',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistPage()),
                );
              },
            ),
            _listTile(
              icon: Icons.copy_outlined,
              title: 'Raise a Complaint',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RaiseComplaintPage()),
                );
              },
            ),
            _listTile(
              icon: Icons.star_outline,
              title: 'Rating & Review',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RatingReviewScreen()),
                );
              },
            ),
            _listTile(
              icon: Icons.format_quote_outlined,
              title: 'FAQs',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaqScreen()),
                );
              },
            ),

            const Divider(thickness: 1, color: Color(0xffEEEEEE)),

            _listTile(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red.shade600,
              onTap: () => _signOut(context),
            ),

            // ── Contact Support ───────────────────────────────────────
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Contact Support',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Divider(color: Colors.black26, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        'Call us:  +923352580383',
                        style:
                        TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 16, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        'Mail us: support@freshbasket.com',
                        style:
                        TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}