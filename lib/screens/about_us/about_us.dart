// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class AboutUsScreen extends StatefulWidget {
//   const AboutUsScreen({super.key});
//
//   @override
//   State<AboutUsScreen> createState() => _AboutUsScreenState();
// }
//
// class _AboutUsScreenState extends State<AboutUsScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _entryCtrl;
//   late final AnimationController _pulseCtrl;
//   late final ScrollController _scrollCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _slideAnim;
//   late final Animation<double> _pulseAnim;
//   bool _isScrolled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _entryCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..forward();
//     _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
//     _slideAnim = Tween<double>(begin: 30, end: 0).animate(
//       CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
//     );
//     _pulseCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//     _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
//     );
//     _scrollCtrl = ScrollController()
//       ..addListener(() {
//         final scrolled = _scrollCtrl.offset > 240;
//         if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
//       });
//   }
//
//   @override
//   void dispose() {
//     _entryCtrl.dispose();
//     _pulseCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Premium Dark Palette ──────────────────────────────────────────────────
//   static const _bg = Color(0xFF0A0A0F);
//   static const _bgCard = Color(0xFF13131A);
//   static const _bgCardAlt = Color(0xFF1A1A24);
//   static const _amber = Color(0xFFF59C1A);
//   static const _amberGlow = Color(0xFFFFBB4D);
//   static const _amberDark = Color(0xFFD4830D);
//   static const _green = Color(0xFF2ECC71);
//   static const _textPrimary = Color(0xFFF0EFE8);
//   static const _textSecondary = Color(0xFF8A8A9A);
//   static const _textMuted = Color(0xFF4A4A5A);
//   static const _border = Color(0xFF222230);
//   static const _borderGlow = Color(0xFF3A3A50);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _bg,
//         body: AnimatedBuilder(
//           animation: _entryCtrl,
//           builder: (context, child) => FadeTransition(
//             opacity: _fadeAnim,
//             child: Transform.translate(
//               offset: Offset(0, _slideAnim.value),
//               child: child,
//             ),
//           ),
//           child: CustomScrollView(
//             controller: _scrollCtrl,
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _LuxuryAppBar(isScrolled: _isScrolled, pulseAnim: _pulseAnim),
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 28),
//                     _ImpactStats(),
//                     const SizedBox(height: 40),
//                     _EditorialDivider(label: 'OUR ORIGIN'),
//                     const SizedBox(height: 20),
//                     _StorySection(),
//                     const SizedBox(height: 40),
//                     _EditorialDivider(label: 'THE MISSION'),
//                     const SizedBox(height: 20),
//                     _MissionSection(),
//                     const SizedBox(height: 40),
//                     _EditorialDivider(label: 'WHY US'),
//                     const SizedBox(height: 20),
//                     _WhyUsSection(),
//                     const SizedBox(height: 40),
//                     _EditorialDivider(label: 'FRESH READS'),
//                     const SizedBox(height: 20),
//                     _BlogsSection(),
//                     const SizedBox(height: 40),
//                     _EditorialDivider(label: 'GET IN TOUCH'),
//                     const SizedBox(height: 20),
//                     _ContactSection(),
//                     const SizedBox(height: 20),
//                     _FooterSection(),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Luxury App Bar ───────────────────────────────────────────────────────────
//
// class _LuxuryAppBar extends StatelessWidget {
//   final bool isScrolled;
//   final Animation<double> pulseAnim;
//   const _LuxuryAppBar({required this.isScrolled, required this.pulseAnim});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 480,
//       pinned: true,
//       stretch: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF0A0A0F),
//       systemOverlayStyle: SystemUiOverlayStyle.light,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
//         child: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.06),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.white.withOpacity(0.08)),
//             ),
//             child: const Icon(Icons.arrow_back_ios_new_rounded,
//                 size: 16, color: Colors.white70),
//           ),
//         ),
//       ),
//       title: AnimatedOpacity(
//         opacity: isScrolled ? 1 : 0,
//         duration: const Duration(milliseconds: 250),
//         child: Row(
//           children: [
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF59C1A),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: Text('🧺', style: TextStyle(fontSize: 14)),
//               ),
//             ),
//             const SizedBox(width: 10),
//             const Text(
//               'Fresh Basket',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 17,
//                 letterSpacing: -0.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         stretchModes: const [StretchMode.zoomBackground],
//         background: _HeroSection(pulseAnim: pulseAnim),
//       ),
//     );
//   }
// }
//
// class _HeroSection extends StatelessWidget {
//   final Animation<double> pulseAnim;
//   const _HeroSection({required this.pulseAnim});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // Background photo
//         Image.network(
//           'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=85',
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF1a2f1a), Color(0xFF0A0A0F)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ),
//         // Deep gradient overlay - dark at top and bottom
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xCC0A0A0F),
//                 Color(0x440A0A0F),
//                 Color(0x220A0A0F),
//                 Color(0xFF0A0A0F),
//               ],
//               stops: [0.0, 0.2, 0.6, 1.0],
//             ),
//           ),
//         ),
//         // Amber accent glow at bottom
//         Positioned(
//           bottom: -60,
//           left: -60,
//           child: AnimatedBuilder(
//             animation: pulseAnim,
//             builder: (_, __) => Transform.scale(
//               scale: pulseAnim.value,
//               child: Container(
//                 width: 260,
//                 height: 260,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       const Color(0xFFF59C1A).withOpacity(0.18),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // Content
//         SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Badge
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF59C1A).withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: const Color(0xFFF59C1A).withOpacity(0.35),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF2ECC71),
//                         ),
//                       ),
//                       const SizedBox(width: 7),
//                       const Text(
//                         'EST. 2019 · KARACHI, PAKISTAN',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFFF59C1A),
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Big headline
//                 const Text(
//                   'Where\nFreshness\nMeets Home.',
//                   style: TextStyle(
//                     fontSize: 44,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                     height: 1.05,
//                     letterSpacing: -1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 // Subline with accent
//                 Row(
//                   children: [
//                     Container(
//                       width: 3,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF59C1A),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         'Pakistan\'s premium farm-to-doorstep\norganic grocery service.',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white60,
//                           height: 1.55,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Impact Stats ─────────────────────────────────────────────────────────────
//
// class _ImpactStats extends StatelessWidget {
//   static const _stats = [
//     ('50K+', 'Customers', '👥'),
//     ('200+', 'Products', '🌿'),
//     ('4.9', 'App Rating', '⭐'),
//     ('5 Yrs', 'Serving You', '🏆'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFFF59C1A).withOpacity(0.4),
//               const Color(0xFF222230),
//               const Color(0xFFF59C1A).withOpacity(0.2),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF13131A),
//             borderRadius: BorderRadius.circular(22),
//           ),
//           child: Row(
//             children: List.generate(_stats.length * 2 - 1, (i) {
//               if (i.isOdd) {
//                 return Container(
//                   width: 1,
//                   height: 56,
//                   color: const Color(0xFF222230),
//                 );
//               }
//               final s = _stats[i ~/ 2];
//               return Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 22),
//                   child: Column(
//                     children: [
//                       Text(s.$3, style: const TextStyle(fontSize: 18)),
//                       const SizedBox(height: 6),
//                       Text(
//                         s.$1,
//                         style: const TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.w900,
//                           color: Color(0xFFF59C1A),
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         s.$2,
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Color(0xFF8A8A9A),
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Editorial Divider ────────────────────────────────────────────────────────
//
// class _EditorialDivider extends StatelessWidget {
//   final String label;
//   const _EditorialDivider({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           Container(
//             width: 3,
//             height: 14,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF59C1A),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFFF59C1A),
//               letterSpacing: 2.5,
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFFF59C1A).withOpacity(0.3),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Story Section ────────────────────────────────────────────────────────────
//
// class _StorySection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // Image card
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Stack(
//               children: [
//                 Image.network(
//                   'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800&q=80',
//                   height: 220,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 220,
//                     color: const Color(0xFF13131A),
//                     child: const Center(
//                       child: Text('🌾', style: TextStyle(fontSize: 60)),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 220,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: [
//                         const Color(0xFF0A0A0F).withOpacity(0.85),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 20,
//                   top: 0,
//                   bottom: 0,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF59C1A),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: const Text(
//                           'OUR STORY',
//                           style: TextStyle(
//                             fontSize: 9,
//                             fontWeight: FontWeight.w900,
//                             color: Color(0xFF0A0A0F),
//                             letterSpacing: 1.5,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const SizedBox(
//                         width: 180,
//                         child: Text(
//                           'Born from\na real need.',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             height: 1.1,
//                             letterSpacing: -0.8,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Text content card
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: const Color(0xFF13131A),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xFF222230)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Fresh Basket was born out of a simple frustration: finding truly fresh, hygienic produce in Karachi was nearly impossible.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFFF0EFE8),
//                     height: 1.55,
//                     letterSpacing: -0.2,
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 const Text(
//                   'We scanned the entire metropolitan for vendors that could deliver farm-fresh fruits, vegetables, and dried nuts — no matter the time of day. Our search ended in vain, but uncovered something even more valuable: a real need in the community.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF8A8A9A),
//                     height: 1.75,
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 const Text(
//                   'That need became Fresh Basket. Today, we bridge local farms with urban households across Karachi — delivering nature\'s finest directly to your doorstep.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF8A8A9A),
//                     height: 1.75,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Timeline chips
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: const [
//                     _TimelineChip(year: '2019', label: 'Founded'),
//                     _TimelineChip(year: '2021', label: 'Scaled to 10K users'),
//                     _TimelineChip(year: '2023', label: 'Launched mobile app'),
//                     _TimelineChip(year: '2025', label: '50K+ customers'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TimelineChip extends StatelessWidget {
//   final String year;
//   final String label;
//   const _TimelineChip({required this.year, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A24),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color(0xFF2A2A3A)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             year,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFFF59C1A),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 6),
//             width: 1,
//             height: 10,
//             color: const Color(0xFF3A3A50),
//           ),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               color: Color(0xFF8A8A9A),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Mission Section ──────────────────────────────────────────────────────────
//
// class _MissionSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // Big mission statement card
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(28),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFF59C1A), Color(0xFFD4830D)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: -40,
//                   right: -40,
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.07),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: -20,
//                   right: 30,
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.05),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: const Center(
//                         child: Text('🎯', style: TextStyle(fontSize: 24)),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Our Mission',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white70,
//                         letterSpacing: 1.0,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'To improve post-harvest management and distribution — from grading and packing to storing and transporting local agricultural produce.',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         height: 1.55,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Two sub-mission cards side by side
//           Row(
//             children: [
//               Expanded(
//                 child: _MiniMissionCard(
//                   emoji: '🌱',
//                   title: 'Support Local Farms',
//                   desc: 'Empowering Pakistan\'s agricultural communities.',
//                   accent: const Color(0xFF2ECC71),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _MiniMissionCard(
//                   emoji: '🚀',
//                   title: 'Reach Every Home',
//                   desc: 'Same-day delivery across Karachi.',
//                   accent: const Color(0xFF3498DB),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MiniMissionCard extends StatelessWidget {
//   final String emoji;
//   final String title;
//   final String desc;
//   final Color accent;
//   const _MiniMissionCard({
//     required this.emoji,
//     required this.title,
//     required this.desc,
//     required this.accent,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF13131A),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xFF222230)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: accent.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(emoji, style: const TextStyle(fontSize: 18)),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFFF0EFE8),
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             desc,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF8A8A9A),
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Why Us Section ───────────────────────────────────────────────────────────
//
// class _WhyUsSection extends StatelessWidget {
//   static const _features = [
//     _FeatureItem('🌿', 'Farm Fresh', 'Picked at peak ripeness and delivered within hours — not days.',
//         Color(0xFF2ECC71)),
//     _FeatureItem('⚡', 'Same-Day Delivery', 'Order before noon and receive by evening, every time.',
//         Color(0xFFF59C1A)),
//     _FeatureItem('🔬', '100% Hygienic', 'Rigorous quality and safety checks on every single batch.',
//         Color(0xFF3498DB)),
//     _FeatureItem('💬', '24/7 Support', 'Real humans, not bots — always ready to resolve your concerns.',
//         Color(0xFFE74C3C)),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // Full-width top highlight
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(22),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: const Color(0xFF13131A),
//               border: Border.all(color: const Color(0xFF222230)),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   right: 16,
//                   top: -10,
//                   child: Text('🧺',
//                       style: TextStyle(
//                           fontSize: 80,
//                           color: Colors.white.withOpacity(0.04))),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '"The freshest produce you\'ll find — guaranteed."',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFFF59C1A),
//                         fontStyle: FontStyle.italic,
//                         height: 1.4,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Whether it\'s cranberries for your morning smoothie or avocados for your table — we have it all, always fresh.',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFF8A8A9A),
//                         height: 1.65,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&q=80',
//                         height: 140,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 100,
//                           color: const Color(0xFF1A1A24),
//                           child: const Center(
//                             child: Text('🥑🍓🥦',
//                                 style: TextStyle(fontSize: 36)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Feature list items
//           ..._features.map((f) => _FeatureRow(item: f)),
//         ],
//       ),
//     );
//   }
// }
//
// class _FeatureItem {
//   final String emoji;
//   final String title;
//   final String desc;
//   final Color accent;
//   const _FeatureItem(this.emoji, this.title, this.desc, this.accent);
// }
//
// class _FeatureRow extends StatelessWidget {
//   final _FeatureItem item;
//   const _FeatureRow({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF13131A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF222230)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: item.accent.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(13),
//               border: Border.all(color: item.accent.withOpacity(0.2)),
//             ),
//             child: Center(
//               child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFFF0EFE8),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   item.desc,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF8A8A9A),
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               color: item.accent.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.arrow_forward_rounded,
//                 size: 14, color: item.accent),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Blogs Section ────────────────────────────────────────────────────────────
//
// class _BlogsSection extends StatelessWidget {
//   static const _blogs = [
//     _BlogEntry(
//       tag: 'Nutrition',
//       title: 'The Hidden Powers of Cashews',
//       desc: 'Why cashews are a must-have snack — especially during Ramadan.',
//       imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5b37304c041?w=600&q=80',
//       readTime: '4 min',
//     ),
//     _BlogEntry(
//       tag: 'Wellness',
//       title: 'Dry Fruits for a Healthy Ramadan',
//       desc: 'Essential nutrients your body craves during the fasting month.',
//       imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&q=80',
//       readTime: '6 min',
//     ),
//     _BlogEntry(
//       tag: 'Recipes',
//       title: 'Nutritious Iftar Recipes',
//       desc: 'Break your fast with these wholesome, energy-packed meals.',
//       imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=600&q=80',
//       readTime: '5 min',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 310,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         physics: const BouncingScrollPhysics(),
//         itemCount: _blogs.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 14),
//         itemBuilder: (_, i) => _BlogCard(data: _blogs[i]),
//       ),
//     );
//   }
// }
//
// class _BlogEntry {
//   final String tag;
//   final String title;
//   final String desc;
//   final String imageUrl;
//   final String readTime;
//   const _BlogEntry({
//     required this.tag,
//     required this.title,
//     required this.desc,
//     required this.imageUrl,
//     required this.readTime,
//   });
// }
//
// class _BlogCard extends StatelessWidget {
//   final _BlogEntry data;
//   const _BlogCard({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 230,
//       decoration: BoxDecoration(
//         color: const Color(0xFF13131A),
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: const Color(0xFF222230)),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Image.network(
//                 data.imageUrl,
//                 height: 145,
//                 width: 230,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   height: 145,
//                   color: const Color(0xFF1A1A24),
//                   child: const Center(child: Text('🌿', style: TextStyle(fontSize: 40))),
//                 ),
//               ),
//               // Gradient overlay
//               Container(
//                 height: 145,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.transparent, Color(0xCC13131A)],
//                     stops: [0.5, 1.0],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF59C1A),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     data.tag.toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w900,
//                       color: Color(0xFF0A0A0F),
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     data.readTime,
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.title,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800,
//                       color: Color(0xFFF0EFE8),
//                       height: 1.3,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Expanded(
//                     child: Text(
//                       data.desc,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF8A8A9A),
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Text(
//                         'Read article',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFFF59C1A),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       const Icon(Icons.north_east_rounded,
//                           size: 12, color: Color(0xFFF59C1A)),
//                     ],
//                   ),
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
// // ─── Contact / Social Section ─────────────────────────────────────────────────
//
// class _ContactSection extends StatelessWidget {
//   static final _socials = [
//     _Social(icon: Icons.facebook_rounded, label: 'Facebook',
//         color: const Color(0xFF1877F2), url: 'https://facebook.com'),
//     _Social(icon: Icons.camera_alt_rounded, label: 'Instagram',
//         color: const Color(0xFFE1306C), url: 'https://instagram.com'),
//     _Social(icon: Icons.play_circle_fill, label: 'YouTube',
//         color: const Color(0xFFFF0000), url: 'https://youtube.com'),
//     _Social(icon: Icons.chat_rounded, label: 'WhatsApp',
//         color: const Color(0xFF25D366), url: 'https://wa.me/'),
//     _Social(icon: Icons.send_rounded, label: 'Telegram',
//         color: const Color(0xFF229ED9), url: 'https://telegram.org'),
//     _Social(icon: Icons.music_video_rounded, label: 'TikTok',
//         color: const Color(0xFFEE1D52), url: 'https://tiktok.com'),
//     _Social(icon: Icons.email_rounded, label: 'Email',
//         color: const Color(0xFFF59C1A), url: 'mailto:support@freshbasket.com'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // CTA card
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: const Color(0xFF13131A),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xFF222230)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Connect with us',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w900,
//                     color: Color(0xFFF0EFE8),
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   'Follow for fresh deals, recipes, and farm stories.',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF8A8A9A),
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 22),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: _socials
//                       .map((s) => GestureDetector(
//                     onTap: () => _launch(s.url),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 14, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: s.color.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: s.color.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(s.icon, color: s.color, size: 18),
//                           const SizedBox(width: 7),
//                           Text(
//                             s.label,
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: s.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ))
//                       .toList(),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Phone / Email quick contact
//           Row(
//             children: [
//               Expanded(
//                 child: _QuickContact(
//                   icon: Icons.phone_rounded,
//                   label: 'Call Us',
//                   value: '+92 300 123 4567',
//                   color: const Color(0xFF2ECC71),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _QuickContact(
//                   icon: Icons.location_on_rounded,
//                   label: 'Find Us',
//                   value: 'Karachi, Pakistan',
//                   color: const Color(0xFF3498DB),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _launch(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
// }
//
// class _QuickContact extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color color;
//   const _QuickContact({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF13131A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF222230)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 18),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF8A8A9A),
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFFF0EFE8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Social {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final String url;
//   const _Social({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.url,
//   });
// }
//
// // ─── Footer ───────────────────────────────────────────────────────────────────
//
// class _FooterSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: const Color(0xFF13131A),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: const Color(0xFF222230)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF59C1A),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Center(
//                     child: Text('🧺', style: TextStyle(fontSize: 18)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   'Fresh Basket',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w900,
//                     color: Color(0xFFF0EFE8),
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Straight from the farm into your home.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF8A8A9A),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.transparent,
//                     const Color(0xFF2A2A3A),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               '© 2025 Fresh Basket · All rights reserved',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF4A4A5A),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final AnimationController _pulseCtrl;
  late final ScrollController _scrollCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;
  late final Animation<double> _pulseAnim;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _scrollCtrl = ScrollController()
      ..addListener(() {
        final scrolled = _scrollCtrl.offset > 240;
        if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
      });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── White & Orange Theme Palette ──────────────────────────────────────────
  static const _bg = Color(0xFFFEFEFE);
  static const _bgCard = Color(0xFFFFFFFF);
  static const _bgCardAlt = Color(0xFFF9F9F9);
  static const _orange = Color(0xFFE07B39);
  static const _orangeLight = Color(0xFFFFE0CC);
  static const _orangeDark = Color(0xFFC45A1A);
  static const _green = Color(0xFF4CAF50);
  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textSecondary = Color(0xFF666666);
  static const _textMuted = Color(0xFF999999);
  static const _border = Color(0xFFEEEEEE);
  static const _borderGlow = Color(0xFFE07B39);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _bg,
        body: AnimatedBuilder(
          animation: _entryCtrl,
          builder: (context, child) => FadeTransition(
            opacity: _fadeAnim,
            child: Transform.translate(
              offset: Offset(0, _slideAnim.value),
              child: child,
            ),
          ),
          child: CustomScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _LuxuryAppBar(isScrolled: _isScrolled, pulseAnim: _pulseAnim),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    _ImpactStats(),
                    const SizedBox(height: 40),
                    _EditorialDivider(label: 'OUR ORIGIN'),
                    const SizedBox(height: 20),
                    _StorySection(),
                    const SizedBox(height: 40),
                    _EditorialDivider(label: 'THE MISSION'),
                    const SizedBox(height: 20),
                    _MissionSection(),
                    const SizedBox(height: 40),
                    _EditorialDivider(label: 'WHY US'),
                    const SizedBox(height: 20),
                    _WhyUsSection(),
                    const SizedBox(height: 40),
                    _EditorialDivider(label: 'FRESH READS'),
                    const SizedBox(height: 20),
                    _BlogsSection(),
                    const SizedBox(height: 40),
                    _EditorialDivider(label: 'GET IN TOUCH'),
                    const SizedBox(height: 20),
                    _ContactSection(),
                    const SizedBox(height: 20),
                    _FooterSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Luxury App Bar ───────────────────────────────────────────────────────────

class _LuxuryAppBar extends StatelessWidget {
  final bool isScrolled;
  final Animation<double> pulseAnim;
  const _LuxuryAppBar({required this.isScrolled, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 480,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: const Color(0xFFFEFEFE),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE07B39).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE07B39).withOpacity(0.2)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Color(0xFFE07B39)),
          ),
        ),
      ),
      title: AnimatedOpacity(
        opacity: isScrolled ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFE07B39),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('🧺', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Fresh Basket',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: _HeroSection(pulseAnim: pulseAnim),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _HeroSection({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background photo
        Image.network(
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=85',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFE07B39).withOpacity(0.3), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.7),
                Colors.white.withOpacity(0.5),
                Colors.white,
              ],
              stops: const [0.0, 0.2, 0.6, 1.0],
            ),
          ),
        ),
        // Orange accent glow at bottom
        Positioned(
          bottom: -60,
          left: -60,
          child: AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: pulseAnim.value,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE07B39).withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE07B39).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        'EST. 2019 · KARACHI, PAKISTAN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE07B39),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Big headline
                const Text(
                  'Where\nFreshness\nMeets Home.',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    height: 1.05,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 14),
                // Subline with accent
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE07B39),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Pakistan\'s premium farm-to-doorstep\norganic grocery service.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Impact Stats ─────────────────────────────────────────────────────────────

class _ImpactStats extends StatelessWidget {
  static const _stats = [
    ('50K+', 'Customers', '👥'),
    ('200+', 'Products', '🌿'),
    ('4.9', 'App Rating', '⭐'),
    ('5 Yrs', 'Serving You', '🏆'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE07B39).withOpacity(0.4),
              const Color(0xFFEEEEEE),
              const Color(0xFFE07B39).withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: List.generate(_stats.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Container(
                  width: 1,
                  height: 56,
                  color: const Color(0xFFEEEEEE),
                );
              }
              final s = _stats[i ~/ 2];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Column(
                    children: [
                      Text(s.$3, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(
                        s.$1,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFE07B39),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.$2,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Editorial Divider ────────────────────────────────────────────────────────

class _EditorialDivider extends StatelessWidget {
  final String label;
  const _EditorialDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFE07B39),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE07B39),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE07B39).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Story Section ────────────────────────────────────────────────────────────

class _StorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Image card
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800&q=80',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: const Color(0xFFF9F9F9),
                    child: const Center(
                      child: Text('🌾', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE07B39),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OUR STORY',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        width: 180,
                        child: Text(
                          'Born from\na real need.',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                            height: 1.1,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Text content card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fresh Basket was born out of a simple frustration: finding truly fresh, hygienic produce in Karachi was nearly impossible.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.55,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'We scanned the entire metropolitan for vendors that could deliver farm-fresh fruits, vegetables, and dried nuts — no matter the time of day. Our search ended in vain, but uncovered something even more valuable: a real need in the community.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'That need became Fresh Basket. Today, we bridge local farms with urban households across Karachi — delivering nature\'s finest directly to your doorstep.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 20),
                // Timeline chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _TimelineChip(year: '2019', label: 'Founded'),
                    _TimelineChip(year: '2021', label: 'Scaled to 10K users'),
                    _TimelineChip(year: '2023', label: 'Launched mobile app'),
                    _TimelineChip(year: '2025', label: '50K+ customers'),
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

class _TimelineChip extends StatelessWidget {
  final String year;
  final String label;
  const _TimelineChip({required this.year, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            year,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE07B39),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 1,
            height: 10,
            color: const Color(0xFFDDDDDD),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mission Section ──────────────────────────────────────────────────────────

class _MissionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Big mission statement card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFE07B39), Color(0xFFC45A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  right: 30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('🎯', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'To improve post-harvest management and distribution — from grading and packing to storing and transporting local agricultural produce.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.55,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Two sub-mission cards side by side
          Row(
            children: [
              Expanded(
                child: _MiniMissionCard(
                  emoji: '🌱',
                  title: 'Support Local Farms',
                  desc: 'Empowering Pakistan\'s agricultural communities.',
                  accent: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniMissionCard(
                  emoji: '🚀',
                  title: 'Reach Every Home',
                  desc: 'Same-day delivery across Karachi.',
                  accent: const Color(0xFFE07B39),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMissionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  final Color accent;
  const _MiniMissionCard({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Why Us Section ───────────────────────────────────────────────────────────

class _WhyUsSection extends StatelessWidget {
  static const _features = [
    _FeatureItem('🌿', 'Farm Fresh', 'Picked at peak ripeness and delivered within hours — not days.',
        Color(0xFF4CAF50)),
    _FeatureItem('⚡', 'Same-Day Delivery', 'Order before noon and receive by evening, every time.',
        Color(0xFFE07B39)),
    _FeatureItem('🔬', '100% Hygienic', 'Rigorous quality and safety checks on every single batch.',
        Color(0xFF2196F3)),
    _FeatureItem('💬', '24/7 Support', 'Real humans, not bots — always ready to resolve your concerns.',
        Color(0xFFE74C3C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Full-width top highlight
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  top: -10,
                  child: Text('🧺',
                      style: TextStyle(
                          fontSize: 80,
                          color: const Color(0xFFE07B39).withOpacity(0.05))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '"The freshest produce you\'ll find — guaranteed."',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE07B39),
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Whether it\'s fruits for your morning smoothie or vegetables for your dinner table — we have it all, always fresh.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&q=80',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          color: const Color(0xFFF9F9F9),
                          child: const Center(
                            child: Text('🥑🍓🥦',
                                style: TextStyle(fontSize: 36)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Feature list items
          ..._features.map((f) => _FeatureRow(item: f)),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final String emoji;
  final String title;
  final String desc;
  final Color accent;
  const _FeatureItem(this.emoji, this.title, this.desc, this.accent);
}

class _FeatureRow extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: item.accent.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: item.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.arrow_forward_rounded,
                size: 14, color: item.accent),
          ),
        ],
      ),
    );
  }
}

// ─── Blogs Section ────────────────────────────────────────────────────────────

class _BlogsSection extends StatelessWidget {
  static const _blogs = [
    _BlogEntry(
      tag: 'Nutrition',
      title: 'The Hidden Powers of Cashews',
      desc: 'Why cashews are a must-have snack — especially during Ramadan.',
      imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5b37304c041?w=600&q=80',
      readTime: '4 min',
    ),
    _BlogEntry(
      tag: 'Wellness',
      title: 'Dry Fruits for a Healthy Ramadan',
      desc: 'Essential nutrients your body craves during the fasting month.',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&q=80',
      readTime: '6 min',
    ),
    _BlogEntry(
      tag: 'Recipes',
      title: 'Nutritious Iftar Recipes',
      desc: 'Break your fast with these wholesome, energy-packed meals.',
      imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=600&q=80',
      readTime: '5 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: _blogs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _BlogCard(data: _blogs[i]),
      ),
    );
  }
}

class _BlogEntry {
  final String tag;
  final String title;
  final String desc;
  final String imageUrl;
  final String readTime;
  const _BlogEntry({
    required this.tag,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.readTime,
  });
}

class _BlogCard extends StatelessWidget {
  final _BlogEntry data;
  const _BlogCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                data.imageUrl,
                height: 145,
                width: 230,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 145,
                  color: const Color(0xFFF9F9F9),
                  child: const Center(child: Text('🌿', style: TextStyle(fontSize: 40))),
                ),
              ),
              // Gradient overlay
              Container(
                height: 145,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white.withOpacity(0.9)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.tag.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.readTime,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      data.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Read article',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE07B39),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.north_east_rounded,
                          size: 12, color: Color(0xFFE07B39)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact / Social Section ─────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  static final _socials = [
    _Social(icon: Icons.facebook_rounded, label: 'Facebook',
        color: const Color(0xFF1877F2), url: 'https://facebook.com'),
    _Social(icon: Icons.camera_alt_rounded, label: 'Instagram',
        color: const Color(0xFFE1306C), url: 'https://instagram.com'),
    _Social(icon: Icons.play_circle_fill, label: 'YouTube',
        color: const Color(0xFFFF0000), url: 'https://youtube.com'),
    _Social(icon: Icons.chat_rounded, label: 'WhatsApp',
        color: const Color(0xFF25D366), url: 'https://wa.me/'),
    _Social(icon: Icons.send_rounded, label: 'Telegram',
        color: const Color(0xFF229ED9), url: 'https://telegram.org'),
    _Social(icon: Icons.music_video_rounded, label: 'TikTok',
        color: const Color(0xFFEE1D52), url: 'https://tiktok.com'),
    _Social(icon: Icons.email_rounded, label: 'Email',
        color: const Color(0xFFE07B39), url: 'mailto:support@freshbasket.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // CTA card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Connect with us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Follow for fresh deals, recipes, and farm stories.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _socials
                      .map((s) => GestureDetector(
                    onTap: () => _launch(s.url),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: s.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: s.color.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(s.icon, color: s.color, size: 18),
                          const SizedBox(width: 7),
                          Text(
                            s.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: s.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Phone / Email quick contact
          Row(
            children: [
              Expanded(
                child: _QuickContact(
                  icon: Icons.phone_rounded,
                  label: 'Call Us',
                  value: '+92 300 123 4567',
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickContact(
                  icon: Icons.location_on_rounded,
                  label: 'Find Us',
                  value: 'Karachi, Pakistan',
                  color: const Color(0xFFE07B39),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _QuickContact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _QuickContact({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF999999),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _Social {
  final IconData icon;
  final String label;
  final Color color;
  final String url;
  const _Social({
    required this.icon,
    required this.label,
    required this.color,
    required this.url,
  });
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🧺', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Fresh Basket',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Straight from the farm into your home.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFEEEEEE),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 Fresh Basket · All rights reserved',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}