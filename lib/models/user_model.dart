class AppUser {
  final String uid;
  final String name;
  final String email;
  final String address;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
    };
  }
}
