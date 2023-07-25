import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MoreSettingsPage extends GetView<MoreSettingsController> {
  const MoreSettingsPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("MoreSettingsPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoreSettingsController>(
      init: MoreSettingsController(),
      id: "more_settings",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("more_settings")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
