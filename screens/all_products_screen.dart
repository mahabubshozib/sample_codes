import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:palooi/Controller/product_controller.dart';
import 'package:palooi/Helper/colors.dart';
import 'package:palooi/Model/FilterOptions.dart';
import 'package:palooi/Util/Util%20Widgets/secondary_app_bar.dart';
import 'package:palooi/Widget/Category/product_list.dart';
import 'package:palooi/Widget/Category/product_list_header.dart';
import 'package:palooi/Widget/custom_loading.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  // ========== Controllers ============
  final ScrollController _scrollController = ScrollController();

  final productController = Get.find<ProductController>();

  // variables
  int page = 1;

  productScrolling() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          page = page + 1;
        });
        if (page <= productController.totalPages.value) {
          await productController.getAllProducts(
            page: "$page",
          );
        }
        setState(() {});
      }
    });
  }

  void _initialCall() async {
    productScrolling();
    await productController.getAllProducts();
  }

  @override
  void initState() {
    // TODO: implement initState
    _initialCall();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // const PreferredSize(
      //   preferredSize: Size.fromHeight(50),
      //   child: SecondaryAppbar(
      //     title: "All Products",
      //   ),
      // ),
      body: Obx(
        () => productController.loadingAllProducts.value
            ? const Center(child: CustomLoader())
            : Stack(
                alignment: Alignment.bottomCenter, // Align to bottom center
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Obx(
                          () => ProductListHeader(
                            navigatorId: null,
                            selectedSortBy: "Newest",
                            onSortByChange: (value) {
                              sortProducts(value);
                            },
                            totalProducts:
                                productController.totalDocuments.value,
                          ),
                        ),
                        Expanded(
                          child: ProductList(
                            scrollController: _scrollController,
                            productList: productController.allProducts,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => productController.loadingMoreProducts.value
                        ? const Positioned(
                            bottom: 0,
                            child: SpinKitThreeBounce(
                              size: 20,
                              color: PRIMARY_COLOR,
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ),
      ),
    );
  }

  void sortProducts(String value) async {
    await productController.getAllProducts(filterOptions: FilterOptions(sortBy: value.toLowerCase()));
  }
}
