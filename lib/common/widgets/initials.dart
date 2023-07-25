import 'package:flutter/material.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

// InitialsWidget 首字母签名组件
class InitialsWidget extends StatelessWidget {
  const InitialsWidget(this.initials, {super.key, this.size});

  final String initials;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    const List<String> colors = [
      "00897b",
      "00acc1",
      "039be5",
      "1e88e5",
      "3949ab",
      "43a047",
      "5e35b1",
      "7cb342",
      "8e24aa",
      "c0ca33",
      "d81b60",
      "e53935",
      "f4511e",
      "fb8c00",
      "fdd835",
      "ffb300",
    ];

    return Container(
      width: size?.width ?? 38,
      height: size?.height ?? 38,
      decoration: BoxDecoration(
        color: colors[initials.isNotEmpty
                ? initials.codeUnitAt(0) % colors.length
                : "*".codeUnitAt(0) % colors.length]
            .toColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextWidget.title2(
        initials.isNotEmpty ? initials.substring(0, 1) : "*",
        color: AppColors.onPrimary,
      ).center(),
    );
  }
}
