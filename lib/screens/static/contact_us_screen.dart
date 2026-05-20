
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Save as: lib/screens/static/contact_us_screen.dart

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  static const _orange = Color(0xFFE07B39);
  static const _darkGreen = Color(0xFF0D3B2E);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_nameCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your name and message.')),
      );
      return;
    }
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent! We\'ll get back to you shortly.'),
        backgroundColor: Color(0xFFE07B39),
      ),
    );
    _nameCtrl.clear();
    _emailCtrl.clear();
    _messageCtrl.clear();
  }

  Future<void> _openMap(String query) async {
    final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // Orange AppBar
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
                      'Contact Us',
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
              padding: const EdgeInsets.only(bottom: 32), // Added bottom padding
              children: [
                // ── Hero banner ──────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE07B39), Color(0xFFC4601F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE07B39).withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.headset_mic_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('We\'re here to help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(height: 4),
                            Text('Reach out to us anytime — online, by phone, or visit a branch near you.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                  height: 1.5,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Quick contact chips ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: _QuickContactChip(
                        icon: Icons.email_outlined,
                        label: 'Email Us',
                        value: 'info@freshbasket.com.pk',
                        onTap: () async {
                          final uri = Uri.parse('mailto:info@freshbasket.com.pk');
                          if (await canLaunchUrl(uri)) launchUrl(uri);
                        },
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _QuickContactChip(
                        icon: Icons.phone_outlined,
                        label: 'Call Us',
                        value: '+92 300 0000000',
                        onTap: () async {
                          final uri = Uri.parse('tel:+923000000000');
                          if (await canLaunchUrl(uri)) launchUrl(uri);
                        },
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Branch locations ─────────────────────────────────────
                _SectionHeader(title: 'Our Branches', icon: Icons.location_on_rounded),
                const SizedBox(height: 12),

                _BranchCard(
                  name: 'Badar Branch',
                  address: 'Main 26th Street, off Badar Commercial,\nPhase V DHA, Karachi',
                  onDirections: () => _openMap('Main 26th Street Badar Commercial Phase V DHA Karachi'),
                ),
                _BranchCard(
                  name: 'Clifton Branch',
                  address: 'Dean Arcade, Schön Circle,\nBlock 8 Clifton, Karachi, 75500',
                  onDirections: () => _openMap('Dean Arcade Schon Circle Block 8 Clifton Karachi'),
                ),
                _BranchCard(
                  name: 'DHA Phase 1 Branch',
                  address: 'Centre Point Building,\nMain Korangi Road, DHA Phase 1, Karachi',
                  onDirections: () => _openMap('Centre Point Building Main Korangi Road DHA Phase 1 Karachi'),
                ),

                const SizedBox(height: 24),

                // ── K-Town value section ─────────────────────────────────
                const _KTownSection(),

                const SizedBox(height: 24),

                // ── Message form ─────────────────────────────────────────
                _SectionHeader(title: 'Send a Message', icon: Icons.send_rounded),
                const SizedBox(height: 12),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _FormField(
                        controller: _nameCtrl,
                        icon: Icons.person_outline,
                        hint: 'Your name',
                      ),
                      const SizedBox(height: 12),
                      _FormField(
                        controller: _emailCtrl,
                        icon: Icons.email_outlined,
                        hint: 'Email address (optional)',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _messageCtrl,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 14.5),
                        decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding: const EdgeInsets.all(14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _orange, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _sending ? null : _sendMessage,
                          icon: _sending
                              ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.send_rounded, size: 18),
                          label: Text(_sending ? 'Sending...' : 'Send Message',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40), // Increased bottom spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE07B39).withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: const Color(0xFFE07B39), size: 17),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick contact chip
// ─────────────────────────────────────────────────────────────────────────────
class _QuickContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _QuickContactChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE07B39).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFE07B39), size: 22),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                )),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA)),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Branch card — styled like the reference images
// ─────────────────────────────────────────────────────────────────────────────
class _BranchCard extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback onDirections;

  const _BranchCard({
    required this.name,
    required this.address,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pin icon with orange ring glow
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE07B39).withOpacity(0.08),
              border: Border.all(
                color: const Color(0xFFE07B39).withOpacity(0.25),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFFE07B39),
              size: 32,
            ),
          ),
          const SizedBox(height: 14),

          Text(name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.2,
              )),
          const SizedBox(height: 8),

          Text(address,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF777777),
                height: 1.55,
              )),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: onDirections,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE07B39).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFE07B39).withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.directions_rounded,
                      color: Color(0xFFE07B39), size: 16),
                  SizedBox(width: 6),
                  Text('GET DIRECTIONS',
                      style: TextStyle(
                        color: Color(0xFFE07B39),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        letterSpacing: 0.8,
                      )),
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
// K-Town value proposition section
// ─────────────────────────────────────────────────────────────────────────────
class _KTownSection extends StatelessWidget {
  const _KTownSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF7EC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07B39).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Since 2019 · Karachi',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE07B39),
                        letterSpacing: 0.8,
                      )),
                ),
                const SizedBox(height: 12),
                const Text(
                  'We always provide\nyou the best in K-Town',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D3B2E),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fresh groceries, fast delivery, and unbeatable service — right at your doorstep.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5A7A6A),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Feature blocks — 2 × 2 grid inside dark rounded cards
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _FeatureBlock(
                      icon: Icons.star_rounded,
                      label: 'Loyalty Rewards',
                      desc: 'Earn points on every order',
                      iconBg: const Color(0xFFE07B39),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _FeatureBlock(
                      icon: Icons.credit_card_rounded,
                      label: 'Multiple Payment Options',
                      desc: 'COD, EasyPaisa, JazzCash',
                      iconBg: const Color(0xFF0D3B2E),
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _FeatureBlock(
                      icon: Icons.local_shipping_rounded,
                      label: 'Express Delivery',
                      desc: 'Same-day delivery available',
                      iconBg: const Color(0xFF2E7D32),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _FeatureBlock(
                      icon: Icons.verified_rounded,
                      label: 'Freshness Guaranteed',
                      desc: 'Quality checked every day',
                      iconBg: const Color(0xFFE07B39),
                    )),
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

class _FeatureBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color iconBg;

  const _FeatureBlock({
    required this.icon,
    required this.label,
    required this.desc,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3B2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: iconBg.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBg == const Color(0xFF0D3B2E)
                ? const Color(0xFFE07B39) : Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          Text(label,
              style: const TextStyle(
                color: Color(0xFFE07B39),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                height: 1.3,
              )),
          const SizedBox(height: 4),
          Text(desc,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                height: 1.4,
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable form field
// ─────────────────────────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final TextInputType keyboardType;

  const _FormField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 20),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE07B39), width: 1.5),
        ),
      ),
    );
  }
}