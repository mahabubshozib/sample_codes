import 'package:get/get.dart';
import 'package:palooi/Model/FilterOptions.dart';
import 'package:palooi/Model/Product.dart';
import 'package:palooi/Service/product_service.dart';
import 'package:palooi/Util/Util.dart';

class ProductController extends GetxController {
  final loadingAllProducts = false.obs;
  final loadingMoreProducts = false.obs;
  final loadingSearchedProducts = false.obs;
  final loadingReadProduct = false.obs;
  final loadingReadRecommendedProducts = false.obs;
  final loadingReadRecentlyViewedProducts = false.obs;

  final allProducts = <Product>[].obs;
  final totalDocuments = 0.obs;
  final totalPages = 1.obs;
  final searchedProducts = <Product>[].obs;
  final recommendedProducts = <Product>[].obs;
  final recentlyViewedProducts = <Product>[].obs;

  Future<void> getAllProducts(
      {String page = "1",
      String categories = "category=",
      FilterOptions? filterOptions}) async {
    try {
      if (page == "1") {
        loadingAllProducts(true);
      } else {
        loadingMoreProducts(true);
      }

      final response = await ProductService.getAllProducts(
          page: page, categories: categories, filterOptions: filterOptions);

      totalDocuments(response.data["totalDocuments"] ?? 0);
      totalPages(response.data["totalPages"] ?? 1);

      var productListResponse = response.data['docs'] as List;

      var productList = productListResponse.map((product) {
        return Product.fromJson(product);
      }).toList();

      if (page == "1") {
        allProducts(productList);
      } else {
        allProducts.addAll(productList);
      }
    } catch (err) {
      showApiErrorMessage(err);
    } finally {
      loadingAllProducts(false);
      loadingMoreProducts(false);
    }
  }

  Future<List<Product>?> getProductsByQueryString(
      {required String searchQuery}) async {
    try {
      final response =
          await ProductService.getSearchedProducts(searchQuery: searchQuery);

      var productListResponse = response.data['docs'] as List;

      var productList = productListResponse.map((product) {
        return Product.fromJson(product);
      }).toList();

      return productList;
    } catch (err) {
      showApiErrorMessage(err);
      return null;
    }
  }

  Future<Product> getProduct({required String productId}) async {
    try {
      loadingReadProduct(true);

      final response = await ProductService.getProduct(productId: productId);

      final dynamic doc = response.data['doc'];

      if (doc != null) {
        return Product.fromJson(doc);
      } else {
        throw Exception("No product found with ID: $productId");
      }
    } catch (err) {
      showApiErrorMessage(err);
      rethrow;
    } finally {
      loadingReadProduct(false);
    }
  }

  Future<String> getProductImageUrl(imageKey) async {
    try {
      final response =
          await ProductService.getProductImageURL(imageKey: imageKey);
      return response.data["url"];
    } catch (err) {
      showApiErrorMessage(err);
    }
    return "";
  }

  Future<void> getRecommendedProducts() async {
    try {
      loadingReadRecommendedProducts(true);

      final response = await ProductService.getRecommendedProducts();

      var productListResponse = response.data['docs'] as List;

      var productList = productListResponse.map((product) {
        return Product.fromJson(product);
      }).toList();

      recommendedProducts(productList);
    } catch (err) {
      showApiErrorMessage(err);
    } finally {
      loadingReadRecommendedProducts(false);
    }
  }

  Future<void> getRecentlyViewedProducts() async {
    try {
      loadingReadRecentlyViewedProducts(true);

      final response = await ProductService.getRecommendedProducts();

      var productListResponse = response.data['docs'] as List;

      var productList = productListResponse.map((product) {
        return Product.fromJson(product);
      }).toList();

      recentlyViewedProducts(productList);
    } catch (err) {
      showApiErrorMessage(err);
    } finally {
      loadingReadRecentlyViewedProducts(false);
    }
  }
}
