import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final String address;
  final DateTime orderDate;
  final List<Map<String, dynamic>> products;
  final String status;
  final double totalPrice;
  final GeoPoint? deliveryLocation;

  Order({
    required this.id,
    required this.userId,
    required this.address,
    required this.orderDate,
    required this.products,
    required this.status,
    required this.totalPrice,
    this.deliveryLocation,
  });

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
      status: map['status'] ?? '',
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      deliveryLocation: map['deliveryLocation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'orderDate': Timestamp.fromDate(orderDate),
      'products': products,
      'status': status,
      'totalPrice': totalPrice,
      'deliveryLocation': deliveryLocation,
    };
  }
} 