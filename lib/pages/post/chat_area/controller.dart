import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

import '../../../common/index.dart';
import 'widgets/chat_bar.dart';

class ChatAreaController extends GetxController {
  ChatAreaController({
    required this.gid,
  });

  ///  gid
  final String gid;

  // 刷新控制器
  final RefreshController refreshController = RefreshController();

  /// 聊天页面滚动控制器
  final ScrollController scrollController = ScrollController();

  // 聊天输入栏 key
  GlobalKey<ChatBarWidgetState> chatBarKey = GlobalKey();

  /// 聊天页面 GlobalKey
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // 群信息编辑面板
  TextEditingController groupNameTextEditingController =
      TextEditingController();

  /// 群名称
  String title = '';

  /// 分组信息
  V2TimGroupInfo? group;

  /// 是否还有更多
  bool _noMore = false;

  /// 最后一条消息 id
  String? _lastMsgID;

  // 是否是群聊
  // bool get isGroup => type == ConversationType.V2TIM_GROUP;

  // 是否群主
  // bool get isOwner => group?.owner == UserService.to.id;

  // 消息列表
  List<V2TimMessage> messageList = [];

  /// 聊天条数
  final int _limit = 20;

  /// 会话
  V2TimConversation? conversation;

  //在线人数Rx
  int? onlineCount = 0;

  // 拉取群信息
  Future<void> _loadGroupInfo() async {
    // 群信息
    group = await IMService.to.manager.getGroup(gid);

    // 成员列表
    // V2TimGroupMemberInfoResult groupMember =
    //     await IMService.to.manager.getGroupMemberList(gid: gid, nextSeq: "0");
    // membersList = groupMember.memberInfoList;

    // 标题
    title = group?.groupName ?? '';

    // 获取在线人数 60 秒 1 次
    // onlineCount = group?.memberCount ?? 0;
    onlineCount = await getGroupOnlineMemberCount(gid);

    // 组名称文字编辑器
    // groupNameTextEditingController.text = titleLarge;

    update(['chat_area', 'group_setting_view']);
  }

  _initData() async {
    // 会话 cid
    const prefix = 'group_';
    try {
      // 会话数据
      conversation = await IMService.to.manager.getConversation(prefix + gid);

      update(["chat_area"]);

      // 拉取分组信息
      await _loadGroupInfo();

      // 设置已读
      // if ((conversation?.unreadCount ?? 0) > 0) _setMessageAsRead();

      // 获取消息列表
      if (messageList.isEmpty) _getMessageList();

      update(["chat_area"]);
    } catch (error) {
      // Loading.toast(LocaleKeys.chatErrorInit.tr);

      // 显示错误信息
      try {
        String? showName = group?.groupName ?? '';
        String? errDesc = error as String?;
        Loading.toast("$showName $errDesc");
      } catch (_) {}

      Get.back();
    }
  }

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
    scrollController.dispose();
    refreshController.dispose();
    groupNameTextEditingController.dispose();
  }

  // 下拉刷新
  void onLoading() {
    if (!_noMore) {
      _getMessageList().then((_) {
        refreshController.loadComplete();
      }).catchError((_) {
        refreshController.loadFailed();
      });
    } else {
      refreshController.loadNoData();
    }
  }

  /// 获取消息列表
  Future<void> _getMessageList() async {
    // 获取消息列表
    final result = await IMService.to.manager.getMessageList(
      gid: gid,
      count: _limit,
      lastMsgID: _lastMsgID,
    );
    _addMessages(result, true);
    update(['messageList']);

    // 是否还有更多
    _noMore = result.length < _limit;
  }

  /// 设置消息已读
  // void _setMessageAsRead() async {
  //   await IMService.to.manager.setMessageAsRead(
  //     gid: gid,
  //   );
  // }

  /// 添加消息
  void _addMessages(List<V2TimMessage> data, [bool isOld = false]) {
    // data 按 timestamp 时间戳 降序
    data.sort((left, right) {
      final rightTimestamp = right.timestamp ?? 0;
      final leftTimestamp = left.timestamp ?? 0;
      return rightTimestamp.compareTo(leftTimestamp);
    });

    // 更新最后一条消息 id
    if (data.isNotEmpty && isOld) _lastMsgID = data.last.msgID;

    // 加入消息列表
    for (var index = 0; index < data.length; index++) {
      final current = data[index];
      messageList.add(current);
    }
  }

  // 发送消息
  Future<void> _sendMessage(String id, V2TimMessage? message) async {
    if (message == null) return;

    // 消息发送中状态
    message.status = MessageStatus.V2TIM_MSG_STATUS_SENDING;
    // 消息创建者
    message.sender = UserService.to.id;

    // 当前消息加一条记录
    _addMessages([message]);
    update(['messageList']);

    // 开始发送
    try {
      V2TimMessage result = await IMService.to.manager.sendMessage(
        id: id,
        gid: gid,
      );
      // 更新成功消息
      _modifyMessage(result);
    } catch (error) {
      // 无效消息记录删除
      if (error is String) {
        _deleteMessages(id);
        return Loading.error(error);
      }

      // 发送失败状态
      if (error is! V2TimMessage) return;
      _modifyMessage(error);
    }
    update(['messageList']);
  }

  /// 修改消息
  void _modifyMessage(V2TimMessage? message) {
    // 根据 message?.id 找消息
    final index = messageList.indexWhere((element) {
      return element.id == message?.id;
    });
    if (index < 0) return;

    // 替换消息
    messageList[index] = message!;
  }

  // 当前会话删除错误消息(非本地消息)
  Future<void> _deleteMessages(String msgID) async {
    if (msgID.isEmpty) return;

    messageList.removeWhere((element) => element.id == msgID);

    update(["messageList"]);
  }

  // 删除本地及漫游消息(没用)
  Future<void> _deleteLocalMessages(String msgID) async {
    if (msgID.isEmpty) return;

    // 删除本地及漫游消息
    V2TimCallback deleteMessagesRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .deleteMessages(
            msgIDs: [msgID], // 需要删除的消息id
            webMessageInstanceList: [] // 需要删除的web端消息实例列表
            );
    if (deleteMessagesRes.code == 0) {
      //删除成功
    }

    update(["messageList"]);
  }

  /////////////////////////////////////////////////////////
  /// 监听到新消息
  void onRecvNewMessage(V2TimMessage data) {
    if (data.groupID != gid) return;
    _addMessages([data]);
    // _setMessageAsRead(); //直播间不支持
    update(['messageList']);
  }

  /// 监听到更新消息
  void onRecvModifyMessage(V2TimMessage data) {
    if (data.groupID != gid) return;
    _modifyMessage(data);
    // _setMessageAsRead(); //直播间不支持
    update(['messageList']);
  }

  // 监听到AVChatRoom群信息更新
  Future<void> onRecvChatGroupInfoChanged(
      [List<V2TimGroupMemberInfo>? members]) async {
    //进群提示
    showChatAreaTipSnackBar(getIMGroupTipsTypeString(
      IMGroupTipsType.enter,
      members: members?.map((e) => e.nickName ?? "").toList().join(","),
    ));

    //进入聊天区的时候发送一条消息
    // if (members != null) {
    //   // 发送本地进群消息(自定义消息)
    //   V2TimMessage msg = await IMService.to.manager.sendGroupLocalMessage(
    //     gid: gid, //群聊id
    //     sender: UserService.to.id, //发送者id
    //     data: IMCustomMessageType.enter.toString(), //自定义消息类型
    //   );
    //   //延迟5秒删除本地消息这条
    //   Timer(const Duration(seconds: 5), () {
    //     _deleteLocalMessages(msg.msgID ?? "");
    //   });
    // }
    // 更新群信息
    //打印result

    await _loadGroupInfo();
  }

  /////////////////////////////////////////////////////////
  void onTap() {}

  // 退出群聊
  // 群主不可以退群，只能 解散群组。
  Future<void> onQuitGroup() async {
    Get.back();
    //关闭之前的SnackBar
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
    await IMService.to.manager.quitGroup(gid); //此账号退出当前群聊
    Get.back();
  }

  // 获取在线人数
  //目前仅直播群（AVChatRoom）支持获取群在线人数。
  //SDK 调用频率限制为 60 秒 1 次。
  Future<int?> getGroupOnlineMemberCount(String gid) async {
    // 获取指定群在线人数
    V2TimValueCallback<int> getGroupOnlineMemberCountRes =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupOnlineMemberCount(
              groupID: gid,
            );
    if (getGroupOnlineMemberCountRes.code == 0) {
      // 查询成功
      return getGroupOnlineMemberCountRes.data! + 1; // 查询到的群在线人数
    }
    return 0;
  }

  // 发送文字消息
  Future<void> onTextSend(String msg) async {
    final text = msg.trim();
    if (text.isEmpty) return;

    // 调用 sdk 创建一条消息
    final result = await IMService.to.manager.createTextMessage(text);

    // 根据返回值发送消息
    _sendMessage(result.id ?? '', result.messageInfo);
  }

  // 关闭聊天栏
  void onCloseChatBar() {
    chatBarKey.currentState?.onClose();
    update(["chat_area"]);
  }
}
