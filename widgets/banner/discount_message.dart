import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:palooi/Controller/auth_controller.dart';
import 'package:palooi/Controller/banner_controller.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Helper/colors.dart';
import 'package:palooi/Helper/route_url.dart';

class DiscountMessage extends StatelessWidget {
  final Function closeMessage;

  DiscountMessage({super.key, required this.closeMessage});

  final bannerController = Get.find<BannerController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => SizedBox(
                  width: MAX_WIDTH * .6,
                  child: Text(
                    authController.isLogin.value &&
                            bannerController
                                .activeCampaign.value.status.isNotEmpty
                        ? bannerController.activeCampaign.value.text
                        : "Special discounts on",
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Obx(
                () => !authController.isLogin.value
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed(signUpScreen);
                        },
                        child: Text(
                          "Sign up",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
        Positioned.fill(
          right: 0,
          top: 5,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  closeMessage();
                },
                child: const Icon(PhosphorIcons.x)),
          ),
        ),
      ],
    );
  }
}
