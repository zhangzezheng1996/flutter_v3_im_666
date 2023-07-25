import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

// 找回密码
class FindpwdController extends GetxController {
  FindpwdController();

  GlobalKey formKey = GlobalKey<FormState>();

  // 邮件
  TextEditingController emailController = TextEditingController(text: "");
  // 密码
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController rePasswordController = TextEditingController(text: "");

  // 提交
  Future<void> onSubmit() async {
    if ((formKey.currentState as FormState).validate()) {
      // 检查 email
      if (passwordController.text != rePasswordController.text) {
        Loading.toast(LocaleKeys.registerPasswordError.tr);
        return;
      }

      try {
        // 发送邮件验证码
        await UserApi.sendEmailVerify(emailController.text, "findpwd");

        // 加密密码
        var password = await UserApi.encrypt(passwordController.text);

        //验证通过
        Get.offNamed(
          RouteNames.systemFindpwdPin,
          arguments: UserRegisterReq(
            email: emailController.text,
            password: password,
          ),
        );
      } on DioError catch (error) {
        var message = error.response?.data["message"] ??
            LocaleKeys.commonMessageIncorrect
                .trParams({"method": LocaleKeys.findpwdFormEmail.tr});
        Loading.toast(message);
      }
    }
  }

  // 登录
  void onSignIn() {
    Get.offNamed(RouteNames.systemLogin);
  }

  _initData() {
    update(["findpwd"]);
  }

  void onTap() {}

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
    passwordController.dispose();
    rePasswordController.dispose();
  }

  // 释放
}
