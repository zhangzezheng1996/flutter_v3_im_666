import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

// 课程列表
class CourseItemWidget extends StatelessWidget {
  final CourseModel item;
  final Function()? onTap;
  const CourseItemWidget(this.item, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 图
      ImageWidget.url(
        "${Constants.imageServer}/${item.uri}/${item.cover}.png?x-oss-process=image/resize,w_900",
      ).paddingBottom(AppSpace.listRow),

      // 主标题
      TextWidget.body1(item.title ?? "").padding(all: AppSpace.listRow),

      //
      <Widget>[
        // 标签
        for (var tag in item.tags ?? [])
          TagWidget(text: tag).padding(right: AppSpace.listRow),

        const Spacer(),

        // 会员课
        TagWidget(
          text: item.isFree == true
              ? LocaleKeys.courseFree.tr
              : LocaleKeys.courseMember.tr,
          color: item.isFree == false ? AppColors.tertiaryContainer : null,
        ),
      ].toRow().padding(
            left: AppSpace.listRow,
            bottom: AppSpace.listRow,
            right: AppSpace.listRow,
          ),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .card()
        .onTap(
          onTap ??
              () {
                Get.toNamed(
                  RouteNames.courseDetail,
                  parameters: {"uri": item.uri ?? ""},
                );
              },
        );
  }
}
