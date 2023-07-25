import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

import '../../../common/index.dart';

class RecommendController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RecommendController();
  //页面控制器
  PageController pageController = PageController(
      // viewportFraction: 0.6, //页面占比
      );
  // 页面当前位置
  int currentPageIndex = 0;
  //Post主数据
  List<PostViewModel> items = [];
  /////////////////////////////////////////////////////
  int _page = 1;
  // 页尺寸
  final int _limit = 3;
  ///////////////////////////////////////////////////////
  _initData() async {
    //打印拉去数据
    print('拉取Post数据...');
    // 拉取数据
    await _loadSearch(false);
    // 监听滑动到底部
    pageController.addListener(() {
      //打印pageController的滑动距离
      // print('pageController的滑动距离:${pageController.position.pixels}');
      // if (currentPageIndex + 1 == items.length) {
      //   //给items添加新的数据
      //   //延迟加载数据
      //   Future.delayed(const Duration(milliseconds: 500), () {
      //     _loadSearch(false);
      //     print('滑动到了最底部 有新数据添加了');
      //     update(["recommend"]);
      //   });
      // }

      //打印pageController的最大滚动范围
      if (pageController.position.pixels ==
          pageController.position.maxScrollExtent) {
        // //延迟加载数据
        Future.delayed(const Duration(milliseconds: 500), () {
          //打印pageController的最大滚动范围
          _loadSearch(false);
          update(["recommend"]);
          print('滑动到了最底部 有新数据添加了');
        });
      }
    });
    //更新UI
    update(["recommend"]);
  }

  //////////////////////////////////////////////////////////////
  /// 拉取数据
  /// isRefresh 是否是刷新
  Future<bool> _loadSearch(bool isRefresh) async {
    // 拉取数据
    var result = await PostApi.posts(
      PageReq(
        // 刷新, 重置页数1
        page: isRefresh ? 1 : _page,
        // 每页条数
        limit: _limit,
      ),
    );

    // 下拉刷新
    if (isRefresh) {
      _page = 1; // 重置页数1
      // PostService.to.clear();
      items.clear(); // 清空数据
      //await Storage().remove(Constants.storageVideoItems);
    }

    // 有数据
    if (result.isNotEmpty) {
      // 页数+1
      _page++;

      // 添加数据
      // PostService.to.postItems.addAll(result);
      items.addAll(result);
      // 保存最新离线数据 防止积压过多数据 视频页会来加载这些数据
      // Storage().setJson(Constants.storageVideoItems, items);

      // //设置一下当前的悬浮按钮
      // FloatService.to.floatImageUrl.value =
      //     items[currentIndex].zero!.image.toString();
    }

    // 是否空
    return result.isEmpty;
    // return true;
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
    pageController.dispose(); // 释放
  }

  /// 上拉载入post数据
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空  不为空
        var isEmpty = await _loadSearch(false);

        if (isEmpty) {
          // 设置无数据
        } else {
          // 加载完成
          // refreshController.loadComplete();
        }
      } catch (e) {
        // 加载失败
        // refreshController.loadFailed();
      }
    } else {
      // 设置无数据
      // refreshController.loadNoData();
    }
    update(["recommend"]);
  }

  /// 下拉刷新
  Future<void> onRefresh() async {
    try {
      await _loadSearch(true);
      // refreshController.refreshCompleted();
    } catch (error) {
      // 刷新失败
      // refreshController.refreshFailed();
    }
    update(["recommend"]);
  }

  //删除当前post页面
  Future<void> onDeleteCurrentPostPage(int index) async {
    //记录要删除的页面index
    // int toDeletePageIndex = currentPageIndex;
    //跳转到当前页面的下一个页面
    // pageController.jumpToPage(currentPageIndex + 1);
    //打印当前要删除的页面index
    print('删除前的当前index:$index');
    //打印当前items的长度
    print('删除前的数组items长度:${items.length}');

    //删除记录的页面
    items.removeAt(index);
    //如果index
    update(["recommend"]);

    print('删除后的当前index:$index');
    //打印当前items的长度
    print('删除后的数组items长度:${items.length}');
    //打印当前items的信息
    // print('当前items长度:' + items.length.toString());
    if (index == items.length) {
      //给items添加新的数据
      onLoading();
    }

    // items.removeAt(currentPageIndex);
    //跳转到下一个页面
    // pageController.nextPage(
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeIn,
    // );
    //更新UI
    // update(["recommend"]);
  }

  //post页面当前位置发生改变
  void onPageChanged(int index) {
    //设置当前页面
    currentPageIndex = index;
    //如果当前页面是最后一个页面加载更多数据
    if (index == items.length - 1) {
      //给items添加新的数据
      onLoading();
    }
  }

  // 主动入群
  Future<void> onJoinGroup(String gid) async {
    if (gid.isEmpty) return;
    // 加入群组
    V2TimCallback joinGroupRes =
        await TencentImSDKPlugin.v2TIMManager.joinGroup(
            groupID: gid, // 需要加入群组 ID
            message: "hello", // 加群申请信息
            groupType: "AVChatRoom"); // 群类型
    if (joinGroupRes.code == 0) {
      // 加入成功
    }
  }

  // 跳转到聊天区页面
  Future<void> onChat(String? postId, String? gid) async {
    //跳转到详情页
    Get.toNamed(RouteNames.postChatArea, arguments: {
      "id": postId ?? 0,
      "chatAreaId": gid ?? "0",
    });

    //加入直播群
    onJoinGroup(
      gid ?? "0",
    );
  }
}
