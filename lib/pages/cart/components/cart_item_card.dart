import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_color.dart';
import '../../../models/cart_model.dart';
import '../../../widgets/my_text_style.dart';
import '../../home/provider/home_logic.dart';
import '../../product_details/components/add_remove_cart.dart';

/// ກາດຂອງສິນຄ້າ 1 ລາຍການໃນກະຕ່າ
class CartItemCard extends StatelessWidget {
  final CartModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final double price = product?.price ?? 0;
    final double discount = product?.discountPercentage ?? 0;
    // ລາຄາຫລັງຫັກສ່ວນຫລຸດ
    final double finalPrice = price - (price * discount / 100);
    // ລາຄາລວມຂອງລາຍການນີ້ (ລາຄາ x ຈຳນວນ)
    final double lineTotal = finalPrice * item.qty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ຮູບສິນຄ້າ
          _ProductImage(url: product?.thumbnail ?? "", discount: discount),
          SizedBox(width: 12),
          // ລາຍລະອຽດສິນຄ້າ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product?.title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: myTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 6),
                // ຍີ່ຫໍ້ ເເລະ ຈຳນວນ
                Row(
                  children: [
                    _Chip(label: '${product?.brand ?? product?.category}'),
                    SizedBox(width: 6),
                    Text(
                      'x${item.qty}',
                      style: myTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // ລາຄາຕໍ່ໜ່ວຍ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${finalPrice.toStringAsFixed(2)}',
                      style: myTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (discount > 0) ...[
                      SizedBox(width: 6),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textColor.withValues(alpha: 0.40),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10),
                // ລາຄາລວມຂອງລາຍການ ເເລະ ປຸ່ມ + / -
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ລວມ',
                            style: myTextStyle(
                              fontSize: 11,
                              color: AppColors.textColor.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          Text(
                            '\$${lineTotal.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: myTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AddRemoveCart(
                      qty: '${item.qty}',
                      buttonSize: 30,
                      radius: 9,
                      add: () {
                        context.read<HomeLogic>().addToCart(product?.id ?? 0);
                      },
                      remove: () {
                        context.read<HomeLogic>().removeCart(product?.id ?? 0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ຮູບສິນຄ້າ ພ້ອມປ້າຍສ່ວນຫລຸດ
class _ProductImage extends StatelessWidget {
  final String url;
  final double discount;

  const _ProductImage({required this.url, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: AppColors.grayColor.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.grayColor,
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ),
        // ປ້າຍບອກສ່ວນຫລຸດ
        if (discount > 0)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                '-${discount.toStringAsFixed(0)}%',
                style: myTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// ປ້າຍນ້ອຍໆ ສຳລັບຍີ່ຫໍ້ສິນຄ້າ
class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: myTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
