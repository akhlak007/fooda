import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String phone;
  final String address;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.phone,
    required this.address,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'address': address,
      'isAdmin': isAdmin,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phone,
    String? address,
    bool? isAdmin,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
