import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palooi/Config/AppConfig.dart';
import 'package:palooi/Controller/auth_controller.dart';
import 'package:palooi/Controller/banner_controller.dart';
import 'package:palooi/Controller/network_controller.dart';
import 'package:palooi/Controller/version_controller.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Util/Util%20Widgets/confirmation_dialog.dart';
import 'package:palooi/Util/Util%20Widgets/palooi_text.dart';
import 'package:palooi/Widget/Home/banner_board_card.dart';
import 'package:palooi/Widget/Home/discount_message.dart';
import 'package:palooi/Widget/empty_state.dart';
import 'package:palooi/Widget/primary_screen.dart';
import 'package:palooi/Widget/shimmers/shimmers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Helper/image_source_url.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();

  final netCon = Get.find<NetworkController>();
  final authController = Get.find<AuthController>();
  final bannerController = Get.find<BannerController>();
  final versionController = Get.find<VersionController>();

  int page = 1;
  bool showInitialDialog = true;

  bannerScrolling() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page + 1 <= bannerController.totalPages.value) {
          page++;
          await bannerController.getAllBannerBoard(
            page: "$page",
          );
        }
      }
    });

    if (versionController.appVersion.value != APP_VERSION) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomDialog(context);
      });
    }
  }

  void _initCall() async {
    bannerScrolling();
  }

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScreen(
      title: const PalooiText(forAppBar: true),
      body: Padding(
        padding: EdgeInsets.only(
            top: bannerController.showDiscountMessage.value ? 0 : 20,
            left: 20,
            right: 20),
        child: Obx(
          () => bannerController.loadingBannerBoards.value
              ? const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: BannerShimmer(),
                )
              : bannerController.bannerBoards.isEmpty
                  ? const EmptyState(
                      image: PngAssets.NO_ADDRESSES,
                      message: "No Banner found!",
                    )
                  : Column(
                      children: [
                        if (bannerController.showDiscountMessage.value)
                          DiscountMessage(
                            closeMessage: () {
                              setState(
                                () {
                                  bannerController.showDiscountMessage.value =
                                      false;
                                },
                              );
                            },
                          ),
                        Expanded(
                          child: ListView.separated(
                            controller: _scrollController,
                            itemCount: bannerController.bannerBoards.length,
                            separatorBuilder: (context, index) =>
                                VERTICAL_GAP_20,
                            // Adjust the height according to your requirement
                            itemBuilder: (context, index) {
                              final bannerBoard =
                                  bannerController.bannerBoards[index];
                              return BannerBoardCard(
                                bannerBoard: bannerBoard,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: "New Update",
          confirmationMessage: 'A new update of app is available!',
          cancelText: 'Cancel',
          okText: "Update Now",
          onOkPressed: () {
            Get.back();
            _launchURL(
                'https://play.google.com/store/apps/details?id=us.palooi&hl=bn&gl=US');
          },
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
