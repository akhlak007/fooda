import 'package:flutter/material.dart';
import '../../models/menu_item_model.dart';
import '../../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItem = ModalRoute.of(context)?.settings.arguments as MenuItem?;
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (menuItem == null) {
      return const Scaffold(
        body: Center(child: Text('No product found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(menuItem.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              menuItem.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.fastfood, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(menuItem.description,
                style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('৳${menuItem.price}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                cart.addItem(menuItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${menuItem.name} added to cart!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Order Now'),
            ),
          ),
        ],
      ),
    );
  }
}
