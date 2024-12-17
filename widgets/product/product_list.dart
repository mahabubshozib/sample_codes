import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palooi/Controller/wishlist_controller.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Helper/route_url.dart';
import 'package:palooi/Model/Product.dart';
import 'package:palooi/Util/Util%20Widgets/product_card.dart';

class ProductList extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Product> productList;

  ProductList({super.key, required this.productList, this.scrollController});

  final wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisExtent: 280,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: productList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (!wishlistController.wishlistCreateLoading.value &&
                !wishlistController.wishlistDeleteLoading.value) {
              Get.toNamed(productDetails, arguments: {
                "productId": productList[index].id,
                "productName": productList[index].name
              });
            }
          },
          child: ProductCard(
            small: true,
            product: productList[index],
          ),
        );
      },
    );
  }
}
