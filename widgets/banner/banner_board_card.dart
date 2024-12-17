import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palooi/Controller/keeper_controller.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Helper/route_url.dart';
import 'package:palooi/Model/BannerBoard.dart';
import 'package:palooi/Util/Util%20Widgets/custom_cached_network_image.dart';
import 'package:palooi/Util/Util.dart';
import 'package:palooi/Widget/Home/custom_web_view_screen.dart';
import 'package:palooi/Widget/custom_primary_button.dart';

class BannerBoardCard extends StatelessWidget {
  final BannerBoard bannerBoard;

  BannerBoardCard({super.key, required this.bannerBoard});

  final keeperController = Get.find<KeeperController>();

  @override
  Widget build(BuildContext context) {
    return CustomCachedNetworkImage(
      height: 300,
      width: MAX_WIDTH,
      imageUrl: getImageUrl(bannerBoard.image),
      imageColorFilter: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                textAlign: TextAlign.center,
                bannerBoard.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            VERTICAL_GAP_24,
            CustomSecondaryButton(
              label: bannerBoard.buttonName ?? "",
              onClick: () {
                Get.toNamed(shopNowWebViewScreen, arguments:CustomWebViewScreen(url: bannerBoard.link ?? ""));
              },
              width: MAX_WIDTH * 0.5,
              height: 37,
            )
          ],
        ),
      ),
    );
  }
}
