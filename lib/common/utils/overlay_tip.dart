import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 浮动层提示
class OverlayTipUtil {
  static final OverlayTipUtil _singleton = OverlayTipUtil._();
  static OverlayTipUtil get to => _singleton;
  OverlayTipUtil._();

  // overlay 浮动层管理
  OverlayState? _overlayState;
  // overlay 遮罩层
  OverlayEntry? _shadeOverlayEntry;

  void showOverlayTip(String error) {
    _overlayState ??= Overlay.of(Get.context!);
    _shadeOverlayEntry = OverlayEntry(builder: (context) {
      final double statusBarHeight = MediaQuery.of(context).padding.top;
      return Positioned(
        left: 0.0,
        right: 0.0,
        top: statusBarHeight,
        child: Container(
          height: 30,
          color: AppColors.error.withOpacity(0.8),
          child: Center(
            child: TextWidget.body2(
              error,
              color: AppColors.onError,
            ),
          ),
        ),
      );
    });
    _overlayState?.insert(_shadeOverlayEntry!);
  }

  void hideOverlay() {
    _shadeOverlayEntry?.remove();
  }
}
