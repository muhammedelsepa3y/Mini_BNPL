import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImageWidget extends StatelessWidget {
  final String imageUrl;

  const ProductImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
