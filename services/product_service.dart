import 'package:dio/dio.dart';
import 'package:palooi/API/api.dart';
import 'package:palooi/Helper/api_url.dart';
import 'package:palooi/Model/FilterOptions.dart';

class ProductService {
  static Future<Response> getAllProducts({required String page, String categories = "", FilterOptions? filterOptions}) async {
    final options = filterOptions ?? FilterOptions();
    return await Api().dio.get("$GET_ALL_PRODUCTS_API_URL?page=$page&$categories", queryParameters: options.toJson());
  }

  static Future<Response> getSearchedProducts({required String searchQuery}) async {
    return await Api().dio.get("$GET_ALL_PRODUCTS_API_URL?search=$searchQuery");
  }

  static Future<Response> getProduct({required String productId}) async {
    return await Api().dio.get("$GET_ALL_PRODUCTS_API_URL?id=$productId");
  }

  static Future<Response> getRecommendedProducts() async {
    return await Api().dio.get(GET_RECOMMENDED_PRODUCTS_API_URL);
  }

  static Future<Response> getRecentlyViewedProducts() async {
    return await Api().dio.get(GET_RECENTLY_VIEWED_PRODUCTS_API_URL);
  }

  static Future<Response> getProductImageURL({String imageKey = ""}) async {
    return await Api().dio.get("$FILES_API_URL/url?key=$imageKey");
  }
}
