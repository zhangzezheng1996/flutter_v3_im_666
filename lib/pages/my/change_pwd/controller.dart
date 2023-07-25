import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class ChangePwdController extends GetxController {
  ChangePwdController();

  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController reController = TextEditingController();

  _initData() {
    update(["change_pwd"]);
  }

  void onSave() async {
    if ((formKey.currentState as FormState).validate()) {
      if (newController.text != reController.text) {
        Loading.toast(LocaleKeys.changePasswordErrTip.tr);
        return;
      }
      await UserApi.changePassword(
        oldController.text,
        newController.text,
      );
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
    oldController.dispose();
    newController.dispose();
    reController.dispose();
  }
}
