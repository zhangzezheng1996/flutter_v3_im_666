import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class CorrelativeIndexPage extends GetView<CorrelativeIndexController> {
  const CorrelativeIndexPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Scaffold(
      //设置appbar是否覆盖body
      extendBodyBehindAppBar: true,
      extendBody: true,
      // 顶部导航栏
      appBar: AppBar(
        elevation: 0,
        //不居中
        centerTitle: false,
        //标题
        title: const Text(
          '消息',
          // style: TextStyle(color: Colors.white),
        ),
        // toolbarHeight: 0,
        // bottom: _buildTabBar(),
      ),
      //透明状态栏
      // backgroundColor: Colors.black.withOpacity(0.95),
      //extendBody: true,
      resizeToAvoidBottomInset: false,
      // 内容页
      // body: _buildTabBarView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CorrelativeIndexController>(
      init: CorrelativeIndexController(),
      id: "correlative_index",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
