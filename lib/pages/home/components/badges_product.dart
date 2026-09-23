import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:learn_app/widgets/my_text_style.dart';
import 'package:provider/provider.dart';

class BadgesProduct extends StatelessWidget {
  const BadgesProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeLogic>().homeState;
    final cartCount = (state.cartList ?? []).length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart_checkout_rounded),
        if (cartCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$cartCount',
                textAlign: TextAlign.center,
                style: myTextStyle(color: AppColors.whiteColor, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
