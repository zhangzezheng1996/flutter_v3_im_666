import 'package:flutter/material.dart';

enum AvatarWidgetType {
  url,
  asset,
}

// AvatarWidget 头像组件
class AvatarWidget extends StatelessWidget {
  const AvatarWidget(this.url,
      {super.key, this.type = AvatarWidgetType.url, this.size});

  final String? url;
  final Size? size;
  final AvatarWidgetType type;

  const AvatarWidget.asset(
    this.url, {
    Key? key,
    this.type = AvatarWidgetType.asset,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (type == AvatarWidgetType.asset) {
      image = AssetImage(url!);
    } else if (type == AvatarWidgetType.url) {
      image = NetworkImage(url ?? '');
    }
    return Container(
      width: size?.width ?? 38,
      height: size?.height ?? 38,
      decoration: BoxDecoration(
        color: Colors.white,
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: image!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
