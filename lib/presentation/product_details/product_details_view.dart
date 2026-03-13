import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final String id;

  const ProductDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Product Details View for ID: $id'),
      ),
    );
  }
}
