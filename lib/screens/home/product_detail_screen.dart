import 'package:flutter/material.dart';
import '../../models/menu_item_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItem = ModalRoute.of(context)?.settings.arguments as MenuItem?;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Text(
          menuItem != null
              ? 'Product: ${menuItem.name}'
              : 'Product Detail Screen',
        ),
      ),
    );
  }
}
