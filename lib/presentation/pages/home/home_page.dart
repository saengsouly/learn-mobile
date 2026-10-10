import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:learn_app/core/constants/app_color.dart';
import 'package:learn_app/core/constants/app_image.dart';
import 'package:learn_app/core/constants/data_demo.dart';
import 'package:learn_app/data/models/products_model.dart';
import 'package:learn_app/presentation/pages/cart/cart_page.dart';
import 'package:learn_app/presentation/pages/home/components/badges_product.dart';
import 'package:learn_app/presentation/pages/home/components/product_list.dart';
import 'package:learn_app/presentation/providers/home/home_logic.dart';
import 'package:learn_app/presentation/providers/login/login_logic.dart';
import 'package:learn_app/shared/widgets/my_text_style.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductsModel> cartList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      context.read<HomeLogic>().getListProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('cart ==>${cartList.length}');
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Column(
          children: [
            // ສະເເດງຂໍ້ມູນສ່ວນ profile , action
            Consumer<LoginLogic>(
              builder: (context, loginLogic, child) {
                final user = loginLogic.loginState.userModel;
                final fullName = user == null
                    ? 'ສະບາຍດີ...'
                    : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
                return Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: (user?.image != null && user!.image!.isNotEmpty)
                            ? Image.network(
                                user.image!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(AppImage.logo),
                              )
                            : Image.asset(AppImage.logo),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty ? 'ສະບາຍດີ...' : fullName,
                          style: myTextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push( 
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                      child: BadgesProduct(),
                    ),
                  ],
                );
              },
            ),
            // ສະເເດງ slide ສິນຄ້າ,ໂຄສະນະ
            SizedBox(height: 10),
            CarouselSlider(
              items: slidePromotion.map((item) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.errorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(item, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180,
                viewportFraction: 1,
                autoPlayInterval: Duration(seconds: 2),
                // autoPlay: true,
                // autoPlayAnimationDuration: Duration(milliseconds: 200)
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ລາຍການສິນຄ້າ',
                style: myTextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            // ການສະເເດງລາຍການສິນຄ້າທີມີ Gridview
            ProductList(),
          ],
        ),
      ),
    );
  }
}
