import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/menu_item_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../models/order_model.dart' as order_model;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Menu Items
  Stream<List<MenuItem>> getMenuItems() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Categories
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Users
  Future<AppUser?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Future<void> updateUser(AppUser user) async {
    await _db.collection('users').doc(user.id).update(user.toMap());
  }

  // Orders
  Stream<List<order_model.Order>> getUserOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => order_model.Order.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> createOrder(order_model.Order order) async {
    await _db.collection('orders').doc(order.id).set(order.toMap());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
  }

  // Admin Methods
  Stream<List<MenuItem>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addProduct(MenuItem item) async {
    await _db.collection('products').doc(item.id).set(item.toMap());
  }

  Future<void> updateProduct(MenuItem item) async {
    await _db.collection('products').doc(item.id).update(item.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  Stream<List<AppUser>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AppUser.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
