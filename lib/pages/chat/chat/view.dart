import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ChatViewGetX();
  }
}

class _ChatViewGetX extends GetView<ChatController> {
  _ChatViewGetX({Key? key}) : super(key: key);

  /// 用户的 uid 作为唯一标识
  final String uniqueTag = Get.arguments?["uid"]!;

  /// 聊天类型 1: 单聊 2: 群聊
  final type = int.tryParse(Get.arguments['type'].toString());

  // override tag
  @override
  String? get tag => uniqueTag;

  // 群消息消息提示
  Widget _buildTip(String tip) {
    return TextWidget.body1(
      tip,
      color: AppColors.secondary.withOpacity(0.5),
      softWrap: true,
      maxLines: null,
      textAlign: TextAlign.center,
    ).paddingVertical(AppSpace.listRow).center();
  }

  // 消息行
  Widget _buildMsgItem(V2TimMessage msg, {bool isSelf = false}) {
    // 02: 自定义消息
    if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      String? members =
          controller.membersList?.map((e) => e?.nickName ?? "").join(", ");
      return _buildTip(
          groupLocalMessageText(msg.customElem?.data ?? "", members: members));
    }

    // 09: 系统消息 群 Tips 消息（存消息列表）
    // https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Class/Group/V2TimGroupTipsElem.html#type
    if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      String? userNickname = msg.groupTipsElem?.memberList
          ?.map((e) => e?.nickName ?? "")
          .toList()
          .join(",");
      if (userNickname == null) {
        return const SizedBox.shrink();
      }
      String tip = getIMGroupTipsTypeString(
        IMGroupTipsType.values[msg.groupTipsElem?.type ?? 0],
        members: userNickname,
      );
      return _buildTip(tip);
    }

    var ws = <Widget>[
      // 头像
      // "${Constants.imageServer}/avatar/${UserService.to.profile.avatar}"
      if (isSelf) AvatarWidget(UserService.to.profile.avatar),
      if (isSelf == false)
        msg.faceUrl == null
            ? InitialsWidget(msg.sender ?? "")
            : AvatarWidget(msg.faceUrl),

      // 内容：昵称、文字、图片
      <Widget>[
        // 昵称
        if (isSelf == false && controller.isGroup == true)
          TextWidget.body2(
            msg.nickName ?? "",
            color: AppColors.onPrimaryContainer.withOpacity(0.5),
          ).paddingHorizontal(10),

        // 01: 文字消息
        if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT)
          // 文字
          BubbleWidget(
            text: msg.textElem!.text!,
            isSender: isSelf,
            color:
                isSelf == true ? AppColors.primary : AppColors.surfaceVariant,
            textStyle: isSelf == true
                ? TextStyle(color: AppColors.onPrimary, fontSize: 16)
                : TextStyle(color: AppColors.onBackground, fontSize: 16),
          ).gestures(
            // 发送失败，双击重发
            onDoubleTap: msg.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL
                ? () => controller.onReSend(msg)
                : null,
          ),

        // 消息发送失败
        if (msg.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL)
          TextWidget.body2(
            "发送失败，双击消息重发",
            weight: FontWeight.w300,
            color: AppColors.onErrorContainer,
          ).paddingAll(5).decorated(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.warning, width: 1),
              ),
      ]
          .toColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isSelf == true
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
          )
          .expanded(),
    ];
    if (isSelf) {
      ws = ws.reversed.toList();
    }

    return ws
        .toRow(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .paddingBottom(AppSpace.listRow);
  }

  // 消息列表
  Widget _buildMsgList() {
    return GetBuilder<ChatController>(
        id: "messageList",
        tag: tag,
        builder: (_) {
          var messageList = controller.messageList;
          // messageList 按 timestamp 时间戳 倒序
          messageList.sort((left, right) {
            final rightTimestamp = right.timestamp ?? 0;
            final leftTimestamp = left.timestamp ?? 0;
            return rightTimestamp.compareTo(leftTimestamp);
          });
          return SmartRefresher(
            controller: controller.refreshController,
            enablePullUp: true,
            enablePullDown: false,
            onLoading: controller.onLoading,
            footer: const ClassicFooter(
              loadingIcon: SizedBox(
                width: 25.0,
                height: 25.0,
                child: CupertinoActivityIndicator(),
              ),
            ),
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: messageList.length,
              reverse: true,
              itemBuilder: (context, index) {
                V2TimMessage msg = messageList[index];
                return _buildMsgItem(msg, isSelf: msg.isSelf!);
              },
            ),
          ).paddingAll(AppSpace.listView).onTap(controller.onCloseChatBar);
        });
  }

  // 主视图
  Widget _buildView() {
    return _buildMsgList()
        .paddingAll(AppSpace.listView)
        .onTap(controller.onCloseChatBar);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      // 初始控制器
      init: ChatController(
        receiver: uniqueTag, // tag
        type: type ?? ConversationType.V2TIM_C2C, // 类型
      ),
      id: "chat",
      tag: tag,
      builder: (_) {
        return Scaffold(
          // 全局key
          key: controller.scaffoldKey,

          // 顶部导航栏
          appBar: AppBar(
            elevation: 0,
            title: Text(controller.title),
            actions: [
              if (controller.isGroup)
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: controller.onGroupSettingOpen,
                ),
            ],
          ),

          // 背景色
          backgroundColor: AppColors.surface,

          // 正文
          body: SafeArea(
            child: _buildView(),
          ),

          // 底部聊天栏
          bottomNavigationBar: ChatBarWidget(
            key: controller.chatBarKey,
            onTextSend: controller.onTextSend,
          ),

          // 右侧弹出 Drawer
          endDrawer: controller.isGroup
              ? Drawer(
                  child:
                      SafeArea(child: GroupSettingView(uniqueTag: uniqueTag)),
                )
              : null,
        );
      },
    );
  }
}
