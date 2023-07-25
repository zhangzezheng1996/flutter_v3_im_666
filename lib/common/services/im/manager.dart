import 'package:flutter/foundation.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_add_opt_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/offlinePushInfo.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

import '../../index.dart';

/// tim 功能包装类
class IMManager {
  /// IM SDK 主核心类
  final V2TIMManager _manager = TencentImSDKPlugin.v2TIMManager;

  /// IM SDK 监听器
  late V2TimSDKListener _sdkListener;

  /// 群组监听器
  late V2TimGroupListener _groupListener;

  /// 消息监听器
  late V2TimAdvancedMsgListener _messageListener;

  /// 会话监听器
  late V2TimConversationListener _conversationListener;

  /////////////////////////////////////////////////////////////////////

  /// 初始化
  /// [sdkListener] IM SDK 监听器
  Future<void> init({
    required V2TimSDKListener sdkListener,
    required V2TimGroupListener groupListener,
    required V2TimAdvancedMsgListener messageListener,
    required V2TimConversationListener conversationListener,
  }) async {
    _sdkListener = sdkListener;
    _groupListener = groupListener;
    _messageListener = messageListener;
    _conversationListener = conversationListener;

    try {
      // 初始化 SDK
      await _manager.initSDK(
        // 应用ID，可在控制台中获取
        sdkAppID: Constants.timAppID,

        // 打印日志等级
        loglevel: kDebugMode
            ? LogLevelEnum.V2TIM_LOG_DEBUG
            : LogLevelEnum.V2TIM_LOG_NONE,
        listener: _sdkListener,
      );

      // 群组监听
      _manager.setGroupListener(
        listener: _groupListener,
      );

      // 消息监听
      _manager.v2TIMMessageManager.addAdvancedMsgListener(
        listener: _messageListener,
      );

      // 会话监听
      _manager.v2ConversationManager.addConversationListener(
        listener: _conversationListener,
      );
    } catch (error) {
      log(error);
    }
  }

  /// 释放监听
  Future<void> cleanListener() async {
    await _manager.v2TIMMessageManager
        .removeAdvancedMsgListener(listener: _messageListener);
    await _manager.v2ConversationManager
        .removeConversationListener(listener: _conversationListener);
    await _manager.removeGroupListener(listener: _groupListener);
  }

  /// 关闭
  Future<void> close() async {
    // 释放监听
    await cleanListener();
    // 反初始化 SDK
    await _manager.unInitSDK();
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  /// 用户 User

  /// 用户登录
  /// ```
  /// https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Api/V2TIMManager/login.html
  /// 登陆时票据过期：login 函数的回调会返回 ERR_USER_SIG_EXPIRED：6206 错误码，此时生成新的 userSig 重新登录。
  /// 在线时票据过期：用户在线期间也可能收到 V2TIMListener -> onUserSigExpired 回调，此时也是需要您生成新的 userSig 并重新登录。
  /// 在线时被踢下线：用户在线情况下被踢，SDK 会通过 V2TIMListener -> onKickedOffline 回调通知给您，此时可以 UI 提示用户，并再次调用 login() 重新登录。
  /// ```
  Future<bool> login({
    required String userID,
    required String userSig,
  }) async {
    var result = await _manager.login(
      userID: userID,
      userSig: userSig,
    );
    return result.code == 0;
  }

  /// 用户登出
  Future<void> logout() async {
    await _manager.logout();
  }

  /// 获取用户信息
  Future<V2TimUserFullInfo> getUserinfo(String uid) async {
    try {
      final result = await _manager.getUsersInfo(userIDList: [uid]);
      if (result.code != 0 && (result.data ?? []).isNotEmpty) throw result.desc;
      return result.data!.first;
    } catch (error) {
      rethrow;
    }
  }

  /// 获取登录用户信息
  Future<V2TimUserFullInfo?> getLoginUser() async {
    var result = await _manager.getLoginUser();
    if (result.code != 0 && result.data != null) throw result.desc;
    return await getUserinfo(result.data!);
  }

  /// 获取登录成功的用户的状态
  /// 用户的登录状态 1:已登录 2:登录中 3:无登录
  Future<int?> getLoginStatus() async {
    V2TimValueCallback<int> getLoginStatusRes =
        await TencentImSDKPlugin.v2TIMManager.getLoginStatus();
    if (getLoginStatusRes.code == 0) {
      int? status = getLoginStatusRes.data;
      return status;
    }
    return -1;
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  /// 会话 Conversation

  /// 会话列表
  /// [count] 拉取的会话数量
  /// [nextSeq] 从哪个会话开始拉取，0 表示从最新的会话开始拉取
  Future<V2TimConversationResult> getConversationList({
    int count = 100,
    String nextSeq = '0',
  }) async {
    try {
      final result = await _manager.v2ConversationManager.getConversationList(
        count: count,
        nextSeq: nextSeq,
      );
      log("getConversationList -> ${result.desc} ");
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 获取会话指定 cid
  /// [cid] 会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
  Future<V2TimConversation> getConversation(String cid) async {
    //  getConversationtRes.data?.conversationID;//会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
    //  getConversationtRes.data?.draftText;//草稿信息
    //  getConversationtRes.data?.draftTimestamp;//草稿编辑时间，草稿设置的时候自动生成。
    //  getConversationtRes.data?.faceUrl;//会话展示头像，群聊头像：群头像；单聊头像：对方头像。
    //  getConversationtRes.data?.groupAtInfoList;//群会话 @ 信息列表，通常用于展示 “有人@我” 或 “@所有人” 这两种提醒状态。
    //  getConversationtRes.data?.groupID;//当前群聊 ID，如果会话类型为群聊，groupID 会存储当前群的群 ID，否则为 null。
    //  getConversationtRes.data?.groupType;//当前群聊类型，如果会话类型为群聊，groupType 为当前群类型，否则为 null。
    //  getConversationtRes.data?.isPinned;//会话是否置顶
    //  getConversationtRes.data?.lastMessage;//会话最后一条消息
    //  getConversationtRes.data?.orderkey;//会话排序字段
    //  getConversationtRes.data?.recvOpt;//消息接收选项
    //  getConversationtRes.data?.showName;//会话展示名称，群聊会话名称优先级：群名称 > 群 ID；单聊会话名称优先级：对方好友备注 > 对方昵称 > 对方的 userID。
    //  getConversationtRes.data?.type;//会话类型，分为 C2C（单聊）和 Group（群聊）。
    //  getConversationtRes.data?.unreadCount;//会话未读消息数，直播群（AVChatRoom）不支持未读计数，默认为 0。
    //  getConversationtRes.data?.userID;//对方用户 ID，如果会话类型为单聊，userID 会存储对方的用户 ID，否则为 null。

    try {
      final result = await _manager.v2ConversationManager.getConversation(
        conversationID: cid,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 删除会话
  /// [cid] 会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
  Future<void> deleteConversation(String cid) async {
    try {
      final result = await _manager.v2ConversationManager.deleteConversation(
        conversationID: cid,
      );
      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  /// 消息 Message
  /// 获取未读消息数
  Future<int> getUnreadCount() async {
    var count = 0;
    try {
      final result =
          await _manager.v2ConversationManager.getTotalUnreadMessageCount();
      if (result.code != 0) {
        count = 0;
      } else {
        count = result.data ?? 0;
      }
    } catch (error) {
      count = 0;
    }
    return count;
  }

  /// 获取消息历史
  Future<List<V2TimMessage>> getMessageList({
    String? uid,
    String? gid,
    int count = 20,
    String? lastMsgID,
  }) async {
    try {
      late V2TimValueCallback<List<V2TimMessage>> result;
      if (gid != null) {
        result = await _manager.v2TIMMessageManager.getGroupHistoryMessageList(
          groupID: gid,
          count: count,
          lastMsgID: lastMsgID,
        );
      } else {
        result = await _manager.v2TIMMessageManager.getC2CHistoryMessageList(
          userID: uid ?? '',
          count: count,
          lastMsgID: lastMsgID,
        );
      }
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 设置消息已读
  Future<void> setMessageAsRead({
    String? uid,
    String? gid,
  }) async {
    try {
      late V2TimCallback result;
      if (gid != null) {
        result = await _manager.v2TIMMessageManager.markGroupMessageAsRead(
          groupID: gid,
        );
      } else {
        result = await _manager.v2TIMMessageManager.markC2CMessageAsRead(
          userID: uid ?? '',
        );
      }

      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  /// 创建文字消息
  /// [text] 文字内容
  Future<V2TimMsgCreateInfoResult> createTextMessage(String text) async {
    try {
      final result = await _manager.v2TIMMessageManager.createTextMessage(
        text: text,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 创建图片消息
  /// [path] 图片路径
  Future<V2TimMsgCreateInfoResult> createImageMessage(String path) async {
    try {
      final result = await _manager.v2TIMMessageManager.createImageMessage(
        imagePath: path,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 创建语音消息
  /// [path] 语音路径
  /// [duration] 语音时长
  Future<V2TimMsgCreateInfoResult> createSoundMessage(
    String path, {
    int? duration,
  }) async {
    try {
      final result = await _manager.v2TIMMessageManager.createSoundMessage(
        duration: duration ?? 0,
        soundPath: path,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 发送消息
  /// [id] 消息 ID
  /// [uid] 用户 ID
  /// [gid] 群组 ID
  /// [pushInfo] 离线推送信息
  Future<V2TimMessage> sendMessage({
    required String id,
    String? uid,
    String? gid,
    OfflinePushInfo? pushInfo,
  }) async {
    try {
      final result = await _manager.v2TIMMessageManager.sendMessage(
        id: id,
        groupID: gid ?? '',
        receiver: uid ?? '',
        offlinePushInfo: pushInfo,
      );
      if (result.code != 0 && result.data != null) throw result.data!;
      if (result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 重新发送消息
  /// [msgID] 消息 msgID
  Future<V2TimMessage> reSendMessage({
    required String msgID,
  }) async {
    try {
      final result = await _manager.v2TIMMessageManager.reSendMessage(
        msgID: msgID,
      );
      if (result.code != 0 && result.data != null) throw result.data!;
      if (result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  /// 群组 Group

  /// 保存群本地消息
  /// [gid] 群组 ID
  /// [data] 消息内容
  /// [sender] 发送者 ID
  Future<V2TimMessage> sendGroupLocalMessage({
    required String gid,
    required String data,
    required String sender,
  }) async {
    try {
      final result =
          await _manager.v2TIMMessageManager.insertGroupMessageToLocalStorage(
        data: data,
        groupID: gid,
        sender: sender,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 创建work群
  /// [name] 群名称
  /// [memberList] 群成员列表
  Future<String> createGroup({
    //群名称
    required String name,
    //群成员列表
    List<UserModel> memberList = const [],
  }) async {
    final v2ChatUserList = <V2TimGroupMember>[];
    v2ChatUserList.add(V2TimGroupMember(
      // 群主
      role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_OWNER,
      userID: UserService.to.profile.id!,
    ));
    for (var element in memberList) {
      if ((element.id ?? '').isEmpty) continue;
      // 群成员
      v2ChatUserList.add(V2TimGroupMember(
        role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER,
        userID: element.id!,
      ));
    }
    try {
      final result = await _manager.v2TIMGroupManager.createGroup(
        groupType: GroupType.Work,
        groupName: name,
        addOpt: GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY,
        memberList: v2ChatUserList,
      );
      if (result.code != 0) throw result.desc;
      return result.data ?? '';
    } catch (error) {
      rethrow;
    }
  }

  /// 获取群信息
  /// [gid] 群组 ID
  Future<V2TimGroupInfo?> getGroup(String gid) async {
    try {
      final result = await _manager.v2TIMGroupManager.getGroupsInfo(
        groupIDList: [gid],
      );
      if (result.code != 0) throw result.desc;
      if ((result.data ?? []).isEmpty) return null;
      return result.data?.first.groupInfo;
    } catch (error) {
      rethrow;
    }
  }

  /// 修改群信息
  /// [info] 群信息
  Future<void> setGroup(V2TimGroupInfo info) async {
    try {
      final result = await _manager.v2TIMGroupManager.setGroupInfo(info: info);
      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  /// 加入群
  /// [gid] 群组 ID

  /// 退群
  /// [gid] 群组 ID
  Future<void> quitGroup(String gid) async {
    try {
      final result = await _manager.quitGroup(groupID: gid);
      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  /// 解散群
  /// [gid] 群组 ID
  Future<void> dismissGroup(String gid) async {
    try {
      final result = await _manager.dismissGroup(groupID: gid);
      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  /// 获取群成员列表
  /// [gid] 群组 ID
  /// [nextSeq] 下一次拉取的 seq
  /// [filter] 群成员筛选类型
  Future<V2TimGroupMemberInfoResult> getGroupMemberList({
    required String gid,
    required String nextSeq,
    GroupMemberFilterTypeEnum filter =
        GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
  }) async {
    try {
      final result = await _manager.v2TIMGroupManager.getGroupMemberList(
        filter: filter,
        groupID: gid,
        nextSeq: nextSeq,
        count: 50,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 获取群成员信息
  /// [gid] 群组 ID
  /// [memberIDs] 成员 ID 列表
  Future<List<V2TimGroupMemberFullInfo>> getGroupMembersInfo({
    required String gid,
    List<String> memberIDs = const [],
  }) async {
    try {
      final result = await _manager.v2TIMGroupManager.getGroupMembersInfo(
        groupID: gid,
        memberList: memberIDs,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }

  /// 群踢人
  /// [gid] 群组 ID
  /// [memberIDs] 成员 ID 列表
  Future<void> groupMemberKick({
    required String gid,
    List<String> memberIDs = const [],
  }) async {
    try {
      final result = await _manager.v2TIMGroupManager.kickGroupMember(
        groupID: gid,
        memberList: memberIDs,
      );
      if (result.code != 0) throw result.desc;
    } catch (error) {
      rethrow;
    }
  }

  /// 群邀请
  Future<List<V2TimGroupMemberOperationResult>> groupMemberInvite({
    required String gid,
    List<String> userIDs = const [],
  }) async {
    try {
      final result = await _manager.v2TIMGroupManager.inviteUserToGroup(
        groupID: gid,
        userList: userIDs,
      );
      if (result.code != 0 || result.data == null) throw result.desc;
      return result.data!;
    } catch (error) {
      rethrow;
    }
  }
}
