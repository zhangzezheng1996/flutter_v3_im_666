import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/pages/index.dart';

/// 主界面依赖
class MainBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CourseIndexController>(() => CourseIndexController());
    Get.lazyPut<PostIndexController>(() => PostIndexController());
    // Get.lazyPut<BlogIndexController>(() => BlogIndexController());
    Get.lazyPut<CorrelativeIndexController>(() => CorrelativeIndexController());
    Get.lazyPut<ChatIndexController>(() => ChatIndexController());
    Get.lazyPut<MyIndexController>(() => MyIndexController());
    Get.lazyPut<MainController>(() => MainController());
  }
}
