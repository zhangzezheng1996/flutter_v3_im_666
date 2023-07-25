import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';

import '../../../../common/index.dart';
import '../index.dart';

class GroupSettingView extends GetView<ChatController> {
  const GroupSettingView({super.key, required this.uniqueTag});

  final String uniqueTag;

  @override
  String? get tag => uniqueTag;

  // 群成员列表
  Widget _buildGroupMembers() {
    List<Widget> ws = [];

    // 群里成员
    if (controller.membersList != null) {
      ws.addAll(controller.membersList!
          .map((V2TimGroupMemberFullInfo? item) => Chip(
                avatar: item!.faceUrl == null
                    ? InitialsWidget(item.nickName ?? "")
                    : AvatarWidget(
                        item.faceUrl,
                        size: const Size(18, 18),
                      ),
                label: TextWidget.body2(item.nickName ?? ""),
                labelPadding: const EdgeInsets.only(right: 5),
                padding: EdgeInsets.zero,
                onDeleted:
                    (controller.isOwner && item.userID != UserService.to.id)
                        ? () {
                            controller.onGroupMemberKick(item.userID);
                          }
                        : null,
              ))
          .toList());
    }

    // 加成员
    ws.add(_buildMemberAdd());

    return controller.membersList == null
        ? const SizedBox.shrink()
        : Wrap(
            spacing: 2,
            runSpacing: 0,
            children: ws,
          );
  }

  // 群名称修改
  Widget _buildGroupInfo() {
    return <Widget>[
      // 标题
      const TextWidget.title3("群聊名称"),
      // 输入框
      controller.isOwner
          ? InputWidget.textBorder(
              controller: controller.groupNameTextEditingController,
              onSubmitted: (value) {
                controller.onGroupNameChanged(value);
              },
            )
          : TextWidget.body2(controller.groupNameTextEditingController.text),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .paddingVertical(AppSpace.listRow);
  }

  // 群成员添加按钮
  Widget _buildMemberAdd() {
    if (!controller.isOwner) {
      return const SizedBox.shrink();
    }
    return ButtonWidget.text(
      "+ 添加成员",
      onTap: controller.onGroupMemberAdd,
    );
  }

  // 退出群、解散群 按钮
  Widget _buildGroupExit() {
    return ButtonWidget.primary(
      controller.isOwner ? "解散群聊" : "退出群聊",
      onTap: controller.isOwner
          ? controller.onDismissGroup
          : controller.onQuitGroup,
      height: 30,
    ).paddingTop(100);
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: <Widget>[
        _buildGroupMembers(),
        const DividerWidget(),
        _buildGroupInfo(),
        _buildGroupExit(),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .paddingAll(AppSpace.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      id: "group_setting_view",
      tag: tag,
      builder: (_) {
        return _mainView();
      },
    );
  }
}
