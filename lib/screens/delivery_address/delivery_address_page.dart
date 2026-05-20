// lib/screens/delivery_address/delivery_address_page.dart
// ── FULL FILE — place at lib/screens/delivery_address/delivery_address_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/models/delivery_address_model.dart';
import 'package:grocery_app/models/cart_item_model.dart';
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/screens/order_confirmation/order_confirmation_page.dart';

// ═══════════════════════════════════════════════════════════════════════════
// DELIVERY ADDRESS PAGE
// ═══════════════════════════════════════════════════════════════════════════
class DeliveryAddressPage extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final double totalPrice;

  const DeliveryAddressPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage>
    with TickerProviderStateMixin {
  final FirestoreService _service = FirestoreService();

  // Selected address from saved list
  DeliveryAddressModel? _selectedAddress;

  // Payment method
  String _paymentMethod = 'Cash on Delivery';

  bool _isPlacingOrder = false;
  bool _showNewAddressForm = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      _showSnack('Please select or add a delivery address', isError: true);
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final orderId = await _service.placeOrder(
        deliveryAddress: _selectedAddress!,
        paymentMethod: _paymentMethod,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationPage(
            orderId: orderId,
            totalPrice: widget.totalPrice,
            itemCount: widget.cartItems
                .fold<int>(0, (sum, i) => sum + i.quantity),
            deliveryAddress: _selectedAddress!,
            paymentMethod: _paymentMethod,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to place order: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openAddressForm({DeliveryAddressModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(
        existing: existing,
        onSaved: (address) async {
          final id = await _service.saveAddress(address);
          // Refresh and auto-select
          final saved = DeliveryAddressModel(
            id: id,
            fullName: address.fullName,
            phone: address.phone,
            addressLine1: address.addressLine1,
            addressLine2: address.addressLine2,
            city: address.city,
            area: address.area,
            instructions: address.instructions,
            isDefault: address.isDefault,
          );
          if (mounted) setState(() => _selectedAddress = saved);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffe07b39),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Delivery Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        // Step indicator in subtitle
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Container(
            color: const Color(0xffe07b39),
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepDot(label: 'Cart', done: true),
                _stepLine(done: true),
                _stepDot(label: 'Address', active: true),
                _stepLine(),
                _stepDot(label: 'Confirm'),
              ],
            ),
          ),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order summary card ──────────────────────────────
                    _OrderSummaryCard(
                      items: widget.cartItems,
                      totalPrice: widget.totalPrice,
                    ),
                    const SizedBox(height: 20),

                    // ── Saved Addresses ─────────────────────────────────
                    _SectionHeader(
                      icon: Icons.location_on_rounded,
                      title: 'Delivery Address',
                      trailing: TextButton.icon(
                        onPressed: () => _openAddressForm(),
                        icon: const Icon(Icons.add, size: 16,
                            color: Color(0xffe07b39)),
                        label: const Text(
                          'Add New',
                          style: TextStyle(
                              color: Color(0xffe07b39),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    StreamBuilder<List<DeliveryAddressModel>>(
                      stream: _service.getAddresses(),
                      builder: (context, snap) {
                        final addresses = snap.data ?? [];

                        // Auto-select default on first load
                        if (_selectedAddress == null &&
                            addresses.isNotEmpty) {
                          final def = addresses.where(
                                  (a) => a.isDefault);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => _selectedAddress =
                              def.isNotEmpty
                                  ? def.first
                                  : addresses.first);
                            }
                          });
                        }

                        if (addresses.isEmpty) {
                          return _EmptyAddressCard(
                            onAdd: () => _openAddressForm(),
                          );
                        }

                        return Column(
                          children: addresses.map((addr) {
                            final isSelected =
                                _selectedAddress?.id == addr.id;
                            return _AddressCard(
                              address: addr,
                              isSelected: isSelected,
                              onTap: () =>
                                  setState(() => _selectedAddress = addr),
                              onEdit: () =>
                                  _openAddressForm(existing: addr),
                              onDelete: () async {
                                await _service.deleteAddress(addr.id);
                                if (_selectedAddress?.id == addr.id) {
                                  setState(() => _selectedAddress = null);
                                }
                              },
                              onSetDefault: () =>
                                  _service.setDefaultAddress(addr.id),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Payment Method ──────────────────────────────────
                    _SectionHeader(
                      icon: Icons.payment_rounded,
                      title: 'Payment Method',
                    ),
                    const SizedBox(height: 10),
                    _PaymentSelector(
                      selected: _paymentMethod,
                      onChanged: (val) =>
                          setState(() => _paymentMethod = val),
                    ),

                    const SizedBox(height: 20),

                    // ── Delivery Info ───────────────────────────────────
                    _DeliveryInfoCard(),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // ── Sticky Bottom Bar ───────────────────────────────────────
            _BottomCheckoutBar(
              totalPrice: widget.totalPrice,
              itemCount: widget.cartItems
                  .fold<int>(0, (sum, i) => sum + i.quantity),
              isLoading: _isPlacingOrder,
              isAddressSelected: _selectedAddress != null,
              onPlaceOrder: _placeOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepDot({
    String label = '',
    bool done = false,
    bool active = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: done
                ? Colors.white
                : active
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check,
                size: 13, color: Color(0xffe07b39))
                : active
                ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xffe07b39),
                shape: BoxShape.circle,
              ),
            )
                : Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: done || active
                ? Colors.white
                : Colors.white.withOpacity(0.6),
            fontSize: 10,
            fontWeight:
            active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine({bool done = false}) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: done
            ? Colors.white
            : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xffe07b39).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xffe07b39), size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ORDER SUMMARY CARD
// ═══════════════════════════════════════════════════════════════════════════
class _OrderSummaryCard extends StatefulWidget {
  final List<CartItemModel> items;
  final double totalPrice;

  const _OrderSummaryCard({
    required this.items,
    required this.totalPrice,
  });

  @override
  State<_OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<_OrderSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final totalQty =
    widget.items.fold<int>(0, (s, i) => s + i.quantity);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffe07b39).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.receipt_long_outlined,
                        color: Color(0xffe07b39), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$totalQty ${totalQty == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Rs ${widget.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xffe07b39),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded items list
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xffF0F0F0)),
            ...widget.items.map((item) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 44,
                        height: 44,
                        color: Colors.grey[100],
                        child: const Icon(Icons.image,
                            color: Colors.grey, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item.weight,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        'Rs ${(item.price * item.quantity).toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
            const Divider(height: 1, color: Color(0xffF0F0F0)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    'Rs ${widget.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xffe07b39),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ADDRESS CARD
// ═══════════════════════════════════════════════════════════════════════════
class _AddressCard extends StatelessWidget {
  final DeliveryAddressModel address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xffe07b39)
                : const Color(0xffEEEEEE),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xffe07b39).withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xffe07b39)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xffe07b39),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 12),

              // Address details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xffe07b39)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xffe07b39),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      address.phone,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      [
                        address.addressLine1,
                        if (address.addressLine2.isNotEmpty)
                          address.addressLine2,
                        address.area,
                        address.city,
                      ].join(', '),
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54, height: 1.4),
                    ),
                    if (address.instructions.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address.instructions,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    // Action row
                    Row(
                      children: [
                        _ActionChip(
                          label: 'Edit',
                          icon: Icons.edit_outlined,
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 8),
                        if (!address.isDefault)
                          _ActionChip(
                            label: 'Set Default',
                            icon: Icons.star_border,
                            onTap: onSetDefault,
                          ),
                        if (!address.isDefault)
                          const SizedBox(width: 8),
                        _ActionChip(
                          label: 'Delete',
                          icon: Icons.delete_outline,
                          onTap: onDelete,
                          isDestructive: true,
                        ),
                      ],
                    ),
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

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red.shade400
        : const Color(0xffe07b39);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY ADDRESS CARD
// ═══════════════════════════════════════════════════════════════════════════
class _EmptyAddressCard extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAddressCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xffe07b39).withOpacity(0.3),
              width: 1.5,
              style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffe07b39).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_location_alt_outlined,
                color: Color(0xffe07b39),
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No saved addresses',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to add your delivery address',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAYMENT SELECTOR
// ═══════════════════════════════════════════════════════════════════════════
class _PaymentSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PaymentSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const methods = [
      {'id': 'Cash on Delivery', 'label': 'Cash on Delivery', 'icon': '💵'},
      {'id': 'EasyPaisa', 'label': 'EasyPaisa', 'icon': '📱'},
      {'id': 'JazzCash', 'label': 'JazzCash', 'icon': '📲'},
    ];

    return Column(
      children: methods
          .map((m) => _PaymentTile(
        id: m['id']!,
        label: m['label']!,
        emoji: m['icon']!,
        isSelected: selected == m['id'],
        onTap: () => onChanged(m['id']!),
      ))
          .toList(),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String id;
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.id,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xffe07b39)
                : const Color(0xffEEEEEE),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xffe07b39).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: 14,
                  color: isSelected
                      ? const Color(0xffe07b39)
                      : Colors.black87,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xffe07b39)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xffe07b39),
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DELIVERY INFO CARD
// ═══════════════════════════════════════════════════════════════════════════
class _DeliveryInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xffe07b39).withOpacity(0.08),
            const Color(0xffe07b39).withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffe07b39).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined,
                  color: Color(0xffe07b39), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Delivery Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Estimated Delivery',
            value: 'Within 2 hours',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.delivery_dining_rounded,
            label: 'Delivery Fee',
            value: 'FREE',
            valueColor: Colors.green,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.verified_rounded,
            label: 'Quality Guarantee',
            value: '100% Fresh',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM CHECKOUT BAR
// ═══════════════════════════════════════════════════════════════════════════
class _BottomCheckoutBar extends StatelessWidget {
  final double totalPrice;
  final int itemCount;
  final bool isLoading;
  final bool isAddressSelected;
  final VoidCallback onPlaceOrder;

  const _BottomCheckoutBar({
    required this.totalPrice,
    required this.itemCount,
    required this.isLoading,
    required this.isAddressSelected,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Rs ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe07b39),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 52,
                width: 200,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAddressSelected
                        ? const Color(0xffe07b39)
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    elevation: isAddressSelected ? 4 : 0,
                    shadowColor:
                    const Color(0xffe07b39).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 18),
                      const SizedBox(width: 6),
                      Text(
                        isAddressSelected
                            ? 'Place Order'
                            : 'Select Address',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
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

// ═══════════════════════════════════════════════════════════════════════════
// ADDRESS FORM SHEET
// ═══════════════════════════════════════════════════════════════════════════
class _AddressFormSheet extends StatefulWidget {
  final DeliveryAddressModel? existing;
  final Future<void> Function(DeliveryAddressModel) onSaved;

  const _AddressFormSheet({
    this.existing,
    required this.onSaved,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _address1Ctrl;
  late TextEditingController _address2Ctrl;
  late TextEditingController _areaCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _instructionsCtrl;

  bool _isDefault = false;
  bool _isSaving = false;

  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Gujranwala',
    'Sialkot',
    'Peshawar',
    'Kharian',
    'Other',
  ];

  String _selectedCity = 'Lahore';

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: e?.phone ?? '');
    _address1Ctrl = TextEditingController(text: e?.addressLine1 ?? '');
    _address2Ctrl = TextEditingController(text: e?.addressLine2 ?? '');
    _areaCtrl = TextEditingController(text: e?.area ?? '');
    _instructionsCtrl =
        TextEditingController(text: e?.instructions ?? '');
    _isDefault = e?.isDefault ?? false;

    if (e != null && _cities.contains(e.city)) {
      _selectedCity = e.city;
    } else if (e != null) {
      _selectedCity = 'Other';
      _cityCtrl = TextEditingController(text: e.city);
    } else {
      _cityCtrl = TextEditingController();
    }
    _cityCtrl = TextEditingController(
        text: e != null && !_cities.contains(e.city) ? e.city : '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _address1Ctrl.dispose();
    _address2Ctrl.dispose();
    _areaCtrl.dispose();
    _cityCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      final city = _selectedCity == 'Other'
          ? _cityCtrl.text.trim()
          : _selectedCity;

      final address = DeliveryAddressModel(
        id: widget.existing?.id ?? '',
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        addressLine1: _address1Ctrl.text.trim(),
        addressLine2: _address2Ctrl.text.trim(),
        city: city,
        area: _areaCtrl.text.trim(),
        instructions: _instructionsCtrl.text.trim(),
        isDefault: _isDefault,
      );

      await widget.onSaved(address);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.97,
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
              // Handle
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffe07b39).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_outlined,
                          color: Color(0xffe07b39), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.existing == null
                          ? 'Add New Address'
                          : 'Edit Address',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Personal Info ─────────────────────────────
                        _FormSectionLabel('Personal Information'),
                        const SizedBox(height: 10),
                        _buildField(
                          controller: _nameCtrl,
                          label: 'Full Name',
                          hint: 'e.g. Ahmed Ali',
                          icon: Icons.person_outline,
                          validator: (v) => (v?.trim().isEmpty ?? true)
                              ? 'Name is required'
                              : null,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _phoneCtrl,
                          label: 'Phone Number',
                          hint: 'e.g. 0300-1234567',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return 'Phone is required';
                            if (t.length < 10) return 'Enter valid phone';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // ── Address Info ──────────────────────────────
                        _FormSectionLabel('Address Details'),
                        const SizedBox(height: 10),
                        _buildField(
                          controller: _address1Ctrl,
                          label: 'House / Flat / Street',
                          hint: 'e.g. House 12, Street 3',
                          icon: Icons.home_outlined,
                          validator: (v) => (v?.trim().isEmpty ?? true)
                              ? 'Address is required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _address2Ctrl,
                          label: 'Block / Sector (Optional)',
                          hint: 'e.g. Block A, DHA Phase 5',
                          icon: Icons.location_city_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _areaCtrl,
                          label: 'Area / Colony',
                          hint: 'e.g. Gulshan-e-Iqbal',
                          icon: Icons.map_outlined,
                          validator: (v) => (v?.trim().isEmpty ?? true)
                              ? 'Area is required'
                              : null,
                        ),
                        const SizedBox(height: 12),

                        // City dropdown
                        _FieldLabel('City'),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFDDDDDD)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCity,
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              borderRadius: BorderRadius.circular(12),
                              items: _cities
                                  .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCity = v);
                                }
                              },
                            ),
                          ),
                        ),

                        if (_selectedCity == 'Other') ...[
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _cityCtrl,
                            label: 'City Name',
                            hint: 'Enter your city',
                            icon: Icons.location_on_outlined,
                            validator: (v) =>
                            (v?.trim().isEmpty ?? true)
                                ? 'City is required'
                                : null,
                          ),
                        ],

                        const SizedBox(height: 20),

                        // ── Delivery Instructions ─────────────────────
                        _FormSectionLabel('Delivery Instructions'),
                        const SizedBox(height: 10),
                        _buildField(
                          controller: _instructionsCtrl,
                          label: 'Special Instructions (Optional)',
                          hint:
                          'e.g. Ring bell twice, leave at gate...',
                          icon: Icons.notes_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 16),

                        // Default address toggle
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xffe07b39)
                                .withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xffe07b39)
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_outline,
                                  color: Color(0xffe07b39), size: 20),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Set as Default Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Auto-selected for future orders',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isDefault,
                                activeColor: const Color(0xffe07b39),
                                onChanged: (v) =>
                                    setState(() => _isDefault = v),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Save button — pinned
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe07b39),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                      shadowColor:
                      const Color(0xffe07b39).withOpacity(0.4),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                        : const Text(
                      'Save Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            prefixIcon:
            Icon(icon, color: const Color(0xFF888888), size: 20),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xffe07b39), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormSectionLabel extends StatelessWidget {
  final String text;
  const _FormSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xffe07b39),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }
}