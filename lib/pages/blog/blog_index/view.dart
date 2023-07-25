import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class BlogIndexPage extends GetView<BlogIndexController> {
  const BlogIndexPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("BlogIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlogIndexController>(
      // init: BlogIndexController(),
      init: Get.find<BlogIndexController>(),
      id: "blog_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("blog_index")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
