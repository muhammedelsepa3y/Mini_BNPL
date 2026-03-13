import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  final String id;

  const OrderDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Order Details'),
      ),
    );
  }
}
