import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:palooi/Model/BannerBoard.dart';
import 'package:palooi/Model/Campaign.dart';
import 'package:palooi/Service/banner_service.dart';
import 'package:palooi/Util/Util.dart';

class BannerController extends GetxController {
  final loadingBannerBoards = false.obs;
  final loadingTopBarCampaign = false.obs;
  final bannerBoards = <BannerBoard>[].obs;
  final topBarCampaigns = <Campaign>[].obs;
  final activeCampaign = Campaign().obs;
  final showDiscountMessage = true.obs;
  final discountMessage = "".obs;
  final totalPages = 0.obs;
  final topBarTotalPages = 0.obs;

  Future<void> getAllBannerBoard({String page = "1"}) async {
    try {
      loadingBannerBoards(true);
      final response = await BannerService.getAllBannerBoards(page: page);

      totalPages(response.data["totalPages"]);
      var bannerListData = response.data['docs'] as List;

      var bannerBoardsList = bannerListData.map((banner) {
        return BannerBoard.fromJson(banner);
      }).toList();

      bannerBoards(bannerBoardsList);
    } catch (err) {
      showApiErrorMessage(err);
    }
    finally{
      loadingBannerBoards(false);
    }
  }

  Future<void> getAllTopBarCampaign({String page = "1"}) async {
    try {
      loadingTopBarCampaign(true);
      final response = await BannerService.getAllTopBarCampaign(page: page);

      topBarTotalPages(response.data["totalPages"]);
      var campaignListData = response.data['docs'] as List;

      var campaignsList = campaignListData.map((campaign) {
        return Campaign.fromJson(campaign);
      }).toList();



      var activeElement = campaignsList.firstWhere(
            (element) => element.status == "active",
        orElse: () =>
              Campaign()
      );

      // activeCampaign.value = campaignsList.firstWhere((element) => element.status == "active");
      if(activeElement.status.isNotEmpty){
        activeCampaign(activeElement);
      }
      topBarCampaigns(campaignsList);
    } catch (err) {
      showApiErrorMessage(err);
    }
    finally {
      loadingTopBarCampaign(false);
    }
  }
}
