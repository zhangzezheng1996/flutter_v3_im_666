import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

// 课程列表
class CourseIndexController extends GetxController {
  CourseIndexController();

  // 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );
  // 列表
  List<CourseModel> courses = [];
  // 页码
  int _page = 1;
  // 页尺寸
  final int _limit = 20;

  // 拉取数据
  // isRefresh 是否是刷新
  Future<bool> _loadSearch(bool isRefresh) async {
    // 拉取数据
    var result = await CourseApi.courses(
      // 免费课程
      isFree: true,
      // 刷新, 重置页数1
      page: isRefresh ? 1 : _page,
      // 每页条数
      prePage: _limit,
    );

    // 设置缓存
    Storage().setJson(Constants.storageHomeCourses, courses);

    // 下拉刷新
    if (isRefresh) {
      _page = 1; // 重置页数1
      courses.clear(); // 清空数据
    }

    // 有数据
    if (result.isNotEmpty) {
      // 页数+1
      _page++;

      // 添加数据
      courses.addAll(result);
    }

    // 是否空
    return result.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (courses.isNotEmpty) {
      try {
        // 拉取数据是否为空
        var isEmpty = await _loadSearch(false);

        if (isEmpty) {
          // 设置无数据
          refreshController.loadNoData();
        } else {
          // 加载完成
          refreshController.loadComplete();
        }
      } catch (e) {
        // 加载失败
        refreshController.loadFailed();
      }
    } else {
      // 设置无数据
      refreshController.loadNoData();
    }
    update(["course_index"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadSearch(true);
      refreshController.refreshCompleted();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
    update(["course_index"]);
  }

  _initData() async {
    // 读取缓存
    var storageHomeCourses = Storage().getString(Constants.storageHomeCourses);
    if (storageHomeCourses != "") {
      courses = jsonDecode(storageHomeCourses).map<CourseModel>((item) {
        return CourseModel.fromJson(item);
      }).toList();
    }
    update(["course_index"]);
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

  @override
  void onClose() {
    super.onClose();
    // 刷新控制器释放
    refreshController.dispose();
  }
}
