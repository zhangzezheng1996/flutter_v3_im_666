import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

// 学习页
class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LearnPageGetx(_tabController);
  }
}

class LearnPageGetx extends GetView<LearnController> {
  final TabController? _tabController;
  const LearnPageGetx(this._tabController, {Key? key}) : super(key: key);

  // 视频播放器
  Widget _buildVideoPlayer() {
    return controller.section?.minutes == 0 ||
            controller.videoController == null
        ? Container(
            height: 50,
            color: Colors.black,
            child: const Center(
              child: Text(
                "视频录制中",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : controller.videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.videoController!.value.aspectRatio,
                child: Chewie(controller: controller.chewieController!),
              )
            : Container(
                height: 200,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "video loading ...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
        Text(LocaleKeys.courseLearnTabMarkdown.tr),
        Text(LocaleKeys.courseLearnTabOutline.tr),
        Text(LocaleKeys.courseLearnTabAccessorie.tr),
      ],
    ).paddingBottom(AppSpace.listRow);
  }

  // Tab 视图
  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        // Tab 文档
        MarkdownBody(
          data: controller.section?.contentMd ?? "",
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
          onTap: (String suri) async {
            // await controller.loadCourseData(nextSuri: suri);
            // _tabController?.animateTo(0);
            _tabController?.animateTo(0);
            await controller.onOutlineTap(suri);
          },
        ),

        // 附件
        _buildAccessories(),
      ],
    );
  }

  // 附件下载
  Widget _buildAccessories() {
    int itemCount = controller.course?.accessories?.length ?? 0;
    return itemCount > 0
        ? ListView.separated(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final accessory = controller.course?.accessories?[index];
              return ListTile(
                title: Text("${accessory?.fileName}"),
                trailing: const Icon(Icons.download),
                onTap: () {
                  final Uri uri = Uri.parse(accessory?.fileUrl ?? "");
                  launchUrl(uri,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: accessory?.fileName,
                      webViewConfiguration: const WebViewConfiguration());
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1);
              // return SizedBox(height: AppSpace.listRow);
            },
          )
        : Center(
            child: Text(LocaleKeys.courseLearnNoAccessorie.tr),
          );
  }

  // 主视图
  Widget _buildView() {
    return controller.course == null
        ? const TextWidget.body1("loading...").center()
        : <Widget>[
            _buildVideoPlayer().paddingBottom(AppSpace.listRow),
            _buildTabBar(),
            _buildTabView().expanded(),
          ].toColumn().padding(
              horizontal: AppSpace.page,
              // top: AppSpace.page,
            );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LearnController>(
      init: LearnController(),
      id: "learn",
      builder: (_) {
        return Scaffold(
          appBar: mainAppBarWidget(titleString: LocaleKeys.courseLearnTitle.tr),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
