import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';

import '../../../common/index.dart';

class ChatIndexController extends GetxController {
  ChatIndexController();

  // 刷新控制器
  final RefreshController refreshController = RefreshController(
      // initialRefresh: true,
      );

  /// 页尺寸
  /// 分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
  final int _limit = 20;

  /// 当前会话人员列表
  List<V2TimConversation?> items = [];

  /// count	分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
  int listCount = 20;

  /// nextSeq	分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
  String listNextSeq = '0';

  _initData() async {
    await _loadSearch("", true);
    update(["chat_index"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    //缓存为空拉取数据
    _initData();
  }

  @override
  onClose() {
    super.onClose();
    refreshController.dispose(); // 释放
  }

  /// 拉取数据
  /// isRefresh 是否是刷新
  Future<bool> _loadSearch(String keyword, bool isRefresh) async {
    // 拉取数据
    V2TimConversationResult result =
        await IMService.to.manager.getConversationList(
      count: _limit,
      nextSeq: listNextSeq,
    );
    var conversationList = result.conversationList ?? [];

    // 检查群组有效性
    for (var item in conversationList) {
      if (item!.type == ConversationType.V2TIM_GROUP) {
        try {
          V2TimGroupMemberInfoResult groupMemberInfoResult =
              await IMService.to.manager.getGroupMemberList(
            gid: item.groupID!,
            nextSeq: "0",
          );
          log(groupMemberInfoResult);
        } catch (e) {
          try {
            String? groupName = item.showName;
            String? errDesc = e as String?;
            Loading.toast("$groupName $errDesc");
          } catch (_) {}
          // 不强制删除群聊会话
          // onDeleteConversationByCid(item.conversationID);
        }
      }
    }

    // 下拉刷新
    if (isRefresh) {
      listNextSeq = "0"; // 重置第一页 "0"
      items.clear(); // 清空数据
    }

    // 有数据
    if (conversationList.isNotEmpty) {
      // 页数+1
      listNextSeq = result.nextSeq ?? "0";

      // 添加数据
      items.addAll(conversationList);

      // 保存离线数据
      // Storage().setJson(Constants.storageChatConversations, items);
    }

    // 是否空
    return conversationList.isEmpty;
  }

  // 上拉载入新数据
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空
        var isEmpty = await _loadSearch("", false);

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
    update(["chat_index"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      listNextSeq = "0";
      await _loadSearch("", true);
      refreshController.refreshCompleted();
      refreshController.resetNoData();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
    update(["chat_index"]);
  }

  // 创建群聊开始聊天
  Future<void> _startChat(List<UserModel> selectedUsers) async {
    if (selectedUsers.isEmpty) {
      return;
    }

    try {
      // 单聊
      if (selectedUsers.length == 1) {
        // 用户 uid
        String uid = selectedUsers.first.id!;

        // tim 数据准备
        // List<String> uids =
        //     selectedUsers.map((e) => null == e.id ? "" : e.id!).toList();
        // await UserApi.chatPrepare(uids);

        // 前去聊天
        Get.toNamed(RouteNames.chatChat, arguments: {
          "uid": uid,
          "type": ConversationType.V2TIM_C2C.toString(),
        });
      }

      // 群聊
      else if (selectedUsers.length > 1) {
        // tim 数据准备
        // List<String> uids =
        //     selectedUsers.map((e) => null == e.id ? "" : e.id!).toList();
        // await UserApi.chatPrepare(uids);

        //TODO: 获取聊天用户的id的信息保存到服务器

        // 群名称
        // var groupName = uids.join(",");
        var groupName = "${UserService.to.profile.username}的群聊 ";

        // 创建work群
        final gid = await IMService.to.manager.createGroup(
          name: groupName,
          memberList: selectedUsers,
          //群头像
        );
        //保存到自己服务器  Private类型的群聊
        await PostApi.saveChatGroup(
            gid, groupName, UserService.to.id, "Private");

        // 发送本地欢迎消息(自定义消息)
        await IMService.to.manager.sendGroupLocalMessage(
          gid: gid, //群聊id
          sender: UserService.to.id, //发送者id
          data: IMCustomMessageType.groupCreate.toString(), //自定义消息类型
        );

        // 进入聊天室
        Get.toNamed(RouteNames.chatChat, arguments: {
          "uid": gid, //群聊id
          "type": ConversationType.V2TIM_GROUP.toString(), //群聊类型
        });
      }
    } catch (e) {
      Loading.error("创建聊天失败");
    }

    update(['chat_index']);
  }

  ////////////////////////////////////////////////////////////////////

  // 监听到会话变化
  void onReceiveConversationChanged(List<V2TimConversation> data) {
    for (var item in data) {
      var index =
          items.indexWhere((e) => e!.conversationID == item.conversationID);
      if (index == -1) {
        items.add(item);
      } else {
        items[index] = item;
      }
    }
    // 会话按时间 lastMessage.timestamp 倒序排列
    items.sort(
        (a, b) => b!.lastMessage!.timestamp! - a!.lastMessage!.timestamp!);
    update(['chat_index']);
  }

  // 分组删除
  void onReceiveConversationDeleted(List<V2TimConversation> data) {
    items.removeWhere((e) =>
        data.map((e) => e.conversationID).toList().contains(e!.conversationID));
    update(['chat_index']);
  }

  //////////////////////////////////////////////////////////////////

  // 去选择用户界面
  Future<void> onFindUser() async {
    var result = await Get.toNamed(RouteNames.chatChatFindUser);
    if (result == null || result.isEmpty) return;
    List<UserModel> selectedUsers = result as List<UserModel>;
    await _startChat(selectedUsers);
  }

  // 聊天
  Future<void> onChat(String uid, int type) async {
    await Get.toNamed(RouteNames.chatChat, arguments: {
      "uid": uid,
      "type": type,
    });
  }

  // 删除会话
  Future<void> onDeleteConversationByCid(String cid) async {
    await IMService.to.manager.deleteConversation(cid);
    items.removeWhere((element) => element!.conversationID == cid);
    update(['chat_index']);
  }
}
