// lib/models/delivery_address_model.dart

class DeliveryAddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String area;
  final String instructions;
  final bool isDefault;

  DeliveryAddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.area,
    required this.instructions,
    required this.isDefault,
  });

  factory DeliveryAddressModel.fromMap(
      String id, Map<String, dynamic> data) {
    return DeliveryAddressModel(
      id: id,
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      city: data['city'] ?? '',
      area: data['area'] ?? '',
      instructions: data['instructions'] ?? '',
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'phone': phone,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'area': area,
    'instructions': instructions,
    'isDefault': isDefault,
  };
}