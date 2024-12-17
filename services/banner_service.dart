import 'package:dio/dio.dart';
import 'package:palooi/API/api.dart';
import 'package:palooi/Helper/api_url.dart';

class BannerService {
  static Future<Response> getAllBannerBoards({required String page}) async {
    return await Api().dio.get("$GET_CUSTOMER_ALL_BANNER_BOARDS_API_URL?page=$page");
  }

  static Future<Response> getAllTopBarCampaign({required String page}) async {
    return await Api().dio.get("$GET_CUSTOMER_ALL_TOP_BAR_CAMPAIGN_API_URL?page=$page");
  }

  static Future<Response> getBannerImageURL({String imageKey = ""}) async {
    return await Api().dio.get("$FILES_API_URL/url?key=$imageKey");
  }
}
