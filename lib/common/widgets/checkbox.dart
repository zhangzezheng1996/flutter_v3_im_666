import 'package:flutter/material.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

// CheckBox 确认组件
class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    this.value,
    this.onChanged,
    this.text,
    this.textWidget,
  });

  final String? text;
  final Widget? textWidget;
  final bool? value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 选择框
      Checkbox(
        value: value ?? false,
        onChanged: onChanged,
      ),

      // 文字
      if (text != null) TextWidget.body1(text!),

      // 组件
      if (textWidget != null) textWidget!,
    ].toRow();
  }
}
