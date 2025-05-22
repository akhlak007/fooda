import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/menu_item_model.dart';
import '../routes/app_routes.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.adminProductForm),
          ),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: firestore.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return ListTile(
                leading: Image.network(p.imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(p.name),
                subtitle: Text('৳${p.price} • ${p.category}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.adminProductForm,
                          arguments: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => firestore.deleteProduct(p.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
