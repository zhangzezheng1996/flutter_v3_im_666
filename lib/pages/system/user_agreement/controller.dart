import 'package:get/get.dart';

class UserAgreementController extends GetxController {
  UserAgreementController();

  // final Completer<WebViewController> webViewController =
  //     Completer<WebViewController>();

  bool isLoading = true;

  _initData() {
    update(["user_agreement"]);
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
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

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
