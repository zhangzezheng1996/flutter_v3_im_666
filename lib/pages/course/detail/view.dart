import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

// 详情页
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailPageGetx(_tabController);
  }
}

class DetailPageGetx extends GetView<DetailController> {
  final TabController? _tabController;
  const DetailPageGetx(this._tabController, {Key? key}) : super(key: key);

  // 介绍
  Widget _buildInfo() {
    var course = controller.course;
    return <Widget>[
      // 图片
      // ImageWidget.url(
      //         "${Constants.imageServer}/${course?.uri}/${course?.cover}.png?x-oss-process=image/resize,w_900")
      //     .paddingBottom(AppSpace.listRow),

      // 子标题
      if (course?.title != null)
        TextWidget.title1(
          course?.title ?? "",
          softWrap: true,
          maxLines: 3,
        ).paddingBottom(AppSpace.listRow),

      // 子标题
      if (course?.subTitle != null)
        TextWidget.body1(
          course?.subTitle ?? "",
          softWrap: true,
          maxLines: 3,
        ).paddingBottom(AppSpace.listRow),

      // 介绍 markdown
      // if (course?.introMd != null)
      //   MarkdownBody(
      //     data: course?.introMd ?? "",
      //     selectable: true,
      //     softLineBreak: false,
      //     // onTapLink: (String text, String? href, String title) {
      //     //   if (href == null) {
      //     //     return;
      //     //   }
      //     //   final Uri url = Uri.parse(href);
      //     //   launchUrl(url);
      //     // },
      //   ),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  // Tab 导航栏
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.secondary,
      labelStyle: const TextStyle(
        fontSize: 15,
      ),
      tabs: [
        Text(LocaleKeys.courseDetailTabInfo.tr),
        Text(LocaleKeys.courseDetailTabChapter.tr),
      ],
    ).paddingBottom(AppSpace.listRow);
  }

  // Tab 内容
  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        // 介绍 markdown
        MarkdownBody(
          data: controller.course?.introMd ?? "",
          selectable: true,
          softLineBreak: false,
          // onTapLink: (String text, String? href, String title) {
          //   if (href == null) {
          //     return;
          //   }
          //   final Uri url = Uri.parse(href);
          //   launchUrl(url);
          // },
        ).scrollable(),

        // 章节
        CourseOutlineWidget(
          course: controller.course!,
          chapterId: null,
          onTap: controller.onOutlineTap,
        ),
      ],
    );
  }

  // 数量
  Widget _buildCountItem(String title, num num) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      dashPattern: const [3, 3],
      strokeWidth: 1,
      color: AppColors.primary,
      child: <Widget>[
        TextWidget.body1(
          "$num",
          color: AppColors.primary,
        ),
        TextWidget.body2(title),
      ].toColumn().width(80),
    );
  }

  Widget _buildCounts() {
    return <Widget>[
      _buildCountItem(
        LocaleKeys.courseDetailTimes.tr,
        (controller.minutesAll / 60).round(),
      ),
      _buildCountItem(
        LocaleKeys.courseDetailChapterCount.tr,
        controller.chapterCount,
      ),
      _buildCountItem(
        LocaleKeys.courseDetailSectionCount.tr,
        controller.sectionCount,
      ),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
        .paddingBottom(AppSpace.listRow);
  }

  // 章节表

  // 主视图
  Widget _buildView() {
    return controller.course == null
        ? Container()
        : <Widget>[
            _buildInfo(),
            _buildCounts(),
            _buildTabBar(),
            _buildTabView().expanded(),
          ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(
              horizontal: AppSpace.page,
              // top: AppSpace.page,
            );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(
      init: DetailController(),
      id: "detail",
      builder: (_) {
        return Scaffold(
          appBar:
              mainAppBarWidget(titleString: LocaleKeys.courseDetailTitle.tr),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
