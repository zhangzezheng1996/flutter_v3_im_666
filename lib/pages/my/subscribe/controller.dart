import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

class SubscribeController extends GetxController {
  SubscribeController();

  final InAppBrowser browser = InAppBrowser();

  _initData() {
    update(["subscribe"]);
  }

  void onCopy(String value) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      Loading.toast('已复制');
    } catch (e) {
      Loading.toast('复制失败');
    }
  }

  void onOpenUrl(String url) async {
    var options = InAppBrowserClassOptions(
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(),
      ),
    );
    browser.openUrlRequest(
        urlRequest: URLRequest(url: Uri.tryParse(url)), options: options);
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

  @override
  void onClose() {
    browser.close();
    super.onClose();
  }
}
