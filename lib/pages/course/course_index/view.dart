import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class CourseIndexPage extends GetView<CourseIndexController> {
  const CourseIndexPage({Key? key}) : super(key: key);

  // 课程列表
  Widget _buildCourseList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var item = controller.courses[index];
        return CourseItemWidget(item);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AppSpace.listRow * 2);
      },
      itemCount: controller.courses.length,
    );

    // return controller.courses
    //     .map((item) => CourseItemWidget(item))
    //     .toList()
    //     .toColumn();
  }

  // 主视图
  Widget _buildView() {
    return SmartRefresher(
      controller: controller.refreshController, // 刷新控制器
      enablePullUp: true, // 启用上拉加载
      onRefresh: controller.onRefresh, // 下拉刷新回调
      onLoading: controller.onLoading, // 上拉加载回调
      footer: const SmartRefresherFooterWidget(), // 底部加载更多
      child: _buildCourseList(),
    )
        .padding(
          horizontal: AppSpace.page,
          // top: AppSpace.page,
        )
        .safeArea();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseIndexController>(
      // init: CourseIndexController(),
      init: Get.find<CourseIndexController>(),
      id: "course_index",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("course_index")),
          appBar: mainAppBarWidget(),
          body: _buildView(),
        );
      },
    );
  }
}
