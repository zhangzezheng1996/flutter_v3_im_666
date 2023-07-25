import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class DyPage extends GetView<DyController> {
  const DyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildItemWidget("initKey", controller.initKey,
          "initKeyResult is $controller.initKeyResult"),
      // _buildItemWidget("loginInWithDy", () async {
      //   if (initKeyResult != "true") {
      //     setState(() {
      //       loginInResult = "initKey first";
      //     });
      //   }
      //   loginInResult = await _dyPlugin.loginInWithDouyin("");
      // }, '$loginInResult'),
      // _buildItemWidget("addDyCallbackListener", () async {
      //   _dyPlugin.addDyCallbackListener((eventName, eventParams) {});
      // }, '主动收到插件发送过来的消息'),
      // _buildItemWidget("reNewRefreshToken", () async {
      //   if (loginInResult?.isEmpty ?? true) {
      //     setState(() {
      //       reNewRefreshTokenResult = "login first";
      //     });
      //   }
      //   reNewRefreshTokenResult = await _dyPlugin.reNewRefreshToken(
      //       jsonDecode(loginInResult ?? "")['data']['refresh_token']);
      // }, '$reNewRefreshTokenResult'),
      // _buildItemWidget("clientTokenResult", () async {
      //   if (loginInResult?.isEmpty ?? true) {
      //     setState(() {
      //       clientTokenResult = "login first";
      //     });
      //   }
      //   clientTokenResult = await _dyPlugin.getClientToken();
      // }, '$clientTokenResult'),
      // _buildItemWidget("reNewAccessToken", () async {
      //   if (loginInResult?.isEmpty ?? true) {
      //     setState(() {
      //       reNewAccessTokenResult = "login first";
      //     });
      //   }
      //   reNewAccessTokenResult = await _dyPlugin.reNewAccessToken(
      //       jsonDecode(loginInResult ?? "")['data']['refresh_token']);
      // }, '$reNewAccessTokenResult'),
    ].toColumn();
  }

  Widget _buildItemWidget(
    String method,
    VoidCallback? onPressed,
    String result,
  ) =>
      Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: controller.decoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(onPressed: onPressed, child: Text(method)),
              Text(result)
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DyController>(
      init: DyController(),
      id: "dy",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("抖音授权")),
          backgroundColor: const Color(0xfff4f4f4),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
