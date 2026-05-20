
import 'package:flutter/material.dart';

// Save as: lib/screens/static/privacy_screen.dart

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
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
                // Hero card with orange theme
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFFE07B39).withOpacity(0.08), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE07B39).withOpacity(0.2),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE07B39).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.privacy_tip_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Privacy Matters',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Last updated: January 1, 2025',
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
                        Icons.shield_rounded,
                        color: const Color(0xFFE07B39),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We are committed to protecting your personal information and ensuring transparency in how we handle your data.',
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

                // Privacy sections with orange theme
                _PrivacySection(
                  title: '1. Information We Collect',
                  icon: Icons.data_usage_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Personal information you provide: name, email, phone number, and delivery address',
                    '• Payment information (processed securely through our payment partners)',
                    '• Usage data: device information, IP address, and in-app interactions',
                    '• Location data (with your permission) to provide accurate delivery estimates',
                  ],
                ),

                _PrivacySection(
                  title: '2. How We Use Your Information',
                  icon: Icons.analytics_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Process and deliver your orders accurately',
                    '• Send real-time delivery updates and notifications',
                    '• Improve our app features and user experience',
                    '• Personalize your shopping experience and recommendations',
                    '• Communicate promotions and special offers (you can opt-out anytime)',
                  ],
                ),

                _PrivacySection(
                  title: '3. Data Sharing',
                  icon: Icons.share_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• We DO NOT sell your personal information to third parties',
                    '• Share necessary data with delivery partners to fulfill your orders',
                    '• Share with payment processors to complete transactions securely',
                    '• All partners are bound by strict confidentiality agreements',
                  ],
                ),

                _PrivacySection(
                  title: '4. Data Security',
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Industry-standard encryption (TLS 1.3) for all data transmission',
                    '• Secure Firebase infrastructure with regular security audits',
                    '• Two-factor authentication available for account protection',
                    '• Access to personal data restricted to authorized personnel only',
                    '• Regular security patches and updates',
                  ],
                ),

                _PrivacySection(
                  title: '5. Cookies & Tracking',
                  icon: Icons.cookie_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Use analytics tools to understand user behavior and improve service',
                    '• Collect anonymized aggregate data for performance monitoring',
                    '• You can opt-out of analytics tracking through device settings',
                    '• Third-party SDKs used only for essential functionality',
                  ],
                ),

                _PrivacySection(
                  title: '6. Your Rights',
                  icon: Icons.verified_user_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Access your personal data anytime from profile settings',
                    '• Request correction of inaccurate information',
                    '• Delete your account and associated data permanently',
                    '• Export your data in a portable format',
                    '• Withdraw consent for marketing communications',
                  ],
                ),

                _PrivacySection(
                  title: "7. Children's Privacy",
                  icon: Icons.family_restroom_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Our service is not intended for users under 13 years of age',
                    '• We do not knowingly collect information from children',
                    '• If we discover such data, we will delete it immediately',
                    '• Parents/guardians can contact us to report concerns',
                  ],
                ),

                _PrivacySection(
                  title: '8. Changes to This Policy',
                  icon: Icons.update_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Policy reviewed and updated periodically',
                    '• Material changes communicated via in-app notification or email',
                    '• Continued use after updates constitutes acceptance',
                    '• Previous versions available upon request',
                  ],
                ),

                _PrivacySection(
                  title: '9. Contact Us',
                  icon: Icons.contact_support_rounded,
                  iconColor: const Color(0xFFE07B39),
                  body: [
                    '• Email: privacy@groceryapp.pk',
                    '• Phone: +1 (234) 567-8900',
                    '• In-app: Help Center > Privacy Support',
                    '• Response time: Within 48 hours',
                  ],
                  isContactSection: true,
                ),

                const SizedBox(height: 20),

                // Footer note with orange theme
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFFE07B39),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This Privacy Policy explains how we collect, use, and protect your personal information. By using our app, you agree to the terms outlined in this policy.',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFE07B39).withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60), // Increased bottom padding to prevent overflow
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> body;
  final bool isContactSection;

  const _PrivacySection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.body,
    this.isContactSection = false,
  });

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
              color: iconColor.withOpacity(0.08),
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
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: iconColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: body.asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == body.length - 1 ? 0 : 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isContactSection)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: iconColor.withOpacity(0.6),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isContactSection ? const Color(0xFF1A1A1A) : const Color(0xFF555555),
                            height: 1.6,
                            fontWeight: isContactSection ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}