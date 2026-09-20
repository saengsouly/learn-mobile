import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:learn_app/pages/home/provider/home_state.dart';
import 'package:learn_app/widgets/my_text_style.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeLogic>(
      builder: (context, product, child) {
        // print('product list ==> ${product.homeState.productList}');
        final state = product.homeState;
        // ທຳອຶດຈະມາກວດສອບ status ເບິ່ງກ່ອນເພື່ອລໍຖ້າ convert data to model
        if (state.homeStatus == HomeStatus.loading) {
          // ກວດສອບວ່າ ຖ້າ status == loading ເເມ່ນໃຫ້ສະເເດງຫຍັງເເທນ
          return CircularProgressIndicator();
        }
        if (state.homeStatus == HomeStatus.error) {
          // ກວດສອບວ່າ ຖ້າ status == error ຈະໃຫ້ສະເເດງຫຍັງເເທນ
          return Text('data');
        }
        // ຖ້າ status ບໍ່ເທ່ົ່າກັບ loading ,error ສະເເດງວ່າມັນຕ້ອງເປັນ success
        // ຖ້າເປັນ success ເເມ່ນໃຫ້ສະເເດງຂໍ້ມູນເລີຍ
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: state
              .productList
              .length, // ບອກໃຫ້ Gridview ຮູ້ວ່າ List ຂອງເຮົາມີຈຳນວນ item ເທົ່າໃດ
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final item = state
                .productList[index]; //ຖືກປະກາດມາເພື່ອ ດຶງເອົາຂໍ້ມູນຂອງສິນຄ້າທີລະຕົວ ອອກມາຈາກລາຍການ (List) ຕາມຕຳແໜ່ງ (index) ທີ່ກຳລັງສະແດງຜົນຢູ່ໃນເວລານັ້ນ ເພື່ອເອົາມາໃຊ້ງານຕໍ່ໄດ້ງ່າຍ
            return Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                // stack ເເມ່ນ Widget ທີ່ໃຊ້ສໍາລັບ ຈັດວາງ Widget ຍ່ອຍ (Children) ໃຫ້ວາງຊ້ອນທັບກັນ ແບບໜ້າ-ຫຼັງ
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.grayColor.withAlpha(100),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          // ໃຊ້ເພື່ອສະເເດງຮູບພາບທີ່ມາຈາກ API or Network
                          item.thumbnail ?? "",
                          height: 100,
                          errorBuilder: (context, _, _) {
                            return Text('data');
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6, top: 10),
                        child: Text(
                          item.title ?? "N/A",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: myTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Text(
                              '\$${((item.price ?? 0) - ((item.price ?? 0) * (item.discountPercentage ?? 0)) / 100).toStringAsFixed(2)}',
                              style: myTextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '\$${item.price}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rate,
                              color: Colors.deepOrange,
                              size: 12,
                            ),
                            Text(
                              '${item.rating}(${item.reviews?.length})',
                              style: myTextStyle(fontSize: 10),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  //ແມ່ນໃຊ້ສຳລັບ ການໄລ່ລະດັບສີ (Color Gradient)
                                  colors: [
                                    Colors
                                        .deepOrange, //ເລີ່ມຕົ້ນດ້ວຍສີສົ້ມເຂັ້ມ
                                    Colors.orange, // ແລ້ວຄ່ອຍໆກາຍເປັນສີສົ້ມ
                                    Colors
                                        .orangeAccent, //ແລະຈົບລົງດ້ວຍສີສົ້ມສະຫວ່າງ
                                  ],
                                  begin: AlignmentGeometry
                                      .centerLeft, //ໝາຍເຖິງ ເລີ່ມຕົ້ນໄລ່ສີຈາກທາງດ້ານຊ້າຍ (ກາງຊ້າຍ)
                                  end: AlignmentGeometry
                                      .centerRight, //ໝາຍເຖິງ ໄປສິ້ນສຸດຢູ່ທາງດ້ານຂວາ (ກາງຂວາ)
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_cart_sharp,
                                size: 12,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    //Positioned ເເມ່ນໃຊ້ເພື່ອກຳນົດຕຳແໜ່ງຂອງ Widget ຍ່ອຍໃຫ້ຢູ່ຈຸດທີ່ຕ້ອງການ
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '${item.discountPercentage}%',
                        style: myTextStyle(
                          fontSize: 8,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
