import 'package:dy/dy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class DyController extends GetxController {
  DyController();

  Dy? dyPlugin;
  String? initKeyResult = ""; //初始化key
  String? loginInResult = ""; //登录
  String? reNewRefreshTokenResult = ""; //刷新token
  String? clientTokenResult = ""; //获取clientToken
  String? reNewAccessTokenResult = ""; //刷新accessToken

  final BoxDecoration decoration = BoxDecoration(
    boxShadow: [BoxShadow(color: Colors.black.withAlpha(180))],
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
  );

  _initData() {
    dyPlugin = Dy();
    update(["dy"]);
  }

  void onTap() {}

  ///初始化key
  ///[clientKey] 申请的clientKey
  ///[clientSecret] 申请的clientSecret
  ///[return] 返回初始化结果
  ///[initKeyResult] 初始化结果
  ///[initKey] 初始化key

  void initKey() async {
    initKeyResult =
        await dyPlugin?.initKey(Constants.clientkey, Constants.clientSecrett);
    debugPrint("the initKeyResult is $initKeyResult");
    update(["dy"]);
  }

  ///登录
  ///[scope] 权限
  ///[return] 返回登录结果
  ///[loginInResult] 登录结果
  ///[loginInWithDy] 登录
  ///[addDyCallbackListener] 添加监听
  ///[reNewRefreshToken] 刷新token
  ///[clientTokenResult] 获取clientToken
  ///[reNewAccessToken] 刷新accessToken
  ///[loginInWithDouyin] 登录
  ///[shareToEditPage] 分享去编辑页面
  ///[imgPathList] 图片路径
  ///[videoPathList] 视频路径
  Future<void> loginInWithDy(String scope) async {
    loginInResult = await dyPlugin?.loginInWithDouyin(scope);
    debugPrint("the loginInResult is $loginInResult");
    update(["dy"]);
  }

  ///添加监听
  ///[eventName] 事件名
  ///[eventParams] 事件参数
  ///[return] 返回添加监听结果
  ///[addDyCallbackListener] 添加监听
  ///[loginInWithDy] 登录
  ///[reNewRefreshToken] 刷新token

  Future<void> addDyCallbackListener(
      Function(String eventName, dynamic eventParams) callback) async {
    dyPlugin?.addDyCallbackListener(callback);
    update(["dy"]);
  }

  ///刷新token
  ///[refreshToken] 刷新token
  ///[return] 返回刷新token结果
  ///[reNewRefreshToken] 刷新token
  ///[loginInWithDy] 登录
  ///
  Future<void> reNewRefreshToken(String refreshToken) async {
    reNewRefreshTokenResult = await dyPlugin?.reNewRefreshToken(refreshToken);
    debugPrint("the reNewRefreshTokenResult is $reNewRefreshTokenResult");
    update(["dy"]);
  }

  ///分享去编辑页面
  Future<dynamic> shareToEditPage(
      List<String> imgPathList,
      List<String> videoPathList,
      List<String> mHashTagList,
      bool shareToPublish,
      String mState,
      String appId,
      String appTitle,
      String description,
      String appUrl) {
    throw UnimplementedError('shareToEditPage() has not been implemented.');
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
