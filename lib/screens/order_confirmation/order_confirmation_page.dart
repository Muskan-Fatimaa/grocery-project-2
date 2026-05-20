import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:grocery_app/models/delivery_address_model.dart';
import 'package:grocery_app/screens/home/home_screen.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String orderId;
  final double totalPrice;
  final int itemCount;
  final DeliveryAddressModel deliveryAddress;
  final String paymentMethod;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.itemCount,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  @override
  State<OrderConfirmationPage> createState() =>
      _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _confettiController;

  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _confettiAnim;

  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Generate confetti particles
    final rng = math.Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(_ConfettiParticle(
        x: rng.nextDouble(),
        delay: rng.nextDouble() * 0.5,
        speed: 0.4 + rng.nextDouble() * 0.6,
        size: 6 + rng.nextDouble() * 8,
        color: [
          const Color(0xffe07b39),
          Colors.green,
          Colors.amber,
          Colors.blue,
          Colors.pink,
        ][rng.nextInt(5)],
        rotation: rng.nextDouble() * math.pi * 2,
      ));
    }

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _confettiAnim = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    );

    // Sequence: confetti → scale → fade
    _confettiController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String get _shortOrderId {
    final s = widget.orderId;
    return s.length > 8 ? 'GRO-${s.substring(0, 6).toUpperCase()}' : s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Stack(
        children: [
          // ── Confetti ─────────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _confettiAnim,
            builder: (context, _) {
              return CustomPaint(
                painter: _ConfettiPainter(
                  progress: _confettiAnim.value,
                  particles: _particles,
                ),
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.5,
                ),
              );
            },
          ),

          // ── Main Content ─────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Column(
                children: [
                  // Success icon with pulse
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.green.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 64,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        const Text(
                          'Order Placed! 🎉',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your order has been confirmed and\nwill be delivered soon!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Order number badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xffe07b39)
                                .withOpacity(0.1),
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xffe07b39)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Order ID: $_shortOrderId',
                            style: const TextStyle(
                              color: Color(0xffe07b39),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Order Details Card ──────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.07),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Card header
                              Container(
                                padding:
                                const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xffe07b39),
                                  borderRadius:
                                  BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.receipt_long_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Order Summary',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Summary rows
                              _SummaryRow(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Items',
                                value:
                                '${widget.itemCount} ${widget.itemCount == 1 ? 'item' : 'items'}',
                              ),
                              _SummaryRow(
                                icon: Icons.currency_rupee,
                                label: 'Total Amount',
                                value:
                                'Rs ${widget.totalPrice.toStringAsFixed(0)}',
                                valueColor:
                                const Color(0xffe07b39),
                                isBold: true,
                              ),
                              _SummaryRow(
                                icon: Icons.payment_rounded,
                                label: 'Payment',
                                value: widget.paymentMethod,
                              ),
                              _SummaryRow(
                                icon: Icons.local_shipping_outlined,
                                label: 'Delivery Fee',
                                value: 'FREE',
                                valueColor: Colors.green,
                              ),
                              _SummaryRow(
                                icon: Icons.access_time_rounded,
                                label: 'Est. Delivery',
                                value: 'Within 2 hours',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Delivery Address Card ───────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green
                                      .withOpacity(0.08),
                                  borderRadius:
                                  const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.green
                                            .withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons
                                            .location_on_rounded,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Delivery Address',
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.deliveryAddress
                                          .fullName,
                                      style: const TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.deliveryAddress
                                          .phone,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      [
                                        widget.deliveryAddress
                                            .addressLine1,
                                        if (widget.deliveryAddress
                                            .addressLine2
                                            .isNotEmpty)
                                          widget.deliveryAddress
                                              .addressLine2,
                                        widget.deliveryAddress
                                            .area,
                                        widget.deliveryAddress
                                            .city,
                                      ].join(', '),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Order Status Widget (Simplified) ─────────────────────────────
                        const OrderStatusCard(),

                        const SizedBox(height: 32),

                        // ── Buttons ─────────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const HomeScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                            icon: const Icon(Icons.home_rounded,
                                size: 20),
                            label: const Text(
                              'Continue Shopping',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xffe07b39),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor:
                              const Color(0xffe07b39)
                                  .withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Order Status Widget (Simplified - Single Status View)
// ─────────────────────────────────────────────────────────────────────────────
class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),

          // Status Row - Order Confirmed
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade50,
                  Colors.green.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Animated-style glowing green circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.30),
                        blurRadius: 14,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Confirmed! ✓',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your order has been placed successfully',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Estimated Delivery Section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FBF0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB2DFBD)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    size: 20,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Within 2 hours',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.green.shade400,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notification Info
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 16,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'ll receive real-time updates on your order status via notifications',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Summary Row ────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final bool isLast;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isBold ? 15 : 13,
                  fontWeight: isBold
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xffF0F0F0)),
      ],
    );
  }
}

// ── Confetti ────────────────────────────────────────────────────────────────
class _ConfettiParticle {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double rotation;

  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = p.x * size.width;
      final y = t * p.speed * size.height;
      final rot = p.rotation + t * math.pi * 3;

      final paint = Paint()..color = p.color.withOpacity(1 - t * 0.5);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.5),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}