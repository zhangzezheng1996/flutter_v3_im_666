import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PostPage extends GetView<PostController> {
  const PostPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("PostPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
      init: PostController(),
      id: "post",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("post")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
