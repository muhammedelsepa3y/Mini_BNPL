import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.installments,
    super.key,
  });

  final Product product;
  final List<AvailablePlanModel> installments;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Product: ${product.name}',
      button: true,
      onTapHint: 'View product details',
      child: GestureDetector(
        onTap: () {
          context.goNamed(
            AppRouteConst.productDetailsName,
            pathParameters: {'id': product.id.toString()},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported,
                      size: 50.h,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      semanticsLabel:
                          '${product.price.toStringAsFixed(2)} dollars',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
