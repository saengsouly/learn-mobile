import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:learn_app/widgets/my_text_style.dart';
import 'package:provider/provider.dart';

class BadgesProduct extends StatelessWidget {
  const BadgesProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeLogic>().homeState;
    return badges.Badge(
      badgeContent: Text('${(state.cartList ?? []).length}', style: myTextStyle(color: AppColors.whiteColor)),
      child: Icon(Icons.shopping_cart_checkout_rounded),
    );
  }
}
