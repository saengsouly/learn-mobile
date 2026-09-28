import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../widgets/my_text_style.dart';

/// ສະເເດງເມື່ອກະຕ່າວ່າງເປົ່າ
class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.grayColor,
          ),
          SizedBox(height: 12),
          Text(
            'ຍັງບໍ່ມີສິນຄ້າໃນກະຕ່າ',
            style: myTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}
