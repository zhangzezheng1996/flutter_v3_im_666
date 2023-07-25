import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';
import 'package:video_player/video_player.dart';

class LearnController extends GetxController {
  LearnController();

  CourseModel? course;
  ChapterModel? chapter;
  SectionModel? section;

  final String curi = Get.parameters["curi"] ?? "";
  String suri = Get.parameters["suri"] ?? "";

  VideoPlayerController? videoController;
  ChewieController? chewieController;

  _initData() async {
    await loadCourseData();
    update(["learn"]);
    await loadVideoPlayer();
    update(["learn"]);
  }

  // 载入课程
  Future<void> loadCourseData({String? nextSuri}) async {
    suri = nextSuri ?? suri;
    course = await CourseApi.learn(curi, suri);

    int chapterCount = course?.chapters?.length ?? 0;
    for (int i = 0; i < chapterCount; i++) {
      ChapterModel? cit = course?.chapters?[i];
      for (int j = 0; j < (cit?.sections?.length ?? 0); j++) {
        SectionModel? sit = cit?.sections?[j];
        if (sit?.uri == suri) {
          chapter = cit;
          section = sit;
          break;
        }
      }
    }
  }

  // 载入播放器
  Future<void> loadVideoPlayer({String? nextSuri}) async {
    suri = nextSuri ?? suri;
    videoController?.pause();
    videoController?.dispose();
    chewieController?.dispose();

    if (section?.minutes == 0) {
      return;
    }

    String videoUrl = course?.path?.url ?? "";
    videoController = VideoPlayerController.network(
      videoUrl,
      httpHeaders: <String, String>{},
    );
    await videoController?.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoController!,
      autoPlay: true,
      looping: false,
      showOptions: false,
    );
  }

  // 大纲
  Future<void> onOutlineTap(String suri) async {
    course = null;
    update(["learn"]);

    await loadCourseData(nextSuri: suri);
    update(["learn"]);

    await loadVideoPlayer(nextSuri: suri);
    update(["learn"]);
    // Get.offAndToNamed(
    //   RouteNames.courseLearn,
    //   parameters: {
    //     "curi": curi,
    //     "suri": suri,
    //   },
    // );
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
  @override
  void onClose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
