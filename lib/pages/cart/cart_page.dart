import 'package:flutter/material.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color.dart';
import '../../widgets/my_text_style.dart';
import 'components/cart_bottom_bar.dart';
import 'components/cart_item_card.dart';
import 'components/empty_cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeLogic>().homeState;
    final cartList = state.cartList ?? [];
    return Scaffold(
      // backgroundColor: AppColors.grayColor.withValues(alpha: 0.30),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'ລາຍການສິນຄ້າ',
          style: myTextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        actions: [
          IconButton(
            onPressed: () {
              context.read<HomeLogic>().deleteAllCart();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: cartList.isEmpty
          ? EmptyCart()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: cartList.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = cartList[index];
                return CartItemCard(item: item);
              },
            ),
      // ເເຖບລຸ່ມສຸດ: ລາຄາລວມ ເເລະ ປຸ່ມສັ່ງຊື້ (ເຊື່ອງໄວ້ເມື່ອກະຕ່າວ່າງເປົ່າ)
      bottomNavigationBar: cartList.isEmpty
          ? null
          : CartBottomBar(
              onOrder: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(
                  backgroundColor: AppColors.warningColor,
                  content: Text('ສັ່ງຊື້ສຳເລັດ')));
              },
            ),
    );
  }
}
