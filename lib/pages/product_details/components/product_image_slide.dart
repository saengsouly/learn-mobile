import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_image.dart';
import '../../../widgets/my_text_style.dart';

/// ສ່ວນສະເເດງຮູບສິນຄ້າ (ເລື່ອນຊ້າຍ-ຂວາໄດ້)
/// ເປັນ StatefulWidget ເພາະຕ້ອງຈື່ວ່າກຳລັງເບິ່ງຮູບທີ່ເທົ່າໃດຢູ່
class ProductImageSlide extends StatefulWidget {
  final List<String> images;
  final double discount;
  final bool outOfStock;
  final double height;

  const ProductImageSlide({
    super.key,
    required this.images,
    this.discount = 0,
    this.outOfStock = false,
    this.height = 300,
  });

  @override
  State<ProductImageSlide> createState() => _ProductImageSlideState();
}

class _ProductImageSlideState extends State<ProductImageSlide> {
  final PageController _pageController = PageController();
  int currentImage = 0;

  List<String> get images => widget.images;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stack = ວາງ widget ຊ້ອນທັບກັນ: ຮູບຢູ່ລຸ່ມສຸດ, ປ້າຍຕ່າງໆຢູ່ເທິງຮູບ
    return Stack(
      children: [
        // ຊັ້ນທີ 1: ຮູບສິນຄ້າ
        Container(
          width: double.infinity,
          height: widget.height,
          color: AppColors.grayColor.withValues(alpha: 0.25),
          alignment: Alignment.center,
          child: images.isEmpty
              // ບໍ່ມີຮູບຈາກ API => ໃຊ້ logo ເເທນ
              ? Image.asset(AppImage.logo, height: 260, fit: BoxFit.contain)
              : PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) =>
                      setState(() => currentImage = index),
                  itemBuilder: (context, index) =>
                      _networkImage(images[index]),
                ),
        ),
        // ຊັ້ນທີ 2: ປ້າຍ % ສ່ວນຫລຸດ ມຸມຊ້າຍເທິງ
        if (widget.discount > 0)
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.errorColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-${widget.discount.toStringAsFixed(0)}%',
                style: myTextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        // ຊັ້ນທີ 3: ຕົວເລກບອກວ່າຮູບທີ່ເທົ່າໃດ ມຸມຂວາເທິງ
        if (images.length > 1)
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.textColor.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${currentImage + 1}/${images.length}',
                style: myTextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        // ຊັ້ນທີ 4: ຈຸດບອກຕຳເເໜ່ງຮູບ ຢູ່ກາງລຸ່ມ
        if (images.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final bool active = index == currentImage;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryColor
                        : AppColors.textColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        // ຊັ້ນທີ 5: ປ້າຍສິນຄ້າໝົດ ທັບໜ້າຮູບ
        if (widget.outOfStock)
          Positioned.fill(
            child: Container(
              color: AppColors.whiteColor.withValues(alpha: 0.6),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.textColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ສິນຄ້າໝົດ',
                  style: myTextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ດຶງຮູບຈາກ network ພ້ອມຈັດການ loading ເເລະ error
  Widget _networkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      // ກຳລັງໂຫລດ => ສະເເດງວົງກົມໝູນ
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            value: progress.expectedTotalBytes == null
                ? null
                : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!,
          ),
        );
      },
      // ໂຫລດຮູບບໍ່ໄດ້ (ເນັດຂາດ / URL ຜິດ) => ໃຊ້ logo ເເທນ
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImage.logo, height: 160, fit: BoxFit.contain),
              SizedBox(height: 8),
              Text(
                'ບໍ່ສາມາດໂຫລດຮູບໄດ້',
                style: myTextStyle(
                  fontSize: 12,
                  color: AppColors.textColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
