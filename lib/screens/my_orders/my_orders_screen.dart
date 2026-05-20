
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Save as: lib/screens/my_orders/my_orders_screen.dart

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xffe07b39),
      body: Column(
        children: [
          // ── Orange AppBar ────────────────────────────────────────────────
          Container(
            color: const Color(0xffe07b39),
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
                      'My Orders',
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

          // ── Orders list ──────────────────────────────────────────────────
          Expanded(
            child: uid == null
                ? const Center(child: Text('Please log in to view orders.'))
                : StreamBuilder<QuerySnapshot>(
              // No orderBy to avoid Firestore index requirement.
              // Sorted client-side below.
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('orders')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFE8631A)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading orders.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const _EmptyOrders();
                }

                // Sort client-side by createdAt descending
                final sorted = [...docs];
                sorted.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTs = aData['createdAt'];
                  final bTs = bData['createdAt'];
                  if (aTs == null && bTs == null) return 0;
                  if (aTs == null) return 1;
                  if (bTs == null) return -1;
                  final aDate = (aTs as Timestamp).toDate();
                  final bDate = (bTs as Timestamp).toDate();
                  return bDate.compareTo(aDate);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (ctx, i) {
                    final data =
                    sorted[i].data() as Map<String, dynamic>;
                    return _OrderCard(data: data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order Card — reads every possible field name variant
// ─────────────────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _OrderCard({required this.data});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return Colors.red;
      case 'processing':
      case 'being packed':
        return const Color(0xFFFF9800);
      case 'shipped':
      case 'out for delivery':
        return const Color(0xFF42A5F5);
      default:
        return const Color(0xFFE8631A);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'processing':
      case 'being packed':
        return Icons.inventory_2_rounded;
      case 'shipped':
      case 'out for delivery':
        return Icons.local_shipping_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read all possible field name variants
    final orderId = (data['orderId'] ??
        data['orderNumber'] ??
        data['id'] ??
        'Order')
        .toString();

    final status = (data['status'] ?? 'Order Confirmed').toString();

    // Total — try multiple field names, else compute from items
    double total = 0.0;
    if (data['totalAmount'] != null) {
      total = (data['totalAmount'] as num).toDouble();
    } else if (data['totalPrice'] != null) {
      total = (data['totalPrice'] as num).toDouble();
    } else if (data['items'] is List) {
      for (final item in (data['items'] as List)) {
        if (item is Map) {
          final price = (item['price'] as num?)?.toDouble() ?? 0.0;
          final qty   = (item['quantity'] as num?)?.toInt() ?? 1;
          total += price * qty;
        }
      }
    }

    final items     = data['items'] as List?;
    final itemCount = items?.length ?? 0;

    final Timestamp? ts = data['createdAt'] as Timestamp?;
    final dateStr = ts != null ? _formatDate(ts.toDate()) : '—';

    // Address — nested map OR flat root fields
    String addrSnippet = '';
    final addr = data['deliveryAddress'] as Map<String, dynamic>?;
    if (addr != null) {
      final area = (addr['area'] ?? addr['block'] ?? '').toString();
      final city = (addr['city'] ?? '').toString();
      addrSnippet =
          [area, city].where((s) => s.isNotEmpty).join(', ');
    } else {
      final area = (data['area'] ?? '').toString();
      final city = (data['city'] ?? '').toString();
      addrSnippet =
          [area, city].where((s) => s.isNotEmpty).join(', ');
    }

    final payment =
    (data['paymentMethod'] ?? data['payment'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_statusIcon(status),
                      color: _statusColor(status), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderId,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          )),
                      const SizedBox(height: 2),
                      Text(dateStr,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFFAAAAAA))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF2F2F2)),

          // ── Item preview ────────────────────────────────────────────────
          if (items != null && items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: items.take(3).map<Widget>((item) {
                  if (item is! Map) return const SizedBox.shrink();
                  final name  = (item['name'] ?? '').toString();
                  final qty   = (item['quantity'] as num?)?.toInt() ?? 1;
                  final price =
                      (item['price'] as num?)?.toDouble() ?? 0.0;
                  final img = item['imageUrl'] as String?;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        if (img != null && img.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              img,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _PlaceholderBox(),
                            ),
                          )
                        else
                          _PlaceholderBox(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text('x$qty',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFAAAAAA))),
                        const SizedBox(width: 8),
                        Text(
                          'Rs. ${(price * qty).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          if (items != null && items.length > 3)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
              child: Text(
                '+${items.length - 3} more item${items.length - 3 > 1 ? 's' : ''}',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFFE8631A)),
              ),
            ),

          const Divider(height: 1, color: Color(0xFFF2F2F2)),

          // ── Footer ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: [
                if (addrSnippet.isNotEmpty) ...[
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: Color(0xFFAAAAAA)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      addrSnippet,
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF666666)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else if (payment.isNotEmpty) ...[
                  const Icon(Icons.payment_rounded,
                      size: 14, color: Color(0xFFAAAAAA)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(payment,
                        style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF666666))),
                  ),
                ] else
                  Expanded(
                    child: Text(
                      '$itemCount item${itemCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF666666)),
                    ),
                  ),
                Text(
                  'Rs. ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFFE8631A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour   = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm   = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $hour:$minute $ampm';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder image box
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceholderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_outlined,
          size: 18, color: Color(0xFFCCCCCC)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

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
              color: const Color(0xFFFFF3ED),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 44, color: Color(0xFFE8631A)),
          ),
          const SizedBox(height: 20),
          const Text('No orders yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              )),
          const SizedBox(height: 8),
          const Text(
            'Your placed orders will appear here.',
            style: TextStyle(fontSize: 13.5, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }
}