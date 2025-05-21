import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/menu_item_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart' as order_model;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User
  Future<void> setUser(AppUser user) async {
    await _db.collection('user').doc(user.uid).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('user').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!..['uid'] = doc.id);
    }
    return null;
  }

  // Menu Items
  Stream<List<MenuItem>> getMenuItems() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Categories
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Category.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Orders
  Stream<List<order_model.Order>> getOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => order_model.Order.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addOrder(order_model.Order order) async {
    await _db.collection('orders').add(order.toMap());
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    await _db.collection('orders').doc(orderId).update(data);
  }
}
