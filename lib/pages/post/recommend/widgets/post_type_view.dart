// ignore_for_file: avoid_print

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/index.dart';
// import '../entity/index.dart';
// import '../global.dart';
// import '../styles/text.dart';
// import '../utils/index.dart';

/// 预览类型
enum PostType { chartArea, urls, video }

// 图片视频预览
class PostTypeView extends StatefulWidget {
  const PostTypeView({
    Key? key,
    required this.initialIndex,
    // this.items,
    this.isBarVisible,
    // this.timeline,
    this.imgUrls,
    this.onActionsPressed,
    this.postViewItems,
  }) : super(key: key);

  /// 初始图片位置
  final int initialIndex;

  /// AssetEntity 图片列表
  // final List<AssetEntity>? items;

  /// URL 图片列表
  final List<String>? imgUrls;

  /// 是否显示 bar
  final bool? isBarVisible;

  /// 动态信息
  // final TimelineModel? timeline;
  final PostViewModel? postViewItems;

  /// 右侧点击事件
  final Function()? onActionsPressed;

  @override
  State<PostTypeView> createState() => _PostTypeViewState();
}

class _PostTypeViewState extends State<PostTypeView>
    with
        SingleTickerProviderStateMixin,
        RouteAware,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin {
  // 是否显示 bar
  bool _isShowAppBar = true;

  // 当前页码
  int _currentPage = 0;

  // video 视频控制器
  VideoPlayerController? _videoController;

  // chewie 控制器
  // ChewieController? _chewieController;

  // 预览类型
  PostType _galleryType = PostType.chartArea;

  // 当系统将应用程序置于后台或返回时调用 应用程序到前台。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("post_type didChangeAppLifecycleState: $state");
    if (_videoController?.value.isInitialized != true) return;
    // 该应用程序当前对用户不可见，不响应 用户输入，并在后台运行。
    if (state != AppLifecycleState.paused) {
      // _chewieController?.pause();
    }
    // 该应用程序是可见的并响应用户输入。
    if (state != AppLifecycleState.resumed) {
      // _chewieController?.play();
    }
  }

  // 在此 [State] 对象的依赖项更改时调用。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoutePages.observer
        .subscribe(this, ModalRoute.of(context) as PageRoute); //订阅
  }

  // 当由A打开B页面时，B页面调起该方法；
  @override
  void didPush() {
    super.didPush();
    //跳转到记录的post页面
    print("post_type did Push");
  }

  // 在C页面关闭后，B页面调起该方法；
  @override
  void didPushNext() {
    super.didPushNext();
    print("post_type did Push Next");
    if (_videoController?.value.isInitialized != true) return;
    // _chewieController?.pause();
  }

  // 当B页面关闭时，B页面调起该方法；
  @override
  void didPop() {
    super.didPop();
    print("post_type did Pop");
  }

  // 当从B页面打开C页面时，该方法被调起。
  @override
  void didPopNext() {
    super.didPopNext();
    print("post_type did Pop Next");
    if (_videoController?.value.isInitialized != true) return;
    // _chewieController?.play();
  }

  @override
  void initState() {
    super.initState();

    // 阅览类型
    _galleryType = PostType.chartArea;
    // 视频
    // if (widget.timeline?.postType == "2") {
    //   _galleryType = GalleryType.video;
    // }
    // // 发布选取的相册图片 AssetEntiry
    // else if (widget.items != null) {
    //   _galleryType = GalleryType.assets;
    // }
    // // url 图片列表
    // else if (widget.imgUrls != null) {
    //   _galleryType = GalleryType.urls;
    // }

    // 是否显示 bar
    _isShowAppBar = widget.isBarVisible ?? true;

    // 当前页码
    _currentPage = widget.initialIndex + 1;

    // 将给定对象注册为绑定观察者。捆绑 当各种应用程序事件发生时，观察者会收到通知， 例如，当系统区域设置更改时。
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    RoutePages.observer.unsubscribe(this);
    _videoController?.dispose();
    // _chewieController?.dispose();
    _videoController = null;
    // _chewieController = null;
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////////
  ///
  // URL 图片视图
  Widget _buildImageByUrlsView() {
    return ExtendedImageGesturePageView.builder(
      controller: ExtendedPageController(
        initialPage: widget.initialIndex,
      ),
      itemCount: widget.imgUrls?.length ?? 0,
      onPageChanged: (value) {
        setState(() {
          _currentPage = value + 1;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final String src = widget.imgUrls![index];
        return ExtendedImage(
          image: ExtendedNetworkImageProvider(
              DuTools.imageUrlFormat(src, width: 700)),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true,
            );
          },
        );
      },
    );
  }

  Widget _mainView() {
    return _buildImageByUrlsView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _mainView();
  }

  @override
  bool get wantKeepAlive => true; //是否保存状态
}
