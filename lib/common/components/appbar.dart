import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 主导航栏
AppBar mainAppBarWidget({
  Key? key,
  Function()? onTap, // 点击事件
  Widget? leading, // 左侧按钮
  String? titleString, // 标题
  double? titleSpace, // 标题间距
  double? iconSize, // 图标大小
}) {
  return AppBar(
    // 最左侧按钮
    leading: leading,

    // 按钮和标题组件间距
    titleSpacing: titleSpace, //?? AppSpace.listItem,

    // 标题组件
    centerTitle: false,
    title: titleString != null
        ? TextWidget.navigation(titleString)
        : <Widget>[
            const ImageWidget.asset(
              AssetsImages.logoPng,
              fit: BoxFit.contain,
              height: 30,
            ),
            TextWidget.body1(LocaleKeys.appTitle.tr)
          ].toRow(),

    // // 右侧按钮组
    // actions: [
    //   Obx(() => UserService.to.isLogin
    //       ? ButtonWidget.icon(
    //           IconWidget.url(
    //             "${Constants.imageServer}/avatar/${UserService.to.profile.avatar}",
    //             size: 30,
    //             badgeString: UserService.to.profile.vipGrade == "guest"
    //                 ? null
    //                 : UserService.to.profile.vipGrade,
    //             // badgeColor: UserService.to.profile.vipGrade != "guest"
    //             //     ? AppColors.highlight
    //             //     : null,
    //             // isClipOval: true,
    //           ),
    //           onTap: () => Get.find<MainController>()
    //               .onJumpToPage(3), //Get.toNamed(RouteNames.myMyIndex),
    //         ).paddingRight(5)
    //       : ButtonWidget.icon(
    //           IconWidget.icon(Icons.person),
    //           onTap: () => Get.toNamed(RouteNames.systemLogin),
    //         ).paddingRight(5)),
    // ],
  );
}
