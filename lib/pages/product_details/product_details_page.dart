import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/product_details/components/add_remove_cart.dart';
import 'package:learn_app/pages/product_details/components/bottom_navigate.dart';
import 'package:learn_app/pages/product_details/components/product_image_slide.dart';
import 'package:learn_app/widgets/my_text_style.dart';

import '../../models/products_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductsModel data;
  const ProductDetailsPage({super.key, required this.data});

  // ລາຄາເຕັມ (ກ່ອນຫລຸດ)
  double get originalPrice => data.price ?? 0;

  // ເປີເຊັນສ່ວນຫລຸດ
  double get discount => data.discountPercentage ?? 0;

  // ລາຄາຫລັງຫລຸດເເລ້ວ
  double get finalPrice => originalPrice * (1 - discount / 100);

  // ຈຳນວນທີ່ເຫລືອໃນສະຕັອກ
  int get stock => data.stock ?? 0;

  // ຈຳນວນຕ່ຳສຸດທີ່ສັ່ງຊື້ໄດ້
  int get minOrder => (data.minimumOrderQuantity ?? 1).clamp(1, 9999);

  bool get outOfStock => stock <= 0;
  bool get lowStock => stock > 0 && stock <= 10;

  // TODO: ຕໍ່ກັບ state ຕົວຈິງພາຍຫລັງ (ຕອນນີ້ຕັ້ງຄ່າຄົງທີ່ໄວ້ກ່ອນ)
  int get qty => minOrder;

  // ລາຍການຮູບ: ໃຊ້ images ກ່ອນ, ຖ້າບໍ່ມີຈຶ່ງໃຊ້ thumbnail
  List<String> get images {
    final List<String> list = data.images ?? [];
    if (list.isNotEmpty) return list;
    if ((data.thumbnail ?? '').isNotEmpty) return [data.thumbnail!];
    return [];
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'ລາຍລະອຽດຂອງສິນຄ້າ',
          style: myTextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSlide(
              images: images,
              discount: discount,
              outOfStock: outOfStock,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandAndRating(),
                  SizedBox(height: 8),
                  Text(
                    '${data.title}',
                    style: myTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildPrice(),
                  SizedBox(height: 12),
                  _buildStock(),
                  _divider(),
                  _buildQtySection(),
                  _divider(),
                  _buildDescription(),
                  _divider(),
                  _buildInfoList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigate(
        // TODO: ຂ້ອຍຈະຂຽນເອງ
        addToCart: () {},
        buyNow: () {},
      ),
    );
  }

  // ---------------- ຍີ່ຫໍ້ / ໝວດ / ດາວ ----------------
  Widget _buildBrandAndRating() {
    final String brand = data.brand ?? data.category ?? '';
    return Row(
      children: [
        if (brand.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              brand,
              style: myTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        Spacer(),
        if (data.rating != null) ...[
          Icon(Icons.star_rounded, size: 18, color: AppColors.warningColor),
          SizedBox(width: 2),
          Text(
            data.rating!.toStringAsFixed(1),
            style: myTextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4),
          Text(
            '(${data.reviews?.length ?? 0})',
            style: myTextStyle(
              fontSize: 13,
              color: AppColors.textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------- ລາຄາ: ຫລັງຫລຸດ + ລາຄາເຕັມຂີດຖິ້ມ + % ----------------
  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ລາຄາທີ່ຕ້ອງຈ່າຍຈິງ
            Text(
              _money(finalPrice),
              style: myTextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            if (discount > 0) ...[
              SizedBox(width: 8),
              // ລາຄາເຕັມກ່ອນຫລຸດ (ຂີດຖິ້ມ)
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Text(
                  _money(originalPrice),
                  style: myTextStyle(
                    fontSize: 15,
                    color: AppColors.textColor.withValues(alpha: 0.45),
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${discount.toStringAsFixed(0)}%',
                    style: myTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (discount > 0) ...[
          SizedBox(height: 4),
          Text(
            'ປະຢັດໄດ້ ${_money(originalPrice - finalPrice)}',
            style: myTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.successColor,
            ),
          ),
        ],
      ],
    );
  }

  // ---------------- ສະຕັອກ ----------------
  Widget _buildStock() {
    late final Color color;
    late final String label;
    late final IconData icon;

    if (outOfStock) {
      color = AppColors.errorColor;
      label = 'ສິນຄ້າໝົດ';
      icon = Icons.remove_shopping_cart_outlined;
    } else if (lowStock) {
      color = AppColors.warningColor;
      label = 'ເຫລືອໜ້ອຍ ພຽງ $stock ອັນ';
      icon = Icons.warning_amber_rounded;
    } else {
      color = AppColors.successColor;
      label = 'ມີສິນຄ້າ ($stock ອັນ)';
      icon = Icons.check_circle_outline;
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: myTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- ເລືອກຈຳນວນ + ລາຄາລວມ ----------------
  Widget _buildQtySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ຈຳນວນ',
              style: myTextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            AddRemoveCart(
              qty: '$qty',
              // TODO: ຂ້ອຍຈະຂຽນເອງ
              add: () {},
              remove: () {},
            ),
          ],
        ),
        SizedBox(height: 8),
        // ບອກຜູ້ໃຊ້ວ່າສັ່ງຊື້ໄດ້ຫລາຍສຸດ / ຕ່ຳສຸດເທົ່າໃດ
        if (!outOfStock && qty >= stock)
          _hint('ສັ່ງຊື້ໄດ້ສູງສຸດ $stock ອັນ', AppColors.warningColor)
        else if (minOrder > 1)
          _hint(
            'ສັ່ງຊື້ຂັ້ນຕ່ຳ $minOrder ອັນ',
            AppColors.textColor.withValues(alpha: 0.5),
          ),
        SizedBox(height: 12),
        // ລາຄາລວມ
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                'ລວມທັງໝົດ',
                style: myTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                _money(finalPrice * qty),
                style: myTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hint(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 14, color: color),
        SizedBox(width: 4),
        Text(text, style: myTextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  // ---------------- ລາຍລະອຽດ ----------------
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ລາຍລະອຽດ',
          style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          '${data.description}',
          style: myTextStyle(
            fontSize: 14,
            color: AppColors.textColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  // ---------------- ຂໍ້ມູນເພີ່ມເຕີມ ----------------
  Widget _buildInfoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ຂໍ້ມູນເພີ່ມເຕີມ',
          style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        _infoRow(Icons.local_shipping_outlined, data.shippingInformation),
        _infoRow(Icons.verified_user_outlined, data.warrantyInformation),
        _infoRow(Icons.assignment_return_outlined, data.returnPolicy),
        _infoRow(Icons.qr_code_2_outlined, data.sku),
      ],
    );
  }

  Widget _infoRow(IconData icon, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.textColor.withValues(alpha: 0.5),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: myTextStyle(
                fontSize: 13,
                color: AppColors.textColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Divider(height: 1, color: AppColors.grayColor),
  );
}
