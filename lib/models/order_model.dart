// lib/models/order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/cart_item_model.dart';
import 'package:grocery_app/models/delivery_address_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double total;
  final String status;
  final DateTime placedAt;
  final DeliveryAddressModel? deliveryAddress;
  final String paymentMethod;
  final String orderNumber;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
    this.deliveryAddress,
    required this.paymentMethod,
    required this.orderNumber,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    final itemsList = (data['items'] as List<dynamic>? ?? [])
        .map((item) => CartItemModel.fromMap('', item as Map<String, dynamic>))
        .toList();

    DeliveryAddressModel? address;
    if (data['deliveryAddress'] != null) {
      address = DeliveryAddressModel.fromMap(
          '', data['deliveryAddress'] as Map<String, dynamic>);
    }

    return OrderModel(
      id: id,
      items: itemsList,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'placed',
      placedAt: data['placedAt'] is Timestamp
          ? (data['placedAt'] as Timestamp).toDate()
          : DateTime.now(),
      deliveryAddress: address,
      paymentMethod: data['paymentMethod'] ?? 'Cash on Delivery',
      orderNumber: data['orderNumber'] ?? id.substring(0, 8).toUpperCase(),
    );
  }
}