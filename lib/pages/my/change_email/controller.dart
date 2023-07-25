import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class ChangeEmailController extends GetxController {
  ChangeEmailController();

  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  _initData() {
    update(["change_email"]);
  }

  // 确认
  Future<void> onSave() async {
    if ((formKey.currentState as FormState).validate()) {
      await UserApi.changeEmail(emailController.text);
      await UserService.to.getProfile();
      Get.back(result: true);
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
    emailController.dispose();
  }
}
