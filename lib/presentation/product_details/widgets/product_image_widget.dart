import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    required this.imageUrl,
    required this.productName,
    super.key,
  });

  final String imageUrl;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Full size image of $productName',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 250.h,
            width: double.infinity,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => Icon(
              Icons.image_not_supported,
              size: 100.h,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
