import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class UserAgreementPage extends GetView<UserAgreementController> {
  const UserAgreementPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse(Constants.userAgreement)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              javaScriptEnabled: true,
            ),
          ),
          // onWebViewCreated: (InAppWebViewController webViewController) {
          //   controller.webViewController.complete(webViewController);
          // },
        ),

        // WebView(
        //   initialUrl: Constants.userAgreement,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (WebViewController webViewController) {
        //     controller.webViewController.complete(webViewController);
        //   },
        //   onWebResourceError: (error) {
        //     controller.setLoading(false);
        //   },
        //   navigationDelegate: (request) {
        //     controller.setLoading(true);
        //     return NavigationDecision.navigate;
        //   },
        //   onPageFinished: (url) {
        //     controller.setLoading(false);
        //   },
        // ),
        if (controller.isLoading)
          Container(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: AppColors.background,
              color: AppColors.onBackground,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserAgreementController>(
      init: UserAgreementController(),
      id: "user_agreement",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.registerUserAgreement.tr)),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
