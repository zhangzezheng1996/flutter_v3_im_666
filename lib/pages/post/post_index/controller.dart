import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';

class PostIndexController extends GetxController {
  PostIndexController();

  // tabController
  TabController? tabController;

  // tab 列表  后期可以根据权限动态生成
  List<Widget> myTabs = <Widget>[
    // const Tab(text: '推荐'),
    Center(
      heightFactor: 2,
      child: IconWidget.image(
        AssetsImages.slackPng,
        // size: 20,
      ),
    ),

    // UserService.to.hasToken ? const Tab(text: '777') : const SizedBox(),
    // Center(
    //   child: UserService.to.hasToken
    //       ? IconWidget.url(
    //           UserService.to.profile.header.toString(),
    //           // size: 20,
    //         )
    //       : IconWidget.image(
    //           AssetsImages.whoPng,
    //           // size: 20,
    //         ),
    // ),
    // const Tab(text: '我的'),
  ];

  _initData() {
    update(["post_index"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
