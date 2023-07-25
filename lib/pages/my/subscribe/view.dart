import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class SubscribePage extends GetView<SubscribeController> {
  const SubscribePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return <Widget>[
      const TextWidget.title1("VIP 高级会员").paddingBottom(AppSpace.listRow),
      const TextWidget.body1("会员期限 1 年"),
      const TextWidget.body1("观看所有视频"),
      const TextWidget.body1("下载所有附件"),
      const TextWidget.body1("成为猫哥密友"),
      const TextWidget.body1("加入 VIP 会员微信群"),
      const TextWidget.body1("VIP 网盘下载高清视频").paddingBottom(AppSpace.listRow),

      // 说明
      const TextWidget.body1("目前只开通 web 端扫码付费开通."),
      const TextWidget.body1("https://video.ducafecat.tech"),

      // 按钮
      ButtonWidget.text(
        "复制网址",
        onTap: () => controller.onCopy("https://video.ducafecat.tech"),
      )
          .tight(
            width: 150,
            height: 40,
          )
          .paddingBottom(AppSpace.listRow),
      ButtonWidget.primary(
        "前往",
        icon: const Icon(CupertinoIcons.doc_on_clipboard),
        onTap: () => controller.onOpenUrl("https://video.ducafecat.tech"),
      )
          .tight(
            width: 150,
            height: 40,
          )
          .paddingBottom(AppSpace.listRow),
      ButtonWidget.secondary(
        "返回",
        onTap: () => Get.back(),
      ).tight(
        width: 150,
        height: 40,
      ),
    ].toColumn().center();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscribeController>(
      init: SubscribeController(),
      id: "subscribe",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
