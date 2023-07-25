import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class MyIndexController extends GetxController {
  MyIndexController();
  final TextEditingController destroyInput = TextEditingController();

  _initData() {
    update(["my_index"]);
  }

  // 修改 email
  Future<void> onChangeEmail() async {
    var result = await Get.toNamed(RouteNames.myChangeEmail);
    if (result == true) {
      update(["my_index"]);
    }
  }

  // 修改密码
  Future<void> onChangePassword() async {
    var result = await Get.toNamed(RouteNames.myChangePwd);
    if (result == true) {
      await UserService.to.logout();
      Get.offAllNamed(RouteNames.main);
    }
  }

  // 多语言
  onLanguageSwitch() {
    var en = Translation.supportedLocales[0];
    var zh = Translation.supportedLocales[1];

    ConfigService.to.onLocaleUpdate(
        ConfigService.to.locale.toLanguageTag() == en.toLanguageTag()
            ? zh
            : en);
    update(["my_index"]);
  }

  // 重新登录
  Future<void> onLogout() async {
    await showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("退出账号"),
            content: const Text("你确定要退出当前账号吗？"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("取消")),
              TextButton(
                  onPressed: () async {
                    await UserService.to.logout();

                    // im 退出
                    IMService.to.logout();

                    // Get.offAllNamed(RouteNames.main);
                    Get.offAllNamed(RouteNames.systemSplash);
                  },
                  child: const Text("确定")),
            ],
          );
        });
  }

  // 销毁
  void onDestroy() async {
    if (destroyInput.value.text.toLowerCase() != 'yes') {
      Loading.toast('Code error');
      return;
    }
    await UserService.to.destory();
    Get.offAllNamed(RouteNames.main);
  }

  //抖音授权
  void onDouyinAuth() async {
    var result = await Get.toNamed(RouteNames.myDy);
    if (result == true) {
      update(["my_index"]);
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
    destroyInput.dispose();
  }
}
