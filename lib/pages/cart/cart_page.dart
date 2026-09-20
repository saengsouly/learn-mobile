import 'package:flutter/material.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color.dart';
import '../../widgets/my_text_style.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeLogic>().homeState;
    return Scaffold(
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
          IconButton(onPressed: (){
            context.read<HomeLogic>().deleteAllCart();
          }, icon: Icon(Icons.delete)),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        itemCount: state.cartList?.length,
        itemBuilder: (context, index) {
          final item = state.cartList?[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.grayColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Row(
              children: [
                Image.network(
                  item?.product?.thumbnail ?? "",
                  width: 100,
                  height: 120,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item?.product?.title}',
                      style: myTextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${item?.product?.price}'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            print('add');
                            context.read<HomeLogic>().addToCart(
                              item?.product?.id ?? 0,
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                        Text('${item?.qty}', style: myTextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            print('add');
                            context.read<HomeLogic>().removeCart(
                              item?.product?.id ?? 0,
                            );
                          },
                          icon: Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
