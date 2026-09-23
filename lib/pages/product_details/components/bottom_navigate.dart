import 'package:flutter/material.dart';
import '../../../constants/app_color.dart';
import '../../../widgets/my_text_style.dart';

class BottomNavigate extends StatelessWidget {
  final void Function()? addToCart;
  final void Function()? buyNow;
  const BottomNavigate({super.key, this.addToCart, this.buyNow});

  @override
  Widget build(BuildContext context) {
    // ຖ້າ callback ເປັນ null ເເມ່ນປຸ່ມກົດບໍ່ໄດ້ => ຕ້ອງເຮັດໃຫ້ສີຈາງລົງນຳ
    final bool canAddToCart = addToCart != null;
    final bool canBuyNow = buyNow != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                overlayColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: canAddToCart
                        ? AppColors.primaryColor
                        : AppColors.grayColor,
                  ),
                ),
              ),
              onPressed: addToCart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: canAddToCart
                        ? AppColors.textColor
                        : AppColors.textColor.withValues(alpha: 0.3),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ເພີ່ມເຂົ້າກະຕ່າ',
                    style: myTextStyle(
                      fontWeight: FontWeight.w600,
                      color: canAddToCart
                          ? AppColors.textColor
                          : AppColors.textColor.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primaryColor,
                disabledBackgroundColor: AppColors.grayColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: canBuyNow
                        ? AppColors.primaryColor
                        : AppColors.grayColor,
                  ),
                ),
              ),
              onPressed: buyNow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_rounded,
                    color: canBuyNow
                        ? AppColors.whiteColor
                        : AppColors.textColor.withValues(alpha: 0.3),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ຊື້ເລີຍ',
                    style: myTextStyle(
                      fontWeight: FontWeight.w600,
                      color: canBuyNow
                          ? AppColors.whiteColor
                          : AppColors.textColor.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
