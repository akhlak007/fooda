import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item_model.dart';
import '../services/firestore_service.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _category, _description, _imageUrl;
  double? _price;
  bool _available = true;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as MenuItem?;
    final firestore = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar:
          AppBar(title: Text(product == null ? 'Add Product' : 'Edit Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: product?.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v,
              ),
              TextFormField(
                initialValue: product?.price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                onSaved: (v) => _price = double.tryParse(v ?? ''),
              ),
              TextFormField(
                initialValue: product?.category,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter category' : null,
                onSaved: (v) => _category = v,
              ),
              TextFormField(
                initialValue: product?.description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
                onSaved: (v) => _description = v,
              ),
              TextFormField(
                initialValue: product?.imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (v) => _imageUrl = v,
              ),
              SwitchListTile(
                value: product?.isAvailable ?? _available,
                onChanged: (v) => setState(() => _available = v),
                title: const Text('Available'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newProduct = MenuItem(
                      id: product?.id ?? '',
                      name: _name!,
                      price: _price!,
                      imageUrl: _imageUrl ?? '',
                      category: _category!,
                      description: _description ?? '',
                      isAvailable: _available,
                    );
                    if (product == null) {
                      await firestore.addProduct(newProduct);
                    } else {
                      await firestore.updateProduct(newProduct);
                    }
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: Text(product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
