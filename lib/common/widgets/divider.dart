import 'package:flutter/material.dart';

/// 分隔条
class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 1,
      color: Colors.grey[200],
    );
  }
}
