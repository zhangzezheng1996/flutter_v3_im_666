import 'package:get/get.dart';

class CorrelativeIndexController extends GetxController {
  CorrelativeIndexController();

  _initData() {
    update(["correlative_index"]);
  }

  void onTap() {}

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
