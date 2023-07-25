import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

import '../../../common/index.dart';
import 'index.dart';

class ChatIndexPage extends GetView<ChatIndexController> {
  const ChatIndexPage({Key? key}) : super(key: key);

  // 会话行
  Widget _buildListItem(V2TimConversation? item) {
    // 会话 id
    String? uid =
        item?.type == ConversationType.V2TIM_C2C ? item?.userID : item?.groupID;

    // 会话类型
    int type = item?.type ?? 1;

    // 会话未读数
    int unreadCount = item?.unreadCount ?? 0;

    //最后一条消息的内容
    String subtitle = "";

    //未读数
    if (unreadCount > 0) {
      subtitle = "[$unreadCount条]";
    }

    // 最后一条消息的内容
    subtitle +=
        item?.lastMessage?.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT
            ? item?.lastMessage?.textElem?.text ?? ""
            : "";

    // 列表行
    var listTile = ListTileWidget(
      onTap: () => controller.onChat(uid!, type),
      leading: item?.faceUrl == null
          ? InitialsWidget(item?.showName ?? "")
          : AvatarWidget(item?.faceUrl!),
      title: TextWidget.title2(item?.showName ?? ""),
      subtitle: TextWidget.body1(
        subtitle,
        color: AppColors.secondary.withOpacity(0.5),
      ),
      trailing: [
        TextWidget.body1(
          formatTime(item?.lastMessage?.timestamp ?? 0),
          color: AppColors.secondary.withOpacity(0.5),
        )
      ],
    );

    // 滑动删除
    return Dismissible(
      // 设置滑动方向 从右向左
      direction: DismissDirection.endToStart,
      // 设置唯一的Key，用于删除列表项时的识别
      key: Key(item!.conversationID),
      // 监听删除动作，并执行相应的操作
      onDismissed: (direction) {
        controller.onDeleteConversationByCid(item.conversationID);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(const SnackBar(content: Text("删除会话成功")));
      },
      // 显示删除提示
      confirmDismiss: (direction) async {
        return await showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(LocaleKeys.commonRemoveTitle.tr),
                content: Text("你确定要移除 ${item.showName} 吗？"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("取消")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("删除")),
                ],
              );
            });
      },
      // 滑动删除的背景
      background: ColoredBox(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.listItem),
            child: Icon(Icons.delete, color: AppColors.secondary),
          ),
        ),
      ),
      // 列表项内容
      child: listTile,
    );
  }

  // 列表
  Widget _buildList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        var item = controller.items[index];
        return _buildListItem(item);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: AppSpace.listRow);
      },
      itemCount: controller.items.length,
    );
  }

  // 主视图
  Widget _buildView() {
    return SmartRefresher(
      controller: controller.refreshController, // 刷新控制器
      enablePullUp: true, // 启用上拉加载
      onRefresh: controller.onRefresh, // 下拉刷新回调
      onLoading: controller.onLoading, // 上拉加载回调
      footer: const SmartRefresherFooterWidget(), // 底部加载更多
      child: _buildList(),
    ).paddingAll(AppSpace.page);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatIndexController>(
      init: ChatIndexController(),
      id: "chat_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: controller.onFindUser,
            // ),
            elevation: 0,
            //不局中
            centerTitle: false,
            title: const Text("私信"),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: controller.onFindUser,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: controller.onFindUser,
              ),
            ],
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
