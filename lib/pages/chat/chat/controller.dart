import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common/index.dart';
import 'index.dart';

class ChatController extends GetxController {
  ChatController({
    /// 聊天对象 uid gid
    required this.receiver,

    /// 1: 单聊 2: 群聊
    required this.type,
  });

  /// 用户 uid
  final String receiver;

  /// 聊天类型 1: 单聊 2: 群聊
  final int type;

  /// 会话标题
  String title = '';

  /// 会话
  V2TimConversation? conversation;

  /// 分组信息
  V2TimGroupInfo? group;

  /// 人员列表
  List<V2TimGroupMemberFullInfo?>? membersList;

  // 单聊对方用户数据
  UserProfileModel user = UserProfileModel();

  // 是否是群聊
  bool get isGroup => type == ConversationType.V2TIM_GROUP;

  // 是否群主
  bool get isOwner => group?.owner == UserService.to.id;

  // 聊天输入栏 key
  GlobalKey<ChatBarWidgetState> chatBarKey = GlobalKey();

  // 消息列表
  List<V2TimMessage> messageList = [];

  /// 聊天条数
  final int _limit = 20;

  /// 是否还有更多
  bool _noMore = false;

  /// 最后一条消息 id
  String? _lastMsgID;

  // 刷新控制器
  final RefreshController refreshController = RefreshController();

  /// 聊天页面滚动控制器
  final ScrollController scrollController = ScrollController();

  /// 聊天页面 GlobalKey
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // 群信息编辑面板
  TextEditingController groupNameTextEditingController =
      TextEditingController();

  ////////////////////////////////////////////////////////////////////

  // 拉取群信息
  Future<void> _loadGroupInfo() async {
    if (isGroup) {
      // 群信息
      group = await IMService.to.manager.getGroup(receiver);

      // 成员列表  只有群管理才能拉取成员列表？
      V2TimGroupMemberInfoResult groupMember = await IMService.to.manager
          .getGroupMemberList(gid: receiver, nextSeq: "0");
      membersList = groupMember.memberInfoList;

      // 标题
      title = group?.groupName ?? '';

      // 组名称文字编辑器
      groupNameTextEditingController.text = title;

      update(['chat', 'group_setting_view']);
    }
  }

  // 初始数据
  _initData() async {
    // 会话 cid
    final prefix = isGroup ? 'group_' : 'c2c_';
    try {
      // 会话数据
      conversation =
          await IMService.to.manager.getConversation(prefix + receiver);
      user.nickname = conversation?.showName ?? user.nickname;

      // 标题
      title = user.nickname ?? '';

      update(['chat']);

      // 拉取分组信息
      await _loadGroupInfo();

      // 设置已读
      if ((conversation?.unreadCount ?? 0) > 0) _setMessageAsRead();

      // 获取消息列表
      if (messageList.isEmpty) _getMessageList();

      update(['chat']);
    } catch (error) {
      // Loading.toast(LocaleKeys.chatErrorInit.tr);

      // 显示错误信息
      try {
        String? showName =
            isGroup ? group?.groupName ?? '' : user.nickname ?? '';
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

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  /// 获取消息列表
  Future<void> _getMessageList() async {
    // 获取消息列表
    final result = await IMService.to.manager.getMessageList(
      uid: !isGroup ? conversation?.userID : null,
      gid: isGroup ? conversation?.groupID : null,
      count: _limit,
      lastMsgID: _lastMsgID,
    );
    _addMessages(result, true);
    update(['messageList']);

    // 是否还有更多
    _noMore = result.length < _limit;
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

  /// 设置消息已读
  void _setMessageAsRead() async {
    await IMService.to.manager.setMessageAsRead(
      uid: !isGroup ? conversation?.userID : null,
      gid: isGroup ? conversation?.groupID : null,
    );
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
      final receiver = isGroup ? conversation?.groupID : conversation?.userID;
      V2TimMessage result = await IMService.to.manager.sendMessage(
        id: id,
        uid: !isGroup ? receiver : null,
        gid: isGroup ? receiver : null,
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

  // 当前会话删除错误消息
  Future<void> _deleteMessages(String msgID) async {
    if (msgID.isEmpty) return;

    messageList.removeWhere((element) => element.id == msgID);

    update(["messageList"]);
  }

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

  ////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////

  /// 监听到直播间新消息
  void onRecvNewMessage(V2TimMessage data) {
    if (data.userID != receiver && data.groupID != receiver) return;
    _addMessages([data]);
    _setMessageAsRead(); //直播间不支持
    update(['messageList']);
  }

  /// 监听到更新消息
  void onRecvModifyMessage(V2TimMessage data) {
    if (data.userID != receiver && data.groupID != receiver) return;
    _modifyMessage(data);
    _setMessageAsRead(); //直播间不支持
    update(['messageList']);
  }

  // 监听到群信息更新
  Future<void> onRecvChatGroupInfoChanged(
      [List<V2TimGroupMemberInfo>? membersInfo]) async {
    await _loadGroupInfo();
  }

  ////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////

  // 关闭聊天窗口
  void onChatClose() {
    Get.back();
  }

  // 关闭聊天栏
  void onCloseChatBar() {
    chatBarKey.currentState?.onClose();
    update(["chat"]);
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

  // 重新发送消息
  Future<void> onReSend(V2TimMessage msg) async {
    if (msg.msgID == null) return;

    // 重新发送
    final V2TimMessage result =
        await IMService.to.manager.reSendMessage(msgID: msg.msgID!);

    // 更新状态
    msg.status = result.status;

    // 更新消息列表
    _modifyMessage(msg);

    update(["messageList"]);
  }

  // 组信息打开
  void onGroupSettingOpen() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // 修改群名称
  Future<void> onGroupNameChanged(String groupName) async {
    // 群组形态包括 Public（公开群），
    // Private（即 Work，好友工作群），
    // ChatRoom（即 Meeting，会议群），
    // AVChatRoom（音视频聊天室），
    // BChatRoom（在线成员广播大群）和社群（Community）
    await IMService.to.manager.setGroup(V2TimGroupInfo(
      groupID: receiver,
      groupType: GroupType.Work,
      groupName: groupName,
    ));

    Get.back();
  }

  // 群聊邀请
  Future<void> onGroupMemberAdd() async {
    var result = await Get.toNamed(RouteNames.chatChatFindUser);
    if (result == null || result.isEmpty) return;
    List<UserModel> selectedUsers = result as List<UserModel>;
    List<String> userIDs = selectedUsers.map((e) => e.id ?? "").toList();
    await IMService.to.manager.groupMemberInvite(
      gid: receiver,
      userIDs: userIDs,
    );
  }

  // 群踢人
  Future<void> onGroupMemberKick(String userID) async {
    ActionDialog.normal(
      context: Get.context!,
      title: const Text("移除成员"), //你确定要移除
      content: Text("你确定要移除 $userID"),
      confirm: Text(LocaleKeys.commonBottomConfirm.tr),
      confirmBackgroundColor: Colors.red,
      onConfirm: () async {
        await IMService.to.manager
            .groupMemberKick(gid: receiver, memberIDs: [userID]);
      },
    );
  }

  // 退出群聊
  // 群主不可以退群，只能 解散群组。
  Future<void> onQuitGroup() async {
    Get.back();
    await IMService.to.manager.quitGroup(receiver);
    Get.back();
  }

  // 解散群组
  Future<void> onDismissGroup() async {
    Get.back();
    await UserApi.chatDeleteGroup(receiver, UserService.to.id);
  }
}
