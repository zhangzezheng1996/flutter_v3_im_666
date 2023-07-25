import 'package:get/get.dart';

class MoreSettingsController extends GetxController {
  MoreSettingsController();

  _initData() {
    update(["more_settings"]);
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
