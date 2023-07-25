import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';
import 'package:video_ducafecat_flutter_v3/pages/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ConfigService.to.setAppLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    DateTime? lastPressedAt;
    return WillPopScope(
      // 防止连续点击两次退出
      onWillPop: () async {
        if (lastPressedAt == null ||
            DateTime.now().difference(lastPressedAt!) >
                const Duration(seconds: 1)) {
          lastPressedAt = DateTime.now();
          Loading.toast('Press again to exit');
          return false;
        }
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: Scaffold(
        extendBody: true, //设置为true，可以设置背景色
        resizeToAvoidBottomInset: false, //防止键盘弹出时底部布局被顶起
        //透明
        // backgroundColor: Colors.transparent,

        // 顶部导航
        // appBar: mainAppBarWidget(),

        // 导航栏
        bottomNavigationBar: GetBuilder<MainController>(
          id: 'navigation',
          builder: (controller) {
            return Obx(() => BuildNavigation(
                  currentIndex: controller.currentIndex,
                  items: [
                    // 时刻
                    NavigationItemModel(
                      label: '时刻',
                      iconData: Icons.rss_feed_outlined,
                    ),
                    // 相关
                    NavigationItemModel(
                      label: "相关",
                      iconData: Icons.filter_9_plus_sharp,
                      count: 0,
                    ),
                    // 聊天
                    NavigationItemModel(
                      label: "聊天",
                      iconData: Icons.chat_outlined,
                      count: IMService.to.totalUnreadCount.value,
                    ),
                    //我的
                    NavigationItemModel(
                      label: LocaleKeys.tabBarProfile.tr,
                      iconData: Icons.person_outline_outlined,
                    ),
                  ],
                  onTap: controller.onJumpToPage, // 切换tab事件
                ));
          },
        ),

        // 内容页
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onIndexChanged,
          children: const [
            // CourseIndexPage(),
            PostIndexPage(),
            // BlogIndexPage(),
            CorrelativeIndexPage(),
            ChatIndexPage(),
            MyIndexPage(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      // init: MainController(),
      init: Get.find<MainController>(),
      id: "main",
      builder: (_) => _buildView(),
    );
  }
}
