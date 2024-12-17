import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Helper/route_url.dart';
import 'package:palooi/Screen/all_products.dart';
import 'package:palooi/Screen/category_products_screen.dart';
import 'package:palooi/Screen/category_screen.dart';
import 'package:palooi/Screen/category_product_details_screen.dart';
import 'package:palooi/Screen/seller/seller_details_screen.dart';
import 'package:palooi/Widget/nested_screen.dart';
import 'package:palooi/Widget/primary_screen.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(Constants.categoryNavigatorId),
      initialRoute: categoryScreen,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == categoryScreen) {
          return GetPageRoute(
            routeName: categoryScreen,
            page: () => PrimaryScreen(title: Text(
              "Category",
              style: Theme.of(context).textTheme.titleLarge,
            ),body: CategoryScreen()),
          );
        }
        else if (routeSettings.name == categoryProducts) {
          return GetPageRoute(
            routeName: categoryProducts,
            page: () => NestedScreen(
              title: routeSettings.arguments as String,
              body: CategoryProductScreen(category: routeSettings.arguments as String,),
              id: Constants.categoryNavigatorId,
            ),
          );
        }
        // else if (routeSettings.name == categoryProductDetails) {
        //   return GetPageRoute(
        //     routeName: categoryProductDetails,
        //     page: () => NestedScreen(
        //       title: routeSettings.arguments as String,
        //       body: CategoryProductDetailsScreen(productId: MOCK_PRODUCT.id,),
        //       id: Constants.categoryNavigatorId,
        //     ),
        //   );
        // }
        return null;
      },
    );
  }
}
