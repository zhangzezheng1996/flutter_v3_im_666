import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

/// 占位图组件
class LoginPlaceholdWidget extends StatelessWidget {
  // 资源图片地址
  final String? assetImagePath;

  const LoginPlaceholdWidget({
    Key? key,
    this.assetImagePath,
  }) : super(key: key);
  Widget _buildView() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          const TextWidget.title1("你还没有登录哦!"),
          const TextWidget.body1("登录后可以查看更多精彩内容哦!"),
          const SizedBox(
            height: 60,
          ),
          //登录按钮
          ElevatedButton(
            onPressed: () {
              //跳转到登录页面
              Get.toNamed(RouteNames.systemLogin);
            },
            //按钮大小
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black12,
              minimumSize: const Size(200, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
            ),
            child: const TextWidget.body1(
              "登录",
              //主色
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //灰色
      backgroundColor: Colors.grey,
      // appBar: AppBar(title: const Text("")),
      body: _buildView(),
    );
  }
}
