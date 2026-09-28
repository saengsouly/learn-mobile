import 'package:flutter/material.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_color.dart';
import '../../../widgets/my_text_style.dart';

/// ເເຖບລຸ່ມສຸດ: ສະເເດງລາຄາລວມ ເເລະ ປຸ່ມສັ່ງຊື້
class CartBottomBar extends StatelessWidget {
  final void Function()? onOrder;

  const CartBottomBar({super.key, this.onOrder});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<HomeLogic>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ລາຄາລວມກ່ອນຫັກສ່ວນຫລຸດ
            _SummaryRow(
              label: 'ລາຄາລວມ (${logic.totalQty} ລາຍການ)',
              value: '${logic.sums.toStringAsFixed(2)}',
            ),
            SizedBox(height: 6),
            // ສ່ວນຫລຸດລວມ
            _SummaryRow(
              label: 'ສ່ວນຫລຸດ',
              value: '-\$${logic.totalDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.errorColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.grayColor.withValues(alpha: 0.6),
              ),
            ),
            // ລາຄາທີ່ຕ້ອງຈ່າຍ
            Row(
              children: [
                Text(
                  'ລວມທັງໝົດ',
                  style: myTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Spacer(),
                Text(
                  '\$${logic.total.toStringAsFixed(2)}',
                  style: myTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // ປຸ່ມສັ່ງຊື້ (ກົດບໍ່ໄດ້ ຖ້າກະຕ່າວ່າງເປົ່າ)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: 3 == 0 ? null : onOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  disabledBackgroundColor: AppColors.grayColor,
                  disabledForegroundColor: AppColors.whiteColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(Icons.shopping_bag_outlined, size: 20),
                label: Text(
                  'ສັ່ງຊື້ສິນຄ້າ',
                  style: myTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ເເຖວຂອງລາຍການສະຫລຸບ (ຫົວຂໍ້ ຢູ່ຊ້າຍ / ຈຳນວນເງິນ ຢູ່ຂວາ)
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: myTextStyle(
            fontSize: 13,
            color: AppColors.textColor.withValues(alpha: 0.55),
          ),
        ),
        Spacer(),
        Text(
          value,
          style: myTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
