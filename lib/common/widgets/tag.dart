import 'package:flutter/material.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

/// 标签
class TagWidget extends StatelessWidget {
  final Color? color;
  final BorderRadius? borderRadius;
  final String text;
  const TagWidget(
      {super.key, required this.text, this.color, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return TextWidget.body2(text)
        .padding(all: AppSpace.button)
        .decorated(
          color: color ?? AppColors.secondaryContainer,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSpace.button),
        )
        .height(25);
  }
}
