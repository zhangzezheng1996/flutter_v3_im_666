import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class ChangeEmailPage extends GetView<ChangeEmailController> {
  const ChangeEmailPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Form(
      key: controller.formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget>[
        // 输入框
        TextFormWidget(
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          labelText: LocaleKeys.changeEmailTitle.tr,
          validator: Validatorless.multiple([
            Validatorless.required(LocaleKeys.validatorEmail.tr),
            Validatorless.email(LocaleKeys.validatorEmail.tr),
          ]),
        ).paddingBottom(AppSpace.listRow),

        // tip
        TextWidget.body2(
          LocaleKeys.changeEmailTip.tr,
          color: AppColors.secondary,
        ).paddingBottom(AppSpace.listRow),

        // 按钮
        ButtonWidget.primary(
          LocaleKeys.commonBottomConfirm.tr,
          onTap: controller.onSave,
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ).paddingHorizontal(AppSpace.page).safeArea();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangeEmailController>(
      init: ChangeEmailController(),
      id: "change_email",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.changeEmailTitle.tr)),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
