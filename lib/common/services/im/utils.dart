import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../pages/index.dart';
import '../../index.dart';

/// 显示提示(提示工具)
void showTip(String message) {
  Get.showSnackbar(GetSnackBar(
    message: message,
    duration: const Duration(seconds: 2),
  ));
}

//  直播间提示（进入直播间 发送）（提示工具）
void showChatAreaTipSnackBar(String message) {
  //关闭之前的SnackBar
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(message),
      ],
    ),
    duration: const Duration(seconds: 1),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(10),
    )),
  ));
}

/// String   接收发送的群发送的自定义消息消息文字
String groupLocalMessageText(String customType, {String? members}) {
  IMCustomMessageType type = IMCustomMessageType.values.firstWhere(
    (element) => element.toString() == customType,
  );

  switch (type) {
    case IMCustomMessageType.groupCreate:
      return "加入聊天" " $members";
    case IMCustomMessageType.enter:
      return "$members" "加入聊天";
    default:
  }

  return "";
}

/// String   群消息类型文字
String getIMGroupTipsTypeString(IMGroupTipsType type, {String? members}) {
  switch (type) {
    case IMGroupTipsType.enter:
      return "$members 来了 ";
    case IMGroupTipsType.invited:
      return "$members 被邀请入群 ";
    case IMGroupTipsType.leave:
      return "$members 离开了";
    case IMGroupTipsType.kicked:
      return "$members 被踢出群 ";
    case IMGroupTipsType.setAdmin:
      return "$members 设置管理员 ";
    case IMGroupTipsType.cancelAdmin:
      return "$members 取消管理员";
    case IMGroupTipsType.groupInfoChange:
      return "$members 群资料变更 ";
    case IMGroupTipsType.memberInfoChange:
      return "$members 群成员资料变更";
    default:
      return "";
  }
}

/// app 前台后台消息提示
void showAppNotice(V2TimMessage data, {bool isInApp = true}) {
  // 内容
  String subtitle = "";
  if (data.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
    subtitle = (data.textElem?.text ?? "").replaceAll(RegExp(r'\n'), "");
  }

  // 聊天类型 1: 单聊 2: 群聊
  int type = data.groupID == null ? 1 : 2;

  // 发送人
  String username = type == 1 ? data.nickName ?? "" : data.nickName ?? "";

  // 聊天ID
  String chatId = type == 1 ? data.sender ?? "" : data.groupID ?? "";

  //默认群头像
  String defaultGroupAvatar = AssetsImages.defaultGroupAvatarPng;

  // 个人头像url
  String faceUrl = data.faceUrl ?? "";

  // 头像
  Widget avatarWidget = type == 2
      ? Image.asset(defaultGroupAvatar, width: 38, height: 38)
      : AvatarWidget(faceUrl);

  // 标题
  Widget titleWidget = TextWidget.body1(
    type == 1 ? "私信" : "群聊",
    color: AppColors.onPrimaryContainer,
  );

  if (isInApp) {
    showSimpleNotification(
      elevation: 0,
      // slideDismiss: true,
      slideDismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 1),
      // leading: const Text("闪忆"),
      // subtitle: const Text("闪忆...."),
      // trailing: const Text("闪忆...."),
      ListTile(
        onTap: () => onChat(chatId, type),
        //头像
        leading: avatarWidget,
        //标题
        title: titleWidget,
        //副标题
        subtitle: TextWidget.body1("$username : $subtitle",
            color: AppColors.onPrimaryContainer),
        //右侧
        trailing: IconWidget.icon(
          Icons.reply_all_outlined,
          size: 26,
        ),
        //圆角
        shape: const StadiumBorder(
          side: BorderSide(
            // strokeAlign: BorderSide.strokeAlignCenter,
            color: Colors.yellow,
            width: 1,
            style: BorderStyle.solid, //实线
          ),
        ),
        tileColor: AppColors.surfaceVariant,
      ),
      //透明
      background: Colors.transparent,
    );
  } else {
    NoticeService.to.show(
      title: type == 1 ? "私信" : "群聊",
      body: "$username : $subtitle",
      payload: "/chat?uid=$chatId&type=$type",
    );
  }
}

/// chatId开始聊天（跳转【私聊】或者【群聊】）
Future<void> onChat(String chatId, int type) async {
  // 清理堆栈
  Get.until(
    ModalRoute.withName(RouteNames.main),
  );

  // 跳转到聊天界面
  await Get.toNamed(RouteNames.chatChat, arguments: {
    "uid": chatId,
    "type": type,
  });
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
////////////////////////////////获取控制器
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/// 获取聊天 ChatController
Future<ChatController?> chatPageFind(String tag) async {
  if (Get.isRegistered<ChatController>(tag: tag)) {
    ChatController chatController = Get.find<ChatController>(tag: tag);
    return chatController;
  }
  return null;
}

/// 获取聊天区 ChatAreaController
Future<ChatAreaController?> chatAreaPageFind(String tag) async {
  if (Get.isRegistered<ChatAreaController>(tag: tag)) {
    ChatAreaController chatAreaController =
        Get.find<ChatAreaController>(tag: tag);
    return chatAreaController;
  }
  return null;
}

/// 获取会话列表 ChatIndexController
Future<ChatIndexController?> chatIndexPageFind() async {
  if (Get.isRegistered<ChatIndexController>()) {
    ChatIndexController chatIndexController = Get.find<ChatIndexController>();
    return chatIndexController;
  }
  return null;
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/// 聊天界面收到新消息    V2TimMessage
Future<void> onRecvNewMessage(V2TimMessage data) async {
  /// 是否打开程序
  final isResumed = ConfigService.to.appLifecycle == AppLifecycleState.resumed;

  /// 消息发送者
  String? tag = data.groupID ?? data.sender;

  //先处理群组消息
  var chatController = await chatPageFind(tag!); //只要不在聊天界面，就找不到控制器
  if (chatController != null) {
    chatController.onRecvNewMessage(data); //聊天界面内处理消息
    return;
  }
  //处理直播间消息
  var chatAreaController = await chatAreaPageFind(tag);
  if (chatAreaController != null) {
    chatAreaController.onRecvNewMessage(data); //聊天界面内处理消息
    return;
  }
  //消息未被任何控制器处理
  if (isResumed) {
    //如果程序在前台
    showAppNotice(data); //app内消息提示
    // return true;
  } else {
    //如果程序在后台
    showAppNotice(data, isInApp: false); //app内消息提示
    // return false;
  }
}

/// 聊天界面群组信息（进群，退群，信息变更等）更新   V2TimGroupMemberInfo
Future<void> onRecvGroupInfoChanged(
    String tag, List<V2TimGroupMemberInfo> members) async {
  // work 群组有效
  var chatController = await chatPageFind(tag);
  if (chatController != null) {
    await chatController.onRecvChatGroupInfoChanged(members);
    // showTip(getIMGroupTipsTypeString(
    //   IMGroupTipsType.enter,
    //   members: members.map((e) => e.nickName ?? "").toList().join(","),
    // ));
  }
  // AvChatRoom 群组有效
  var chatAreaController = await chatAreaPageFind(tag);
  if (chatAreaController != null) {
    chatAreaController.onRecvChatGroupInfoChanged(members);
  }
}

/// 关闭聊天界面
Future<void> chatPageGroupClose(tag) async {
  ChatController? chatController = await chatPageFind(tag);
  chatController?.onChatClose();
}

/////////////////////////////////////////////////////////////////////

/// 更新聊天会话列表变化
Future<void> onReceiveConversationChanged(List<V2TimConversation> data) async {
  var controller = await chatIndexPageFind();
  controller?.onReceiveConversationChanged(data);
}

/// 删除会话
Future<void> onReceiveConversationDeleted(List<V2TimConversation> data) async {
  var controller = await chatIndexPageFind();
  controller?.onReceiveConversationDeleted(data);
}

/// 删除会话根据 cid
Future<void> onReceiveDeleteConversationByCid(String cid) async {
  var controller = await chatIndexPageFind();
  controller?.onDeleteConversationByCid(cid);
}

//////////////////////////////////////////////////////////////////////////
/// 退出删除会话（群聊）
Future<void> onReceiveQuitDeleteConversationByCid(String gid) async {
  //退出删除列表会话
  var controller = await chatIndexPageFind();
  controller?.onDeleteConversationByCid("group_$gid");
}
