import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../widgets/my_text_style.dart';

class AddRemoveCart extends StatelessWidget {
  final void Function()? add;
  final void Function()? remove;
  final String qty;

  /// ຂະໜາດຂອງປຸ່ມ + / -
  final double buttonSize;

  /// ຄວາມມົນຂອງມູມ (radius)
  final double radius;

  const AddRemoveCart({
    super.key,
    this.add,
    this.remove,
    required this.qty,
    this.buttonSize = 38,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.grayColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(radius + 4),
        border: Border.all(color: AppColors.grayColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ປຸ່ມຫລຸດ
          _StepButton(
            icon: Icons.remove,
            onTap: remove,
            size: buttonSize,
            radius: radius,
            backgroundColor: AppColors.whiteColor,
            iconColor: AppColors.textColor,
          ),
          // ຈຳນວນ
          Container(
            constraints: BoxConstraints(minWidth: 44),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              qty,
              style: myTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ),
          // ປຸ່ມເພີ່ມ
          _StepButton(
            icon: Icons.add,
            onTap: add,
            size: buttonSize,
            radius: radius,
            backgroundColor: AppColors.primaryColor,
            iconColor: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final double size;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;

  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.radius,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // ຖ້າ onTap ເປັນ null ຈະເປັນປຸ່ມທີ່ກົດບໍ່ໄດ້ (disabled)
    final bool enabled = onTap != null;
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    return Material(
      color: enabled
          ? backgroundColor
          : backgroundColor.withValues(alpha: 0.4),
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.55,
            color: enabled ? iconColor : iconColor.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
