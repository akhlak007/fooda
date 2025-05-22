import 'package:flutter/material.dart';
import '../models/order_model.dart' as order_model;
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocationService _locationService = LocationService();

  List<order_model.Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<order_model.Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<GeoPoint?>? liveTrackingStream;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _firestoreService.getUserOrders().listen((orderList) {
        _orders = orderList;
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> placeOrder(order_model.Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _firestoreService.createOrder(order);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void listenToLiveTracking(String orderId) {
    liveTrackingStream = _locationService.listenToAgentLocation(orderId);
    notifyListeners();
  }
}
