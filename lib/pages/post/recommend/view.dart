import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/index.dart';
import 'index.dart';
import 'widgets/index.dart';

class RecommendPage extends GetView<RecommendController> {
  const RecommendPage({Key? key}) : super(key: key);

  // 动态栏
  Widget? _buildTimelineBar(bool isShow, int index) {
    PostViewModel postViewItems = controller.items[index];
    // 动态id
    String gid = postViewItems.chatAreaId.toString();
    String id = postViewItems.id.toString();
    int likesCount = 1999;
    int commentsCount = 100;

    if (isShow == false) {
      return null;
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 内容
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "我喜爱各种美丽的花。玫瑰花的凝重热烈、舒展奔放，令我为之心动神往；荷花的典雅脱俗、冷艳幽香，令我为之仰慕倾倒；丁香的洁白无瑕、纯净淡雅，令我为之赞叹敬重；牡丹花的妖娆多姿、国色天香，令我为之痴迷眷恋。",
              style: textStyleDetail,
            ),
          ),

          // 点赞数、评论，详情
          Container(
            color: Colors.black,
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              bottom: 8.0 * 2,
            ),
            child: Row(
              children: [
                // like 图标
                if (likesCount > 0)
                  const Icon(
                    Icons.favorite_border_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                const SpaceHorizontalWidget(space: 5),

                // like 数量
                if (likesCount > 0)
                  Text(
                    "$likesCount",
                    style: textStyleDetail,
                  ),
                const SpaceHorizontalWidget(),

                // 评论 图标
                if (commentsCount > 0)
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 24,
                    color: Colors.white,
                  ),
                const SpaceHorizontalWidget(space: 5),

                // 评论 文字
                if (commentsCount > 0)
                  Text(
                    "评论($commentsCount)",
                    style: textStyleDetail,
                  ),
                const Spacer(),

                // 进入聊天区
                GestureDetector(
                  onTap: () => controller.onChat(id, gid),
                  child: Text(
                    "进入聊天 >",
                    style: textStyleDetail,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // 数据加载loading
  Widget _buildDataLoding() {
    return const Center(
      child: TextWidget.body3(
        "数据加载...",
        size: 13,
        color: Colors.white,
      ),
    );
  }

  //Post视图
  Widget _buildPostView(int index) {
    return Stack(
      children: [
        //页面信息
        PostTypeView(
          initialIndex: index,
          imgUrls: controller.items[index].images,
          // isBarVisible: false,
          //post
          postViewItems: controller.items[index],
          onActionsPressed: () {},
        ).onLongPress(() {
          controller.onDeleteCurrentPostPage(index);
        }).onTap(() {}),
        // 动态栏
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_buildTimelineBar(true, index) ?? const SizedBox()],
        )
      ],
    );
  }

  // 主视图
  Widget _buildView() {
    return controller.items.isEmpty
        ? _buildDataLoding()
        : RotatedBox(
            quarterTurns: 1,
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) {
                print('当前Post页面Pageindx:$index');
                controller.onPageChanged(index);
              },
              pageSnapping: true, //页面是否根据滑动距离吸附
              scrollDirection: Axis.horizontal, //页面滑动方向
              physics: const BouncingScrollPhysics(), //页面滑动效果
              allowImplicitScrolling: true,
              children: List.generate(
                  controller.items.length,
                  (index) => RotatedBox(
                        quarterTurns: -1,
                        child: _buildPostView(index),
                      )),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendController>(
      init: RecommendController(),
      id: "recommend",
      builder: (_) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          // maintainBottomViewPadding: true,
          child: Scaffold(
            // 全屏, 高度将扩展为包括应用栏的高度
            extendBodyBehindAppBar: true,

            extendBody: true, //设置appbar是否覆盖body

            // 背景透明
            backgroundColor: Colors.transparent,

            body: _buildView(),

            // 底部视图
            // bottomSheet: _buildTimelineBar(true),
          ),
        );
      },
    );
  }
}
