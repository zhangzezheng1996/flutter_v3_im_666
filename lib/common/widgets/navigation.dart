import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/index.dart';
import '../index.dart';

/// 导航栏数据模型
class NavigationItemModel {
  final String label;
  final String? svg;
  final int count;
  final IconData? iconData;

  NavigationItemModel({
    required this.label,
    this.svg,
    this.count = 0,
    this.iconData,
  });
}

/// 导航栏
class BuildNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItemModel> items;
  final Function(int) onTap;

  const BuildNavigation({
    Key? key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //主页控制器
    final MainController mainCtl = Get.find();
    var ws = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      var color =
          (i == currentIndex) ? AppColors.onSurfaceVariant : AppColors.outline;
      var item = items[i];
      ws.add(
        <Widget>[
          // 图标
          if (item.iconData != null)
            IconWidget.icon(
              item.iconData,
              size: 20,
              color: color,
              badgeString: item.count > 0 ? item.count.toString() : null,
            ).paddingBottom(2),
          if (item.svg != null)
            IconWidget.svg(
              item.svg,
              size: 20,
              color: color,
              badgeString: item.count > 0 ? item.count.toString() : null,
            ).paddingBottom(2),
          // 文字
          TextWidget.body1(
            item.label.tr,
            color: color,
          ),
        ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.center, // 居中
              mainAxisSize: MainAxisSize.max, // 最大
            )
            .onTap(() => onTap(i))
            .expanded(),
      );
    }
    return BottomAppBar(
      color: ((mainCtl.currentIndex == 0) && !ConfigService.to.isDarkModel)
          ? Colors.black
          : AppColors.surface,
      //       color: ((mainCtl.currentIndex == 0 || mainCtl.currentIndex == 1) &&
      //     !ConfigService.to.isDarkModel)
      // ? Colors.black
      // : AppColors.surface,
      elevation: 0,
      child: ws
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .height(kBottomNavigationBarHeight),
    );
  }
}
