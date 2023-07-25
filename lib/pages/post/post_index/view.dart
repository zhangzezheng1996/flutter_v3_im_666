import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/pages/index.dart';

import '../../../common/index.dart';

class PostIndexPage extends GetView<PostIndexController> {
  const PostIndexPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return DefaultTabController(
      length: controller.myTabs.length,
      // initialIndex: controller.currentTabIndex,
      child: Scaffold(
        //设置appbar是否覆盖body
        extendBodyBehindAppBar: true,
        extendBody: true,
        // 顶部导航栏
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: 0,
          bottom: _buildTabBar(),
          // backgroundColor: Colors.yellow,
        ),
        //透明状态栏
        backgroundColor: Colors.black,
        //extendBody: true,
        resizeToAvoidBottomInset: false,
        // 内容页
        body: _buildTabBarView(),
      ),
    );
  }

  Widget _buildTabBarView() {
    //用户是否登录
    bool isLogin = UserService.to.hasToken;
    return TabBarView(
      controller: controller.tabController,
      children: const [
        // 加入空页面占位
        RecommendPage(),
        // RecommendPage(),
        // RecommendPage(),
        // isLogin ? const PostShowIndexPage() : const LoginPlaceholdWidget(),
        // MessageIndexPage(),
        // isLogin ? const MyIndexPage() : const LoginPlaceholdWidget(),
        // isLogin ? const MyIndexPage() : const LoginPlaceholdWidget(),
      ],
    );
  }

  PreferredSize _buildTabBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconWidget.image(
              AssetsImages.menuPng,
              size: 28.w,
            ),
            TabBar(
              enableFeedback: true, //是否有点击反馈
              // padding: const EdgeInsets.all(2), //tabbar内边距  有益处
              isScrollable: true, //是否可滚动
              // indicatorColor: Colors.white70, //指示器颜色s
              // indicatorWeight: 2, //指示器高度
              indicatorSize: TabBarIndicatorSize.tab, //指示器大小计算方式
              // indicatorPadding: const EdgeInsets.all(5), //指示器内边距
              // dividerColor: Colors.blue, //分割线颜色
              // labelColor: Colors.white70, //选中label颜色
              // automaticIndicatorColorAdjustment: true, //是否自动调整指示器颜色
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), //选中label样式
              unselectedLabelColor: Colors.white54, //未选中label颜色
              unselectedLabelStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ), //未选中label样式
              controller: controller.tabController,
              tabs: controller.myTabs,
              onTap: (index) {
                // controller.onIndexChanged(index);
              },
            ),
            //搜索按钮
            IconWidget.image(
              AssetsImages.searchPng,
              size: 28.w,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostIndexController>(
      init: PostIndexController(),
      id: "post_index",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
