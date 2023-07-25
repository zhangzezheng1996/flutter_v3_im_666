import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';

class MessageIndexPage extends GetView<MessageIndexController> {
  const MessageIndexPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Column(
      children: const [
        ListTileWidget(
          leading: ImageWidget.url(
            "https://ducafecat.oss-cn-beijing.aliyuncs.com/ducafecat/logo-500.png",
            width: 48,
            height: 48,
          ),
          title: TextWidget.title2("猫哥"),
          subtitle: TextWidget.body1("你好，我是猫哥"),
        ),
        DividerWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageIndexController>(
      init: MessageIndexController(),
      id: "message_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("消息")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
