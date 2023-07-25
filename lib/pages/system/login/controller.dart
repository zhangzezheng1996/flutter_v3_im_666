import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class LoginController extends GetxController {
  LoginController();

  /// 定义输入控制器
  TextEditingController userNameController =
      TextEditingController(text: "18366542015");
  TextEditingController passwordController = TextEditingController();

  /// 表单 key
  GlobalKey formKey = GlobalKey<FormState>();

  /// Sign In
  Future<void> onSignIn() async {
    if ((formKey.currentState as FormState).validate()) {
      try {
        Loading.show();

        // aes 加密密码
        // var password = await EncryptUtil().encrypt(passwordController.text);
        // var password = await UserApi.encrypt(passwordController.text);

        // api 请求
        // UserTokenModel res = await UserApi.login(UserLoginReq(
        //   username: userNameController.text,
        //   password: password,
        // ));
        UserTokenModel res = await UserApi.phoneLogin(userNameController.text);
        // 本地保存 token
        await UserService.to.setToken(res.token!);
        // 获取用户资料
        await UserService.to.getProfile();

        // IM 登录
        IMService.to.login();

        Loading.success();
        Get.back(result: true);
      } catch (e) {
        //
      } finally {
        Loading.dismiss();
      }
    }
  }

  /// Sign Up
  void onSignUp() {
    Get.offNamed(RouteNames.systemRegister);
  }

  _initData() {
    update(["login"]);
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  /// 释放
  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }
}
