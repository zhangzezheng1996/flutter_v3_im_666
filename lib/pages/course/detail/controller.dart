import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

/// 课程详情
class DetailController extends GetxController {
  DetailController();

  CourseModel? course;
  final String uri = Get.parameters["uri"] ?? "";

  // 章数
  int chapterCount = 0;
  // 节数
  int sectionCount = 0;
  // 分钟数
  int minutesAll = 0;

  _initData() async {
    course = await CourseApi.detail(uri);

    // 计算
    chapterCount = course?.chapters?.length ?? 0;
    for (int i = 0; i < chapterCount; i++) {
      var chapter = course?.chapters?[i];
      sectionCount += chapter?.sections?.length ?? 0;
      for (int j = 0; j < (chapter?.sections?.length ?? 0); j++) {
        var section = chapter?.sections?[j];
        minutesAll += section?.minutes ?? 0;
      }
    }

    update(["detail"]);
  }

  // 大纲
  void onOutlineTap(String suri) {
    Get.toNamed(
      RouteNames.courseLearn,
      parameters: {
        "curi": uri,
        "suri": suri,
      },
    );
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
