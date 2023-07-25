import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common/index.dart';
import 'index.dart';
import 'widgets/chat_bar.dart';

class ChatAreaPage extends StatefulWidget {
  const ChatAreaPage({Key? key}) : super(key: key);

  @override
  State<ChatAreaPage> createState() => _ChatAreaPageState();
}

class _ChatAreaPageState extends State<ChatAreaPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ChatAreaViewGetX();
  }
}

class _ChatAreaViewGetX extends GetView<ChatAreaController> {
  _ChatAreaViewGetX({Key? key}) : super(key: key);

  /// 用户的 chatAreaId 作为唯一标识
  final String uniqueTag = Get.arguments?["chatAreaId"]!;

  // override tag
  @override
  String? get tag => uniqueTag;

  // 消息提示
  Widget _buildTip(String tip) {
    return TextWidget.body1(
      tip,
      color: AppColors.secondary.withOpacity(0.5),
      softWrap: true,
      maxLines: null,
      textAlign: TextAlign.center,
    ).paddingVertical(AppSpace.listRow).center();
  }

  //昵称
  Widget _buildNickName(String nickName) {
    return <Widget>[
      TextWidget.body2(
        nickName,
        color: AppColors.onPrimaryContainer.withOpacity(0.5),
      ).paddingHorizontal(10),
      //定位图标
      Icon(
        Icons.location_on,
        size: 13,
        color: Colors.red.withOpacity(0.8),
      ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  // 消息行
  Widget _buildMsgItem(V2TimMessage msg, {bool isSelf = false}) {
    // 02: 自定义消息
    if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      String? enterUser = UserService.to.profile.nickname;
      return _buildTip(groupLocalMessageText(msg.customElem?.data ?? "",
          members: enterUser));
    }

    // 09: 系统消息
    // https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Class/Group/V2TimGroupTipsElem.html#type
    if (msg.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      String? userIDs = msg.groupTipsElem?.memberList
          ?.map((e) => e?.nickName ?? "")
          .toList()
          .join(",");
      if (userIDs == null) {
        return const SizedBox.shrink();
      }
      String tip = getIMGroupTipsTypeString(
        IMGroupTipsType.values[msg.groupTipsElem?.type ?? 0],
        members: userIDs,
      );
      return _buildTip(tip);
    }

    // 01: 文字消息
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
        if (isSelf == false) _buildNickName(msg.nickName ?? ""),
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
          ).gestures(),
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
    return GetBuilder<ChatAreaController>(
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
    return GetBuilder<ChatAreaController>(
      init: ChatAreaController(
        gid: uniqueTag,
      ),
      id: "chat_area",
      tag: tag,
      builder: (_) {
        DateTime? lastPressedAt;
        return WillPopScope(
          // 防止连续点击两次退出
          onWillPop: () async {
            if (lastPressedAt == null ||
                DateTime.now().difference(lastPressedAt!) >
                    const Duration(seconds: 1)) {
              lastPressedAt = DateTime.now();
              // Loading.toast('再一次退出聊天区');
              return false;
            }
            controller.onQuitGroup(); //退出群聊
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  controller.onQuitGroup(); //退出群聊
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),

              // 标题
              title: controller.title.isNotEmpty
                  ? TextWidget.body2(
                      " ${controller.title} 在线人数 ${controller.onlineCount}",
                      color: AppColors.onPrimaryContainer.withOpacity(0.5),
                    ).paddingHorizontal(10)
                  : const SizedBox.shrink(),
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
          ),
        );
      },
    );
  }
}
