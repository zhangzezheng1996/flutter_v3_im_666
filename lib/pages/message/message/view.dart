import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

// 消息页面
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _CartViewGetX();
  }
}

class _CartViewGetX extends GetView<MessageController> {
  const _CartViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("MessagePage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      init: MessageController(),
      id: "cart",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("message")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
