// // lib/screens/static/refund_policy_screen.dart
// import 'package:flutter/material.dart';
//
// class RefundPolicyScreen extends StatelessWidget {
//   const RefundPolicyScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F4F4),
//       appBar: AppBar(
//         title: const Text(
//           'Refund & Return Policy',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: const Color(0xFFE07B39),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [const Color(0xFFE07B39).withOpacity(0.1), const Color(0xFFC4601F).withOpacity(0.05)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFE07B39).withOpacity(0.2)),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.assignment_return_rounded,
//                       size: 50,
//                       color: const Color(0xFFE07B39)),
//                   const SizedBox(height: 12),
//                   const Text(
//                     '7-Day Easy Returns',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'We want you to be completely satisfied with your purchase',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF666666),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Last Updated
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 'Last Updated: December 2024',
//                 style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // 1. Returns Policy
//             _buildSection(
//               title: '1. Returns Policy',
//               icon: Icons.swap_horiz,
//               iconColor: const Color(0xFFE07B39),
//               children: [
//                 _buildBulletPoint(
//                   'You have 7 calendar days from the date of delivery to return an item.',
//                 ),
//                 _buildBulletPoint(
//                   'To be eligible for a return, your item must be unused, unopened, and in the same condition that you received it.',
//                 ),
//                 _buildBulletPoint(
//                   'The item must be in the original packaging with all tags, labels, and accessories.',
//                 ),
//                 _buildBulletPoint(
//                   'Perishable items (fruits, vegetables, dairy products) cannot be returned unless they are damaged or spoiled upon arrival.',
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 2. Refund Process
//             _buildSection(
//               title: '2. Refund Process',
//               icon: Icons.payment,
//               iconColor: const Color(0xFF4CAF50),
//               children: [
//                 _buildBulletPoint(
//                   'Once we receive your returned item, we will inspect it and notify you of the approval or rejection of your refund.',
//                 ),
//                 _buildBulletPoint(
//                   'If approved, your refund will be processed within 5-7 business days.',
//                 ),
//                 _buildBulletPoint(
//                   'Refunds will be credited to your original payment method (credit card, debit card, UPI, or wallet).',
//                 ),
//                 _buildBulletPoint(
//                   'Shipping charges are non-refundable unless the return is due to our error or a defective product.',
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 3. How to Initiate a Return
//             _buildSection(
//               title: '3. How to Initiate a Return',
//               icon: Icons.assignment_outlined,
//               iconColor: const Color(0xFF2196F3),
//               children: [
//                 _buildStep('Step 1', 'Go to "My Orders" section in your profile'),
//                 _buildStep('Step 2', 'Select the order containing the item you wish to return'),
//                 _buildStep('Step 3', 'Click on "Return Item" and select the reason for return'),
//                 _buildStep('Step 4', 'Upload clear photos of the item (if applicable)'),
//                 _buildStep('Step 5', 'Submit your return request for approval'),
//                 _buildStep('Step 6', 'Once approved, pack the item securely and ship it back'),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 4. Non-Returnable Items
//             _buildSection(
//               title: '4. Non-Returnable Items',
//               icon: Icons.block,
//               iconColor: const Color(0xFFF44336),
//               children: [
//                 _buildBulletPoint(
//                   'Perishable goods such as fresh produce, dairy, meat, and frozen items',
//                   icon: Icons.cancel_outlined,
//                 ),
//                 _buildBulletPoint(
//                   'Personal care items (cosmetics, hygiene products) that have been opened',
//                   icon: Icons.cancel_outlined,
//                 ),
//                 _buildBulletPoint(
//                   'Gift cards and promotional items',
//                   icon: Icons.cancel_outlined,
//                 ),
//                 _buildBulletPoint(
//                   'Items purchased during clearance or final sale',
//                   icon: Icons.cancel_outlined,
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 5. Damaged or Defective Items
//             _buildSection(
//               title: '5. Damaged or Defective Items',
//               icon: Icons.warning_amber_rounded,
//               iconColor: const Color(0xFFFF9800),
//               children: [
//                 _buildBulletPoint(
//                   'If you receive a damaged, defective, or incorrect item, please contact us within 48 hours of delivery.',
//                 ),
//                 _buildBulletPoint(
//                   'We will arrange for a free pickup or replacement at no additional cost.',
//                 ),
//                 _buildBulletPoint(
//                   'Photos or videos of the damaged item may be required for verification.',
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFF9800).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.support_agent, color: const Color(0xFFFF9800), size: 20),
//                       const SizedBox(width: 10),
//                       const Expanded(
//                         child: Text(
//                           'Contact us immediately for damaged items: support@yourapp.com',
//                           style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 6. Refund Timing
//             _buildSection(
//               title: '6. Refund Timing',
//               icon: Icons.schedule,
//               iconColor: const Color(0xFF9C27B0),
//               children: [
//                 _buildTimelineCard(
//                   'Return Request Submitted',
//                   'Within 24 hours',
//                   Icons.send,
//                 ),
//                 _buildTimelineCard(
//                   'Return Approved',
//                   '1-2 business days',
//                   Icons.check_circle,
//                 ),
//                 _buildTimelineCard(
//                   'Item Shipped Back',
//                   'Within 7 days of approval',
//                   Icons.local_shipping,
//                 ),
//                 _buildTimelineCard(
//                   'Refund Processed',
//                   '5-7 business days after receipt',
//                   Icons.attach_money,
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // 7. Contact Information
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE07B39).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.contact_support_rounded,
//                           color: Color(0xFFE07B39),
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Need Help? Contact Us',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 12),
//                   _buildContactRow(Icons.email_outlined, 'Email', 'support@yourapp.com'),
//                   const SizedBox(height: 8),
//                   _buildContactRow(Icons.phone_outlined, 'Phone', '+1 (234) 567-8900'),
//                   const SizedBox(height: 8),
//                   _buildContactRow(Icons.access_time, 'Support Hours', 'Mon-Sat, 9 AM - 6 PM'),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Note
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFF3E0),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5)),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.info_outline, color: const Color(0xFFFF9800), size: 18),
//                   const SizedBox(width: 10),
//                   const Expanded(
//                     child: Text(
//                       'Note: This refund policy is subject to change without prior notice. Please review this policy periodically for any updates.',
//                       style: TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.4),
//                     ),
//                   ),
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
//   Widget _buildSection({
//     required String title,
//     required IconData icon,
//     required Color iconColor,
//     required List<Widget> children,
//   }) {
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
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: iconColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: iconColor, size: 22),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, indent: 16, endIndent: 16),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBulletPoint(String text, {IconData icon = Icons.check_circle_outline}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 14, color: Color(0xFF444444), height: 1.4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStep(String stepNumber, String description) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 stepNumber.replaceAll('Step ', ''),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               description,
//               style: const TextStyle(fontSize: 14, color: Color(0xFF444444)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineCard(String title, String timeline, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEEEEEE)),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: const Color(0xFFE07B39), size: 24),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   timeline,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF888888),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFCCCCCC)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: const Color(0xFF888888)),
//         const SizedBox(width: 12),
//         SizedBox(
//           width: 90,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF666666),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF333333),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'Refund & Return Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFE07B39),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFE07B39).withOpacity(0.1), const Color(0xFFC4601F).withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE07B39).withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.assignment_return_rounded,
                      size: 50,
                      color: const Color(0xFFE07B39)),
                  const SizedBox(height: 12),
                  const Text(
                    '7-Day Easy Returns',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We want you to be completely satisfied with your purchase',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Last Updated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Last Updated: December 2024',
                style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),
            ),

            const SizedBox(height: 24),

            // 1. Returns Policy
            _buildSection(
              title: '1. Returns Policy',
              icon: Icons.swap_horiz,
              iconColor: const Color(0xFFE07B39),
              children: [
                _buildBulletPoint(
                  'You have 7 calendar days from the date of delivery to return an item.',
                ),
                _buildBulletPoint(
                  'To be eligible for a return, your item must be unused, unopened, and in the same condition that you received it.',
                ),
                _buildBulletPoint(
                  'The item must be in the original packaging with all tags, labels, and accessories.',
                ),
                _buildBulletPoint(
                  'Perishable items (fruits, vegetables, dairy products) cannot be returned unless they are damaged or spoiled upon arrival.',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Refund Process
            _buildSection(
              title: '2. Refund Process',
              icon: Icons.payment,
              iconColor: const Color(0xFF4CAF50),
              children: [
                _buildBulletPoint(
                  'Once we receive your returned item, we will inspect it and notify you of the approval or rejection of your refund.',
                ),
                _buildBulletPoint(
                  'If approved, your refund will be processed within 5-7 business days.',
                ),
                _buildBulletPoint(
                  'Refunds will be credited to your original payment method (credit card, debit card, UPI, or wallet).',
                ),
                _buildBulletPoint(
                  'Shipping charges are non-refundable unless the return is due to our error or a defective product.',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3. How to Initiate a Return
            _buildSection(
              title: '3. How to Initiate a Return',
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFF2196F3),
              children: [
                _buildStep('Step 1', 'Go to "My Orders" section in your profile'),
                _buildStep('Step 2', 'Select the order containing the item you wish to return'),
                _buildStep('Step 3', 'Click on "Return Item" and select the reason for return'),
                _buildStep('Step 4', 'Upload clear photos of the item (if applicable)'),
                _buildStep('Step 5', 'Submit your return request for approval'),
                _buildStep('Step 6', 'Once approved, pack the item securely and ship it back'),
              ],
            ),

            const SizedBox(height: 20),

            // 4. Non-Returnable Items
            _buildSection(
              title: '4. Non-Returnable Items',
              icon: Icons.block,
              iconColor: const Color(0xFFF44336),
              children: [
                _buildBulletPoint(
                  'Perishable goods such as fresh produce, dairy, meat, and frozen items',
                  icon: Icons.cancel_outlined,
                ),
                _buildBulletPoint(
                  'Personal care items (cosmetics, hygiene products) that have been opened',
                  icon: Icons.cancel_outlined,
                ),
                _buildBulletPoint(
                  'Gift cards and promotional items',
                  icon: Icons.cancel_outlined,
                ),
                _buildBulletPoint(
                  'Items purchased during clearance or final sale',
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5. Damaged or Defective Items
            _buildSection(
              title: '5. Damaged or Defective Items',
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFFF9800),
              children: [
                _buildBulletPoint(
                  'If you receive a damaged, defective, or incorrect item, please contact us within 48 hours of delivery.',
                ),
                _buildBulletPoint(
                  'We will arrange for a free pickup or replacement at no additional cost.',
                ),
                _buildBulletPoint(
                  'Photos or videos of the damaged item may be required for verification.',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.support_agent, color: const Color(0xFFFF9800), size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Contact us immediately for damaged items: support@yourapp.com',
                          style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 6. Refund Timing
            _buildSection(
              title: '6. Refund Timing',
              icon: Icons.schedule,
              iconColor: const Color(0xFF9C27B0),
              children: [
                _buildTimelineCard(
                  'Return Request Submitted',
                  'Within 24 hours',
                  Icons.send,
                ),
                _buildTimelineCard(
                  'Return Approved',
                  '1-2 business days',
                  Icons.check_circle,
                ),
                _buildTimelineCard(
                  'Item Shipped Back',
                  'Within 7 days of approval',
                  Icons.local_shipping,
                ),
                _buildTimelineCard(
                  'Refund Processed',
                  '5-7 business days after receipt',
                  Icons.attach_money,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 7. Contact Information
            Container(
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE07B39).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.contact_support_rounded,
                          color: Color(0xFFE07B39),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Need Help? Contact Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.email_outlined, 'Email', 'support@yourapp.com'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.phone_outlined, 'Phone', '+1 (234) 567-8900'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.access_time, 'Support Hours', 'Mon-Sat, 9 AM - 6 PM'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Note - Fixed visibility with proper margin
            Container(
              margin: const EdgeInsets.only(bottom: 20), // Added bottom margin
              padding: const EdgeInsets.all(16), // Increased padding for better visibility
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: const Color(0xFFFF9800), size: 20), // Increased icon size
                  const SizedBox(width: 12), // Increased spacing
                  const Expanded(
                    child: Text(
                      'Note: This refund policy is subject to change without prior notice. Please review this policy periodically for any updates.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5), // Increased font size and line height
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Added extra padding at the bottom to prevent overflow
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, {IconData icon = Icons.check_circle_outline}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF444444), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String stepNumber, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.replaceAll('Step ', ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, color: Color(0xFF444444)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(String title, String timeline, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE07B39), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeline,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF888888)),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}