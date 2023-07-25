import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/index.dart';
import 'index.dart';

class ChatFindUserPage extends GetView<ChatFindUserController> {
  const ChatFindUserPage({Key? key}) : super(key: key);

  // 已选定列表
  Widget _buildSelectedList() {
    return Wrap(
      spacing: 5,
      runSpacing: 0,
      children: controller.selectedUsers
          .map((item) => Chip(
                avatar: item.avatar == null
                    ? InitialsWidget(item.nickname!)
                    : AvatarWidget(item.avatar),
                label: TextWidget.body3(item.nickname ?? "").width(20),
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                onDeleted: () {
                  controller.onCancelSelectUser(item);
                },
              ))
          .toList(),
    );
  }

  // 列表项
  Widget _buildListItem({required UserModel item}) {
    return ListTile(
      leading: item.avatar == null
          ? InitialsWidget(item.nickname!)
          : AvatarWidget(item.avatar),
      title: Text(item.nickname ?? "",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.amber,
          )),
      // subtitle: Text(item.nickname),
      trailing: item.nickname == UserService.to.profile.nickname
          ? const Icon(Icons.person_add_disabled_outlined)
          : controller.isSelected(item)
              ? const Icon(Icons.check_box_outlined)
              : const Icon(Icons.check_box_outline_blank),
      enabled: item.nickname != UserService.to.profile.nickname,
      onTap: item.nickname == UserService.to.profile.nickname
          ? null
          : () {
              controller.onSelectUser(item);
            },
    );
  }

  // 列表
  Widget _buildList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        UserModel item = controller.items[index];
        return _buildListItem(item: item);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: AppSpace.listRow);
      },
      itemCount: controller.items.length,
    );
  }

  // 主视图
  Widget _mainView() {
    return <Widget>[
      // 已选定用户列表
      _buildSelectedList(),

      // 用户列表
      SmartRefresher(
        controller: controller.refreshController, // 刷新控制器
        enablePullUp: true, // 启用上拉加载
        onRefresh: controller.onRefresh, // 下拉刷新回调
        onLoading: controller.onLoading, // 上拉加载回调
        footer: const SmartRefresherFooterWidget(), // 底部加载更多
        child: _buildList(),
      ).expanded(),
    ].toColumn().paddingHorizontal(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatFindUserController>(
      init: ChatFindUserController(),
      id: "chat_find_user",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            leading: ButtonWidget.icon(
              IconWidget.icon(Icons.arrow_back_ios_new_outlined),
              onTap: () {
                Get.back();
              },
            ),
            // 搜索栏
            title: InputWidget.textBorder(
              controller: controller.searchEditController,
            ).limitedBox(maxHeight: 30),
            // 开聊按钮
            actions: controller.hasSelectedUser()
                ? [
                    ButtonWidget.primary(
                      "开聊",
                      onTap: controller.onStartChat,
                      height: 30,
                      width: 40,
                    ).paddingRight(5),
                  ]
                : null,
            // 间距
            titleSpacing: 5,
            // 高度
            toolbarHeight: 30,
          ),
          body: SafeArea(
            child: _mainView(),
          ),
        );
      },
    );
  }
}
