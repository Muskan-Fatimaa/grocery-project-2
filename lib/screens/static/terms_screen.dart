
// import 'package:flutter/material.dart';
//
// // Save as: lib/screens/static/terms_screen.dart
//
// class TermsScreen extends StatelessWidget {
//   const TermsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return _StaticPage(
//       title: 'Terms & Conditions',
//       icon: Icons.description_rounded,
//       iconColor: const Color(0xFF26A69A),
//       lastUpdated: 'Last updated: January 1, 2025',
//       sections: [
//         _Section(
//           title: '1. Acceptance of Terms',
//           icon: Icons.check_circle_outline,
//           body: const [
//             'By accessing or using our grocery delivery application, you agree to be bound by these Terms and Conditions',
//             'If you do not agree to all terms, please do not use our service',
//             'These terms form a legally binding agreement between you and our company',
//             'We reserve the right to refuse service to anyone for any reason at any time',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '2. Use of Service',
//           icon: Icons.shopping_cart_outlined,
//           body: const [
//             'You must be at least 18 years old to create an account and use our service',
//             'You agree to provide accurate, current, and complete information during registration',
//             'You are responsible for maintaining the security of your account credentials',
//             'Notify us immediately of any unauthorized use of your account',
//             'We reserve the right to terminate accounts that violate these terms',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '3. Orders & Payments',
//           icon: Icons.payment_outlined,
//           body: const [
//             'All orders are subject to product availability and acceptance',
//             'Prices may change without prior notice, but confirmed orders are honored at the price at checkout',
//             'We accept Cash on Delivery, EasyPaisa, JazzCash, and credit/debit cards',
//             'Orders are confirmed only after successful payment or COD selection',
//             'We reserve the right to cancel any order due to suspicious activity or errors',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '4. Delivery Policy',
//           icon: Icons.local_shipping_outlined,
//           body: const [
//             'Delivery times are estimates and not guaranteed',
//             'We aim to deliver within the estimated time shown at checkout',
//             'Delivery times may vary due to traffic, weather, or high demand',
//             'We are not responsible for delays beyond our control (natural disasters, strikes, etc.)',
//             'Please ensure someone is available to receive the order at the delivery address',
//             'Failed delivery attempts may result in order cancellation and fees',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '5. Cancellation & Refunds',
//           icon: Icons.assignment_return_outlined,
//           body: const [
//             'Orders may be cancelled before dispatch without any fees',
//             'Once dispatched, cancellations may not be possible',
//             'Refunds for cancelled or incorrect orders are processed within 3-5 business days',
//             'Products that are damaged, expired, or incorrect may be returned at the time of delivery',
//             'Refunds will be credited to your original payment method',
//             'Shipping fees are non-refundable for customer-initiated cancellations',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '6. Product Availability',
//           icon: Icons.inventory_2_outlined,
//           body: const [
//             'We make every effort to keep our inventory accurate and up-to-date',
//             'Some items may be out of stock after your order is placed due to high demand',
//             'We will notify you immediately if items in your order become unavailable',
//             'You will be offered alternatives or a full refund for unavailable items',
//             'We reserve the right to limit quantities of items purchased per order',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '7. User Responsibilities',
//           icon: Icons.person_outline,
//           body: const [
//             'You agree to use the app only for lawful purposes',
//             'You shall not misuse the app by introducing viruses, malware, or harmful code',
//             'You shall not attempt to gain unauthorized access to our systems',
//             'You shall not copy, modify, or distribute our app content without permission',
//             'Violation may result in immediate termination of your account and legal action',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '8. Limitation of Liability',
//           icon: Icons.gavel_outlined,
//           body: const [
//             'We are not liable for any indirect, incidental, or consequential damages',
//             'Our maximum liability shall not exceed the value of the order placed',
//             'We are not responsible for allergic reactions to products purchased',
//             'We do not guarantee that the app will be error-free or uninterrupted',
//             'Some jurisdictions do not allow limitation of liability, so limitations may not apply to you',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '9. Intellectual Property',
//           icon: Icons.copyright_outlined,
//           body: const [
//             'All content in the app is our intellectual property',
//             'You may not reproduce, distribute, or create derivative works without permission',
//             'Our trademarks and logos may not be used without prior written consent',
//             'Unauthorized use may result in legal action and termination of service',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '10. Changes to Terms',
//           icon: Icons.update_outlined,
//           body: const [
//             'We reserve the right to modify these terms at any time',
//             'Continued use of the app after changes constitutes your acceptance',
//             'Material changes will be notified via email or in-app notification',
//             'We encourage you to review this page periodically for updates',
//             'The most current version will always be available in the app',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '11. Governing Law',
//           icon: Icons.gavel_outlined,
//           body: const [
//             'These terms are governed by the laws of Pakistan',
//             'Any disputes shall be resolved in the courts of Karachi',
//             'You agree to submit to the exclusive jurisdiction of these courts',
//             'If any provision is found unenforceable, the remaining provisions remain in effect',
//           ],
//           isContactSection: false,
//         ),
//         _Section(
//           title: '12. Contact Us',
//           icon: Icons.contact_support_outlined,
//           body: const [
//             '📧 Email: support@groceryapp.pk',
//             '📞 Phone: +1 (234) 567-8900',
//             '💬 In-app: Help Center > Support Ticket',
//             '⏰ Response Time: Within 24-48 hours',
//             '📍 Office: 123 Business Avenue, Karachi, Pakistan',
//           ],
//           isContactSection: true,
//         ),
//       ],
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Shared static page shell
// // ─────────────────────────────────────────────────────────────────────────────
// class _StaticPage extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color iconColor;
//   final String lastUpdated;
//   final List<_Section> sections;
//
//   const _StaticPage({
//     required this.title,
//     required this.icon,
//     required this.iconColor,
//     required this.lastUpdated,
//     required this.sections,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F4F4),
//       body: Column(
//         children: [
//           // Gradient AppBar matching the app theme
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: SafeArea(
//               bottom: false,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // Hero card with gradient background
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [iconColor.withOpacity(0.08), Colors.white],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: iconColor.withOpacity(0.2),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [iconColor, iconColor.withOpacity(0.7)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: iconColor.withOpacity(0.3),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Icon(icon, color: Colors.white, size: 28),
//                       ),
//                       const SizedBox(width: 16),
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Terms of Service',
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w800,
//                                 color: Color(0xFF1A1A1A),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'Please read carefully before using our service',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF888888),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Quick info card
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE0F2F1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: const Color(0xFF26A69A).withOpacity(0.3),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: const Color(0xFF26A69A),
//                         size: 24,
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Text(
//                           'By using our app, you agree to comply with these Terms & Conditions. Please read them carefully before placing an order.',
//                           style: TextStyle(
//                             fontSize: 12.5,
//                             color: Color(0xFF004D40),
//                             height: 1.4,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Last updated chip
//                 Center(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       lastUpdated,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Color(0xFF888888),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Sections
//                 ...sections.map((s) => _SectionCard(section: s)),
//
//                 const SizedBox(height: 40), // Increased bottom padding for better scrolling
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SectionCard extends StatelessWidget {
//   final _Section section;
//   const _SectionCard({required this.section});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header with icon
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF26A69A).withOpacity(0.08),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF26A69A).withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     section.icon,
//                     color: const Color(0xFF26A69A),
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     section.title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                       color: Color(0xFF26A69A),
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Body content with bullet points
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(section.body.length, (index) {
//                 final text = section.body[index];
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: index == section.body.length - 1 ? 0 : 10),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (section.isContactSection)
//                         Container(
//                           margin: const EdgeInsets.only(top: 6),
//                           width: 4,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF26A69A),
//                             shape: BoxShape.circle,
//                           ),
//                         )
//                       else
//                         Icon(
//                           Icons.circle,
//                           size: 6,
//                           color: const Color(0xFF26A69A).withOpacity(0.6),
//                         ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           text,
//                           style: TextStyle(
//                             fontSize: 13.5,
//                             color: section.isContactSection ? const Color(0xFF1A1A1A) : const Color(0xFF555555),
//                             height: 1.6,
//                             fontWeight: section.isContactSection ? FontWeight.w600 : FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Section {
//   final String title;
//   final IconData icon;
//   final List<String> body;
//   final bool isContactSection;
//
//   const _Section({
//     required this.title,
//     required this.icon,
//     required this.body,
//     required this.isContactSection,
//   });
// }

import 'package:flutter/material.dart';

// Save as: lib/screens/static/terms_screen.dart

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _StaticPage(
      title: 'Terms & Conditions',
      icon: Icons.description_rounded,
      iconColor: const Color(0xFFE07B39),
      lastUpdated: 'Last updated: January 1, 2025',
      sections: [
        _Section(
          title: '1. Acceptance of Terms',
          icon: Icons.check_circle_outline,
          body: const [
            'By accessing or using our grocery delivery application, you agree to be bound by these Terms and Conditions',
            'If you do not agree to all terms, please do not use our service',
            'These terms form a legally binding agreement between you and our company',
            'We reserve the right to refuse service to anyone for any reason at any time',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '2. Use of Service',
          icon: Icons.shopping_cart_outlined,
          body: const [
            'You must be at least 18 years old to create an account and use our service',
            'You agree to provide accurate, current, and complete information during registration',
            'You are responsible for maintaining the security of your account credentials',
            'Notify us immediately of any unauthorized use of your account',
            'We reserve the right to terminate accounts that violate these terms',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '3. Orders & Payments',
          icon: Icons.payment_outlined,
          body: const [
            'All orders are subject to product availability and acceptance',
            'Prices may change without prior notice, but confirmed orders are honored at the price at checkout',
            'We accept Cash on Delivery, EasyPaisa, JazzCash, and credit/debit cards',
            'Orders are confirmed only after successful payment or COD selection',
            'We reserve the right to cancel any order due to suspicious activity or errors',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '4. Delivery Policy',
          icon: Icons.local_shipping_outlined,
          body: const [
            'Delivery times are estimates and not guaranteed',
            'We aim to deliver within the estimated time shown at checkout',
            'Delivery times may vary due to traffic, weather, or high demand',
            'We are not responsible for delays beyond our control (natural disasters, strikes, etc.)',
            'Please ensure someone is available to receive the order at the delivery address',
            'Failed delivery attempts may result in order cancellation and fees',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '5. Cancellation & Refunds',
          icon: Icons.assignment_return_outlined,
          body: const [
            'Orders may be cancelled before dispatch without any fees',
            'Once dispatched, cancellations may not be possible',
            'Refunds for cancelled or incorrect orders are processed within 3-5 business days',
            'Products that are damaged, expired, or incorrect may be returned at the time of delivery',
            'Refunds will be credited to your original payment method',
            'Shipping fees are non-refundable for customer-initiated cancellations',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '6. Product Availability',
          icon: Icons.inventory_2_outlined,
          body: const [
            'We make every effort to keep our inventory accurate and up-to-date',
            'Some items may be out of stock after your order is placed due to high demand',
            'We will notify you immediately if items in your order become unavailable',
            'You will be offered alternatives or a full refund for unavailable items',
            'We reserve the right to limit quantities of items purchased per order',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '7. User Responsibilities',
          icon: Icons.person_outline,
          body: const [
            'You agree to use the app only for lawful purposes',
            'You shall not misuse the app by introducing viruses, malware, or harmful code',
            'You shall not attempt to gain unauthorized access to our systems',
            'You shall not copy, modify, or distribute our app content without permission',
            'Violation may result in immediate termination of your account and legal action',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '8. Limitation of Liability',
          icon: Icons.gavel_outlined,
          body: const [
            'We are not liable for any indirect, incidental, or consequential damages',
            'Our maximum liability shall not exceed the value of the order placed',
            'We are not responsible for allergic reactions to products purchased',
            'We do not guarantee that the app will be error-free or uninterrupted',
            'Some jurisdictions do not allow limitation of liability, so limitations may not apply to you',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '9. Intellectual Property',
          icon: Icons.copyright_outlined,
          body: const [
            'All content in the app is our intellectual property',
            'You may not reproduce, distribute, or create derivative works without permission',
            'Our trademarks and logos may not be used without prior written consent',
            'Unauthorized use may result in legal action and termination of service',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '10. Changes to Terms',
          icon: Icons.update_outlined,
          body: const [
            'We reserve the right to modify these terms at any time',
            'Continued use of the app after changes constitutes your acceptance',
            'Material changes will be notified via email or in-app notification',
            'We encourage you to review this page periodically for updates',
            'The most current version will always be available in the app',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '11. Governing Law',
          icon: Icons.gavel_outlined,
          body: const [
            'These terms are governed by the laws of Pakistan',
            'Any disputes shall be resolved in the courts of Karachi',
            'You agree to submit to the exclusive jurisdiction of these courts',
            'If any provision is found unenforceable, the remaining provisions remain in effect',
          ],
          isContactSection: false,
        ),
        _Section(
          title: '12. Contact Us',
          icon: Icons.contact_support_outlined,
          body: const [
            '📧 Email: support@groceryapp.pk',
            '📞 Phone: +1 (234) 567-8900',
            '💬 In-app: Help Center > Support Ticket',
            '⏰ Response Time: Within 24-48 hours',
            '📍 Office: 123 Business Avenue, Karachi, Pakistan',
          ],
          isContactSection: true,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared static page shell
// ─────────────────────────────────────────────────────────────────────────────
class _StaticPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String lastUpdated;
  final List<_Section> sections;

  const _StaticPage({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // Gradient AppBar matching the app theme
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Hero card with gradient background
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [iconColor.withOpacity(0.08), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: iconColor.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [iconColor, iconColor.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: iconColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Please read carefully before using our service',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF888888),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick info card with orange theme
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE07B39).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFFE07B39),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'By using our app, you agree to comply with these Terms & Conditions. Please read them carefully before placing an order.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: const Color(0xFFE07B39).withOpacity(0.8),
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Last updated chip
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lastUpdated,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sections
                ...sections.map((s) => _SectionCard(section: s)),

                const SizedBox(height: 60), // Increased bottom padding for better scrolling
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _Section section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon - Orange theme
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE07B39).withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    section.icon,
                    color: const Color(0xFFE07B39),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFFE07B39),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body content with bullet points
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(section.body.length, (index) {
                final text = section.body[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index == section.body.length - 1 ? 0 : 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (section.isContactSection)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE07B39),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: const Color(0xFFE07B39).withOpacity(0.6),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: section.isContactSection ? const Color(0xFF1A1A1A) : const Color(0xFF555555),
                            height: 1.6,
                            fontWeight: section.isContactSection ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section {
  final String title;
  final IconData icon;
  final List<String> body;
  final bool isContactSection;

  const _Section({
    required this.title,
    required this.icon,
    required this.body,
    required this.isContactSection,
  });
}