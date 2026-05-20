
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:grocery_app/providers/cart_provider.dart';
// import 'package:grocery_app/providers/wishlist_provider.dart';
// import 'package:grocery_app/screens/my_orders/my_orders_screen.dart';
// import 'package:grocery_app/screens/delivery_address/my_saved_addresses_screen.dart';
// import 'package:grocery_app/screens/static/terms_screen.dart';
// import 'package:grocery_app/screens/static/privacy_screen.dart';
// import 'package:grocery_app/screens/static/contact_us_screen.dart';
// import 'package:grocery_app/screens/static/refund_policy_screen.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // MyProfileScreen
// // ─────────────────────────────────────────────────────────────────────────────
// class MyProfileScreen extends StatefulWidget {
//   const MyProfileScreen({super.key});
//
//   @override
//   State<MyProfileScreen> createState() => _MyProfileScreenState();
// }
//
// class _MyProfileScreenState extends State<MyProfileScreen> {
//   final _auth      = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//
//   String? _avatarBase64;
//   String  _phone = '';
//
//   static const _avatarKey = 'profile_avatar_b64';
//   static const _phoneKey  = 'profile_phone';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final uid   = _auth.currentUser?.uid;
//     setState(() => _avatarBase64 = prefs.getString(_avatarKey));
//     if (uid != null) {
//       try {
//         final doc = await _firestore.collection('users').doc(uid).get();
//         if (doc.exists) {
//           final phone = (doc.data()?['phone'] as String?) ?? '';
//           await prefs.setString(_phoneKey, phone);
//           if (mounted) setState(() => _phone = phone);
//         }
//       } catch (_) {
//         if (mounted) {
//           setState(() => _phone = prefs.getString(_phoneKey) ?? '');
//         }
//       }
//     }
//   }
//
//   User?  get _user        => _auth.currentUser;
//   String get _displayName => _user?.displayName ?? 'User';
//   String get _email       => _user?.email ?? '';
//
//   String get _initials {
//     final parts = _displayName.trim().split(' ');
//     if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
//     return _displayName.isNotEmpty ? _displayName[0].toUpperCase() : '?';
//   }
//
//   Future<void> _onProfileSaved(String name, String phone, String? avatarB64) async {
//     final uid = _user?.uid;
//     if (uid == null) return;
//     await _user?.updateDisplayName(name);
//     await _user?.reload();
//     await _firestore.collection('users').doc(uid).set(
//       {'name': name, 'phone': phone, 'lastLoginAt': FieldValue.serverTimestamp()},
//       SetOptions(merge: true),
//     );
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_phoneKey, phone);
//     if (avatarB64 != null) {
//       await prefs.setString(_avatarKey, avatarB64);
//     } else {
//       await prefs.remove(_avatarKey);
//     }
//     if (!mounted) return;
//     setState(() { _phone = phone; _avatarBase64 = avatarB64; });
//   }
//
//   Future<void> _logout() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
//         content: const Text('Are you sure you want to log out?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text('Log out', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//     if (confirmed == true && mounted) {
//       context.read<CartProvider>().reset();
//       context.read<WishlistProvider>().reset();
//       await _auth.signOut();
//     }
//   }
//
//   void _openEditSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _EditProfileSheet(
//         currentName:  _displayName,
//         currentPhone: _phone,
//         currentEmail: _email,
//         avatarBase64: _avatarBase64,
//         onSaved:      _onProfileSaved,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F4F4),
//       body: Column(
//         children: [
//           _ProfileHeader(
//             displayName: _displayName,
//             email: _email,
//             phone: _phone,
//             initials: _initials,
//             avatarBase64: _avatarBase64,
//             onBack: () => Navigator.pop(context),
//             onEdit: _openEditSheet,
//           ),
//
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
//               child: Column(
//                 children: [
//                   _SectionLabel(label: 'Account'),
//                   const SizedBox(height: 8),
//                   _MenuCard(
//                     tiles: [
//                       _MenuTileData(
//                         icon: Icons.shopping_bag_rounded,
//                         iconBg: const Color(0xFFE07B39),
//                         label: 'My Orders',
//                         subtitle: 'Track & view past orders',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const MyOrdersScreen())),
//                       ),
//                       _MenuTileData(
//                         icon: Icons.location_on_rounded,
//                         iconBg: const Color(0xFF4CAF50),
//                         label: 'My Delivery Address',
//                         subtitle: 'Manage saved addresses',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const MySavedAddressesScreen())),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   _SectionLabel(label: 'Support'),
//                   const SizedBox(height: 8),
//                   _MenuCard(
//                     tiles: [
//                       _MenuTileData(
//                         icon: Icons.headset_mic_rounded,
//                         iconBg: const Color(0xFFE07B39),
//                         label: 'Contact Us',
//                         subtitle: 'Reach out, we\'re here to help',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const ContactUsScreen())),
//                       ),
//                       _MenuTileData(
//                         icon: Icons.assignment_return_rounded,
//                         iconBg: const Color(0xFF26A69A),
//                         label: 'Refund & Return Policy',
//                         subtitle: 'Learn about our return process',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const RefundPolicyScreen())),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   _SectionLabel(label: 'Legal'),
//                   const SizedBox(height: 8),
//                   _MenuCard(
//                     tiles: [
//                       _MenuTileData(
//                         icon: Icons.description_rounded,
//                         iconBg: const Color(0xFF5C6BC0),
//                         label: 'Terms & Conditions',
//                         subtitle: 'Our terms of service',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const TermsScreen())),
//                       ),
//                       _MenuTileData(
//                         icon: Icons.privacy_tip_rounded,
//                         iconBg: const Color(0xFF42A5F5),
//                         label: 'Privacy Policy',
//                         subtitle: 'How we handle your data',
//                         onTap: () => Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => const PrivacyScreen())),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Logout button
//                   GestureDetector(
//                     onTap: _logout,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: Colors.red.shade100),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.red.withOpacity(0.06),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 20),
//                           const SizedBox(width: 10),
//                           Text(
//                             'Log Out',
//                             style: TextStyle(
//                               color: Colors.red.shade400,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Profile Header
// // ─────────────────────────────────────────────────────────────────────────────
// class _ProfileHeader extends StatelessWidget {
//   final String  displayName, email, phone, initials;
//   final String? avatarBase64;
//   final VoidCallback onBack, onEdit;
//
//   const _ProfileHeader({
//     required this.displayName,
//     required this.email,
//     required this.phone,
//     required this.initials,
//     required this.avatarBase64,
//     required this.onBack,
//     required this.onEdit,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFF4F4F4),
//       child: Stack(
//         children: [
//           ClipPath(
//             clipper: _WaveClipper(),
//             child: Container(
//               height: 220,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             bottom: false,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: onBack,
//                         icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       ),
//                       const Text(
//                         'My Profile',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.10),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: const Color(0xFFE07B39),
//                               width: 2.5,
//                             ),
//                           ),
//                           child: _AvatarWidget(
//                             avatarBase64: avatarBase64,
//                             initials: initials,
//                             radius: 34,
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 displayName,
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1A1A1A),
//                                 ),
//                               ),
//                               const SizedBox(height: 3),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.email_outlined,
//                                       size: 13, color: Color(0xFFE07B39)),
//                                   const SizedBox(width: 4),
//                                   Flexible(
//                                     child: Text(
//                                       email,
//                                       style: const TextStyle(
//                                         fontSize: 12.5,
//                                         color: Color(0xFF888888),
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (phone.isNotEmpty) ...[
//                                 const SizedBox(height: 2),
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.phone_outlined,
//                                         size: 13, color: Color(0xFFE07B39)),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       phone,
//                                       style: const TextStyle(
//                                         fontSize: 12.5,
//                                         color: Color(0xFF888888),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//
//                         GestureDetector(
//                           onTap: onEdit,
//                           child: Container(
//                             padding: const EdgeInsets.all(9),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFFF3ED),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Icon(
//                               Icons.edit_rounded,
//                               size: 18,
//                               color: Color(0xFFE07B39),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 30);
//     path.quadraticBezierTo(
//       size.width / 2, size.height + 20,
//       size.width, size.height - 30,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(_) => false;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Section label
// // ─────────────────────────────────────────────────────────────────────────────
// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         label.toUpperCase(),
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: Color(0xFFAAAAAA),
//           letterSpacing: 1.2,
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Menu card
// // ─────────────────────────────────────────────────────────────────────────────
// class _MenuTileData {
//   final IconData icon;
//   final Color iconBg;
//   final String label;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   const _MenuTileData({
//     required this.icon,
//     required this.iconBg,
//     required this.label,
//     required this.subtitle,
//     required this.onTap,
//   });
// }
//
// class _MenuCard extends StatelessWidget {
//   final List<_MenuTileData> tiles;
//   const _MenuCard({required this.tiles});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: tiles.asMap().entries.map((e) {
//           final index = e.key;
//           final tile = e.value;
//           return Column(
//             children: [
//               InkWell(
//                 onTap: tile.onTap,
//                 borderRadius: BorderRadius.circular(16),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: tile.iconBg.withOpacity(0.12),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(tile.icon, color: tile.iconBg, size: 20),
//                       ),
//                       const SizedBox(width: 13),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               tile.label,
//                               style: const TextStyle(
//                                 fontSize: 14.5,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF222222),
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               tile.subtitle,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFFAAAAAA),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: 28,
//                         height: 28,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F5F5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(Icons.chevron_right_rounded,
//                             color: Color(0xFFCCCCCC), size: 18),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (index < tiles.length - 1)
//                 const Divider(
//                   height: 1, indent: 70, endIndent: 16,
//                   color: Color(0xFFF0F0F0),
//                 ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Avatar
// // ─────────────────────────────────────────────────────────────────────────────
// class _AvatarWidget extends StatelessWidget {
//   final String?  avatarBase64;
//   final File?    file;
//   final String   initials;
//   final double   radius;
//
//   const _AvatarWidget({
//     required this.initials,
//     required this.radius,
//     this.avatarBase64,
//     this.file,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     ImageProvider? provider;
//     if (file != null) {
//       provider = FileImage(file!);
//     } else if (avatarBase64 != null) {
//       try { provider = MemoryImage(base64Decode(avatarBase64!)); } catch (_) {}
//     }
//
//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: const Color(0xFFE07B39),
//       backgroundImage: provider,
//       child: provider == null
//           ? Text(initials,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: radius * 0.52,
//             fontWeight: FontWeight.bold,
//           ))
//           : null,
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Edit Profile Bottom Sheet
// // ─────────────────────────────────────────────────────────────────────────────
// class _EditProfileSheet extends StatefulWidget {
//   final String   currentName;
//   final String   currentPhone;
//   final String   currentEmail;
//   final String?  avatarBase64;
//   final Future<void> Function(String name, String phone, String? avatarB64) onSaved;
//
//   const _EditProfileSheet({
//     required this.currentName,
//     required this.currentPhone,
//     required this.currentEmail,
//     required this.avatarBase64,
//     required this.onSaved,
//   });
//
//   @override
//   State<_EditProfileSheet> createState() => _EditProfileSheetState();
// }
//
// class _EditProfileSheetState extends State<_EditProfileSheet> {
//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _phoneCtrl;
//   String? _avatarB64;
//   File?   _pickedFile;
//   bool    _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameCtrl  = TextEditingController(text: widget.currentName);
//     _phoneCtrl = TextEditingController(text: widget.currentPhone);
//     _avatarB64 = widget.avatarBase64;
//   }
//
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickPhoto(ImageSource source) async {
//     Navigator.pop(context);
//     final XFile? file = await ImagePicker().pickImage(
//         source: source, maxWidth: 512, maxHeight: 512, imageQuality: 80);
//     if (file == null) return;
//     final bytes = await file.readAsBytes();
//     setState(() { _pickedFile = File(file.path); _avatarB64 = base64Encode(bytes); });
//   }
//
//   void _showPhotoOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (_) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library_outlined),
//               title: const Text('Choose from gallery'),
//               onTap: () => _pickPhoto(ImageSource.gallery),
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt_outlined),
//               title: const Text('Take a photo'),
//               onTap: () => _pickPhoto(ImageSource.camera),
//             ),
//             if (_avatarB64 != null)
//               ListTile(
//                 leading: const Icon(Icons.delete_outline, color: Colors.red),
//                 title: const Text('Remove photo', style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   setState(() { _avatarB64 = null; _pickedFile = null; });
//                 },
//               ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _save() async {
//     final name  = _nameCtrl.text.trim();
//     final phone = _phoneCtrl.text.trim();
//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
//       return;
//     }
//     setState(() => _isSaving = true);
//     try {
//       await widget.onSaved(name, phone, _avatarB64);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }
//
//   String get _previewInitials {
//     final n = _nameCtrl.text.trim();
//     final parts = n.split(' ');
//     if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
//     return n.isNotEmpty ? n[0].toUpperCase() : '?';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.78,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (ctx, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 width: 40, height: 4,
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2)),
//               ),
//               const SizedBox(height: 16),
//               const Text('Edit Profile',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Stack(
//                           children: [
//                             _AvatarWidget(
//                                 avatarBase64: _avatarB64,
//                                 file: _pickedFile,
//                                 initials: _previewInitials,
//                                 radius: 50),
//                             Positioned(
//                               bottom: 0, right: 0,
//                               child: GestureDetector(
//                                 onTap: _showPhotoOptions,
//                                 child: Container(
//                                   width: 34, height: 34,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFE07B39),
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.white, width: 2),
//                                   ),
//                                   child: const Icon(Icons.camera_alt, size: 17, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       _buildField(controller: _nameCtrl, icon: Icons.person_outline,
//                           hint: 'Full name', textCapitalization: TextCapitalization.words),
//                       const SizedBox(height: 12),
//                       _buildField(controller: _phoneCtrl, icon: Icons.phone_outlined,
//                           hint: 'Phone number (optional)',
//                           keyboardType: TextInputType.phone),
//                       const SizedBox(height: 12),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF0F0F0),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: const Color(0xFFDDDDDD)),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.email_outlined, color: Color(0xFFAAAAAA)),
//                             const SizedBox(width: 10),
//                             Expanded(child: Text(widget.currentEmail,
//                                 style: const TextStyle(fontSize: 15, color: Color(0xFF888888)))),
//                             const Text('cannot edit',
//                                 style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 8, 20,
//                     MediaQuery.of(context).padding.bottom + 16),
//                 child: SizedBox(
//                   width: double.infinity, height: 52,
//                   child: ElevatedButton(
//                     onPressed: _isSaving ? null : _save,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFE07B39),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(width: 22, height: 22,
//                         child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                         : const Text('Save Changes',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     TextCapitalization textCapitalization = TextCapitalization.none,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       style: const TextStyle(fontSize: 15),
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: const Color(0xFF888888)),
//         filled: true,
//         fillColor: const Color(0xFFF7F7F7),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE07B39), width: 1.5),
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocery_app/providers/avatar_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/my_orders/my_orders_screen.dart';
import 'package:grocery_app/screens/delivery_address/my_saved_addresses_screen.dart';
import 'package:grocery_app/screens/static/terms_screen.dart';
import 'package:grocery_app/screens/static/privacy_screen.dart';
import 'package:grocery_app/screens/static/contact_us_screen.dart';
import 'package:grocery_app/screens/static/refund_policy_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MyProfileScreen
// ─────────────────────────────────────────────────────────────────────────────
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _auth      = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _avatarBase64;
  String  _phone = '';

  static const _phoneKey = 'profile_phone';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid   = _auth.currentUser?.uid;

    // ✅ Read avatar from AvatarProvider (single source of truth)
    if (mounted) {
      setState(() {
        _avatarBase64 = context.read<AvatarProvider>().avatarBase64;
      });
    }

    if (uid != null) {
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          final phone = (doc.data()?['phone'] as String?) ?? '';
          await prefs.setString(_phoneKey, phone);
          if (mounted) setState(() => _phone = phone);
        }
      } catch (_) {
        if (mounted) {
          setState(() => _phone = prefs.getString(_phoneKey) ?? '');
        }
      }
    }
  }

  User?  get _user        => _auth.currentUser;
  String get _displayName => _user?.displayName ?? 'User';
  String get _email       => _user?.email ?? '';

  String get _initials {
    final parts = _displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return _displayName.isNotEmpty ? _displayName[0].toUpperCase() : '?';
  }

  Future<void> _onProfileSaved(
      String name, String phone, String? avatarB64) async {
    final uid = _user?.uid;
    if (uid == null) return;

    await _user?.updateDisplayName(name);
    await _user?.reload();
    await _firestore.collection('users').doc(uid).set(
      {
        'name': name,
        'phone': phone,
        'lastLoginAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);

    // ✅ Update AvatarProvider — DrawerSide auto-rebuilds via context.watch
    if (mounted) {
      await context.read<AvatarProvider>().update(avatarB64);
      setState(() {
        _phone        = phone;
        _avatarBase64 = avatarB64;
      });
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<CartProvider>().reset();
      context.read<WishlistProvider>().reset();
      await _auth.signOut();
    }
  }

  void _openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        currentName:  _displayName,
        currentPhone: _phone,
        currentEmail: _email,
        avatarBase64: _avatarBase64,
        onSaved:      _onProfileSaved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          _ProfileHeader(
            displayName:  _displayName,
            email:        _email,
            phone:        _phone,
            initials:     _initials,
            avatarBase64: _avatarBase64,
            onBack:       () => Navigator.pop(context),
            onEdit:       _openEditSheet,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                children: [
                  _SectionLabel(label: 'Account'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    tiles: [
                      _MenuTileData(
                        icon:     Icons.shopping_bag_rounded,
                        iconBg:   const Color(0xFFE07B39),
                        label:    'My Orders',
                        subtitle: 'Track & view past orders',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyOrdersScreen()),
                        ),
                      ),
                      _MenuTileData(
                        icon:     Icons.location_on_rounded,
                        iconBg:   const Color(0xFF4CAF50),
                        label:    'My Delivery Address',
                        subtitle: 'Manage saved addresses',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const MySavedAddressesScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SectionLabel(label: 'Support'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    tiles: [
                      _MenuTileData(
                        icon:     Icons.headset_mic_rounded,
                        iconBg:   const Color(0xFFE07B39),
                        label:    'Contact Us',
                        subtitle: 'Reach out, we\'re here to help',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ContactUsScreen()),
                        ),
                      ),
                      _MenuTileData(
                        icon:     Icons.assignment_return_rounded,
                        iconBg:   const Color(0xFF26A69A),
                        label:    'Refund & Return Policy',
                        subtitle: 'Learn about our return process',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RefundPolicyScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SectionLabel(label: 'Legal'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    tiles: [
                      _MenuTileData(
                        icon:     Icons.description_rounded,
                        iconBg:   const Color(0xFF5C6BC0),
                        label:    'Terms & Conditions',
                        subtitle: 'Our terms of service',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TermsScreen()),
                        ),
                      ),
                      _MenuTileData(
                        icon:     Icons.privacy_tip_rounded,
                        iconBg:   const Color(0xFF42A5F5),
                        label:    'Privacy Policy',
                        subtitle: 'How we handle your data',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PrivacyScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Logout button
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: Colors.red.shade400, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Header
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final String  displayName, email, phone, initials;
  final String? avatarBase64;
  final VoidCallback onBack, onEdit;

  const _ProfileHeader({
    required this.displayName,
    required this.email,
    required this.phone,
    required this.initials,
    required this.avatarBase64,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F4F4),
      child: Stack(
        children: [
          ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                      ),
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE07B39),
                              width: 2.5,
                            ),
                          ),
                          child: _AvatarWidget(
                            avatarBase64: avatarBase64,
                            initials:     initials,
                            radius:       34,
                          ),
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined,
                                      size: 13,
                                      color: Color(0xFFE07B39)),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF888888),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (phone.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.phone_outlined,
                                        size: 13,
                                        color: Color(0xFFE07B39)),
                                    const SizedBox(width: 4),
                                    Text(
                                      phone,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3ED),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: Color(0xFFE07B39),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2, size.height + 20,
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFFAAAAAA),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu card
// ─────────────────────────────────────────────────────────────────────────────
class _MenuTileData {
  final IconData     icon;
  final Color        iconBg;
  final String       label;
  final String       subtitle;
  final VoidCallback onTap;

  const _MenuTileData({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
}

class _MenuCard extends StatelessWidget {
  final List<_MenuTileData> tiles;
  const _MenuCard({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: tiles.asMap().entries.map((e) {
          final index = e.key;
          final tile  = e.value;
          return Column(
            children: [
              InkWell(
                onTap: tile.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: tile.iconBg.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(tile.icon,
                            color: tile.iconBg, size: 20),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tile.label,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tile.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.chevron_right_rounded,
                            color: Color(0xFFCCCCCC), size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < tiles.length - 1)
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 16,
                  color: Color(0xFFF0F0F0),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar widget
// ─────────────────────────────────────────────────────────────────────────────
class _AvatarWidget extends StatelessWidget {
  final String?  avatarBase64;
  final File?    file;
  final String   initials;
  final double   radius;

  const _AvatarWidget({
    required this.initials,
    required this.radius,
    this.avatarBase64,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (file != null) {
      provider = FileImage(file!);
    } else if (avatarBase64 != null) {
      try {
        provider = MemoryImage(base64Decode(avatarBase64!));
      } catch (_) {}
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE07B39),
      backgroundImage: provider,
      child: provider == null
          ? Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.52,
          fontWeight: FontWeight.bold,
        ),
      )
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Edit Profile Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final String   currentName;
  final String   currentPhone;
  final String   currentEmail;
  final String?  avatarBase64;
  final Future<void> Function(String name, String phone, String? avatarB64)
  onSaved;

  const _EditProfileSheet({
    required this.currentName,
    required this.currentPhone,
    required this.currentEmail,
    required this.avatarBase64,
    required this.onSaved,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  String? _avatarB64;
  File?   _pickedFile;
  bool    _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.currentName);
    _phoneCtrl = TextEditingController(text: widget.currentPhone);
    _avatarB64 = widget.avatarBase64;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.pop(context);
    final XFile? file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _pickedFile = File(file.path);
      _avatarB64  = base64Encode(bytes);
    });
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => _pickPhoto(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => _pickPhoto(ImageSource.camera),
            ),
            if (_avatarB64 != null)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: Colors.red),
                title: const Text('Remove photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _avatarB64  = null;
                    _pickedFile = null;
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name  = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name cannot be empty')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.onSaved(name, phone, _avatarB64);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String get _previewInitials {
    final n     = _nameCtrl.text.trim();
    final parts = n.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return n.isNotEmpty ? n[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Text('Edit Profile',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            _AvatarWidget(
                                avatarBase64: _avatarB64,
                                file:         _pickedFile,
                                initials:     _previewInitials,
                                radius:       50),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showPhotoOptions,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE07B39),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2),
                                  ),
                                  child: const Icon(
                                      Icons.camera_alt,
                                      size: 17,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildField(
                          controller: _nameCtrl,
                          icon: Icons.person_outline,
                          hint: 'Full name',
                          textCapitalization:
                          TextCapitalization.words),
                      const SizedBox(height: 12),
                      _buildField(
                          controller: _phoneCtrl,
                          icon: Icons.phone_outlined,
                          hint: 'Phone number (optional)',
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFDDDDDD)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.email_outlined,
                                color: Color(0xFFAAAAAA)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.currentEmail,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF888888)),
                              ),
                            ),
                            const Text('cannot edit',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFAAAAAA))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    MediaQuery.of(context).padding.bottom + 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE07B39),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white))
                        : const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData              icon,
    required String                hint,
    TextInputType                  keyboardType =
        TextInputType.text,
    TextCapitalization             textCapitalization =
        TextCapitalization.none,
  }) {
    return TextFormField(
      controller:          controller,
      keyboardType:        keyboardType,
      textCapitalization:  textCapitalization,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText:    hint,
        prefixIcon:  Icon(icon, color: const Color(0xFF888888)),
        filled:      true,
        fillColor:   const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFE07B39), width: 1.5),
        ),
      ),
    );
  }
}