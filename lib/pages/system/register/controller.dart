import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class RegisterController extends GetxController {
  RegisterController();

  GlobalKey formKey = GlobalKey<FormState>();

  // 用户名
  TextEditingController userNameController = TextEditingController(text: "");
  // 邮件
  TextEditingController emailController = TextEditingController(text: "");
  // 密码
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController rePasswordController = TextEditingController(text: "");

  // 用户协议
  bool isAgree = false;

  // 选中用户协议
  void onCheckAgree(value) {
    isAgree = value;
    update(['register']);
  }

  // 用户协议
  void onUserAgreement() {
    Get.toNamed(RouteNames.systemUserAgreement);
  }

  // 注册
  Future<void> onSignUp() async {
    if (isAgree == false) {
      Loading.toast(LocaleKeys.registerUserAgreementError.tr);
      return;
    }
    if ((formKey.currentState as FormState).validate()) {
      // 检查 email
      if (passwordController.text != rePasswordController.text) {
        Loading.toast(LocaleKeys.registerPasswordError.tr);
        return;
      }

      // 发送邮件验证码
      try {
        await UserApi.sendEmailVerify(emailController.text, "register");

        // 加密密码
        var password = await UserApi.encrypt(passwordController.text);

        //验证通过
        Get.offNamed(
          RouteNames.systemRegisterPin,
          arguments: UserRegisterReq(
            username: userNameController.text,
            email: emailController.text,
            password: password,
          ),
        );
      } catch (e) {
        return;
      }
    }
  }

  // 登录
  void onSignIn() {
    Get.offNamed(RouteNames.systemLogin);
  }

  _initData() {
    update(["register"]);
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
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
  }

  // 释放
}
