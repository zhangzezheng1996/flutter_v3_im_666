import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/index.dart';

class ChatFindUserController extends GetxController {
  ChatFindUserController();

  // 刷新控制器
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  // 列表
  List<UserModel> items = [];
  // 页码
  int _page = 1;
  // 页尺寸
  final int _limit = 20;

  // 搜索控制器
  final TextEditingController searchEditController = TextEditingController();

  // 搜索关键词
  final searchKeyWord = "".obs;

  // 已选定用户列表
  List<UserModel> selectedUsers = [];

  // _initData() {
  //   update(["chat_find_user"]);
  // }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    // _initData();

    // 注册防抖
    _searchDebounce();
  }

  @override
  void onClose() {
    super.onClose();
    searchEditController.dispose(); // 搜索栏控制器释放
    refreshController.dispose(); // 释放
  }

  //////////////////////////////////////////////////

  // 拉取数据
  // isRefresh 是否是刷新
  Future<bool> _loadSearch(String keyword, bool isRefresh) async {
    // 拉取数据
    var result = await UserApi.findList(
      // keyword,
      keyword: keyword,
      // 刷新, 重置页数1
      page: isRefresh ? 1 : _page,
      // 每页条数
      pageSize: _limit,
    );

    // 下拉刷新
    if (isRefresh) {
      _page = 1; // 重置页数1
      items.clear(); // 清空数据
    }

    // 有数据
    if (result.isNotEmpty) {
      // 页数+1
      _page++;

      // 添加数据
      items.addAll(result);
    }

    // 是否空
    return result.isEmpty;
  }

  // 上拉载入新数据
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空
        var isEmpty = await _loadSearch(searchKeyWord.value, false);

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
    update(["chat_find_user"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadSearch(searchKeyWord.value, true);
      refreshController.refreshCompleted();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
    update(["chat_find_user"]);
  }

  // 是否选中
  bool isSelected(UserModel user) {
    return selectedUsers.contains(user);
  }

  // 是否有用户选中
  bool hasSelectedUser() {
    return selectedUsers.isNotEmpty;
  }

  // 搜索栏位 - 防抖
  void _searchDebounce() {
    // getx 内置防抖处理
    debounce<String>(
      // obs 对象
      searchKeyWord,

      // 回调函数
      (value) async {
        // 调试
        log("debounce -> $value");

        // 拉取数据
        await _loadSearch(value, true);
        update(["chat_find_user"]);
      },

      // 延迟 500 毫秒
      time: const Duration(milliseconds: 500),
    );

    // 监听搜索框变化
    searchEditController.addListener(() {
      searchKeyWord.value = searchEditController.text;
    });
  }

  // 选择用户
  void onSelectUser(UserModel user) {
    // 已经选中
    if (isSelected(user)) {
      // 移除
      selectedUsers.remove(user);
    } else {
      // 添加
      selectedUsers.add(user);
    }
    update(["chat_find_user"]);
  }

  // 取消选择用户
  void onCancelSelectUser(UserModel user) {
    // 移除
    selectedUsers.remove(user);
    update(["chat_find_user"]);
  }

  // 开始聊天
  Future<void> onStartChat() async {
    if (selectedUsers.isEmpty) {
      return;
    }
    Get.back(result: selectedUsers);
  }
}
