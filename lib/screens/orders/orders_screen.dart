import 'package:flutter/material.dart';
import '../../models/order_model.dart' as order_model;
import '../../services/firestore_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: StreamBuilder<List<order_model.Order>>(
        stream: _firestoreService.getUserOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order.status}'),
                      Text('Total: ৳${order.total}'),
                      Text('Date: ${order.createdAt.toLocal().toString()}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order-status',
                      arguments: order,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
