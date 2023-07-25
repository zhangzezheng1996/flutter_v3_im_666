import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/common/index.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({Key? key}) : super(key: key);

  // 属性行
  Widget _listRow(String label, String value) {
    return <Widget>[
      TextWidget.body1(
        "$label : ",
        color: AppColors.secondary,
        size: 12,
      ).paddingRight(AppSpace.listItem),
      TextWidget.body1(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ).width(
        Get.width - AppSpace.listItem * 2 - 100,
      ),
    ].toRow().paddingBottom(AppSpace.listRow);
  }

  // 头部
  Widget _buildHeader() {
    // DateTime ceratTime =
    //     DateTime.parse(UserService.to.profile.createTime.toString());

    // formatDate(ceratTime, ['yyyy', '-', 'mm', '-', 'dd']);
    return <Widget>[
      // 头像
      AvatarWidget(
        UserService.to.profile.avatar,
        size: const Size(90, 90),
      ),

      // 昵称
      TextWidget.title1("${UserService.to.profile.nickname}")
          .paddingBottom(AppSpace.listRow),
      // 心语
      _listRow(
        "心语",
        UserService.to.profile.sign ?? "暂无心语",
      ),
      // 注册日期
      _listRow(
        LocaleKeys.profileHomeRegisterDate.tr,
        // formatDate(ceratTime, ['yyyy', '-', 'mm', '-', 'dd']),
        UserService.to.profile.createTime ?? "暂无注册日期",
      ),
      _listRow(
        "SYID",
        UserService.to.profile.id.toString(),
      ),
      // 截止日期
      // if (UserService.to.profile.vipGrade != null &&
      //     UserService.to.profile.vipGrade != "guest")
      //   _listRow(
      //     LocaleKeys.profileHomeVipDeadline.tr,
      //     UserService.to.profile.vipExpireTime!.toLocalString(),
      //   ),
      const Divider(),
    ].toColumn();
  }

  // 菜单
  Widget _menus() {
    return <Widget>[
      // 我的钱包
      ListTileWidget(
        leading: Row(
          children: [
            IconWidget.icon(
              Icons.wallet,
              size: 25,
            ),
          ],
        ),
        title: const TextWidget.body1("我的钱包"),
        trailing: <Widget>[
          ButtonWidget.icon(
            IconWidget.icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ),
        ],
        // onTap: () => Get.toNamed(RouteNames.chatChatDebug),
      ),

      const Divider(),

      // 修改邮件
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.email,
          size: 20,
        ),
        title: TextWidget.body1(LocaleKeys.profileHomeMenuChangeEmail.tr),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: controller.onChangeEmail,
      ),

      //我的订单
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.shopping_cart,
          size: 20,
        ),
        title: const TextWidget.body1("我的订单"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => Get.toNamed(RouteNames.profileSetting),
      ),

      // 关于闪忆
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.info,
          size: 20,
        ),
        title: const TextWidget.body1("关于闪忆"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => Get.toNamed(RouteNames.profileSetting),
      ),

      // 用户协议
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.description,
          size: 20,
        ),
        title: const TextWidget.body1("用户协议"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => Get.toNamed(RouteNames.profileSetting),
      ),

      // 抖音授权
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.description,
          size: 20,
        ),
        title: const TextWidget.body1("抖音授权"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: () => Get.toNamed(RouteNames.myDy),
      ),

      // 账号管理
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.verified_user,
          size: 20,
        ),
        title: const TextWidget.body1("账号与安全"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => Get.toNamed(RouteNames.profileSetting),
      ),

      //设置
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.settings,
          size: 20,
        ),
        title: const TextWidget.body1("更多设置"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => Get.toNamed(RouteNames.profileSetting),
      ),

      const Divider(),

      // 退出登录
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.logout,
          size: 20,
        ),
        title: TextWidget.body1(LocaleKeys.profileHomeMenuLogout.tr),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: controller.onLogout,
      ),

      const Divider(),

      // 修改语言
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.language,
          size: 20,
        ),
        title: TextWidget.body1(
            "${LocaleKeys.profileHomeMenuChangeLanguage.tr} - ${ConfigService.to.locale.toLanguageTag()}"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: controller.onLanguageSwitch,
      ),

      // 修改密码
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.password,
          size: 20,
        ),
        title: TextWidget.body1(LocaleKeys.profileHomeMenuChangePassword.tr),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: controller.onChangePassword,
      ),

      // 修改样式
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.dark_mode,
          size: 20,
        ),
        title: TextWidget.body1(
            "${LocaleKeys.profileHomeMenuChangeTheme.tr} - ${ConfigService.to.isDarkModel ? "Dark Mode" : "Light Mode"}"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: () => ConfigService.to.switchThemeModel(),
      ),

      //支付宝登录
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.nat,
          size: 20,
        ),
        title: const TextWidget.body1("支付宝登录"),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        // onTap: () => ConfigService.to.switchThemeModel(),
      ),

      // 销毁账户
      ListTileWidget(
        leading: IconWidget.icon(
          Icons.remove_circle,
          size: 20,
        ),
        title: const TextWidget.body1(
          "申请注销账号",
        ),
        trailing: <Widget>[
          ButtonWidget.icon(IconWidget.icon(
            Icons.arrow_forward_ios,
            size: 15,
          ))
        ],
        onTap: () {
          ActionDialog.normal(
            context: Get.context!,
            title: Text(LocaleKeys.profileHomeMenuDestory.tr),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.profileHomeMenuDestoryInfo.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'yes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 15),
                InputWidget(
                  hintText: 'Input',
                  fontSize: 14,
                  controller: controller.destroyInput,
                ),
              ],
            ),
            confirm: Text(LocaleKeys.commonBottomConfirm.tr),
            confirmBackgroundColor: Colors.red,
            onConfirm: controller.onDestroy,
          );
        },
      ),

      // 版权
      // const TextWidget.body2(
      //   "闪忆网址: https://sdbyxxkj.com",
      // ).alignCenter().paddingBottom(AppSpace.listRow),

      // 版本号
      TextWidget.body2(
        "版本号: v ${ConfigService.to.version}",
      ).alignCenter().paddingBottom(200),
    ].toColumn();
  }

  // 主视图
  Widget _buildView() {
    return <Widget>[
      _buildHeader(),
      _menus(),
    ].toColumn().paddingAll(AppSpace.page).safeArea().scrollable();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      // init: MyIndexController(),
      init: Get.find<MyIndexController>(),
      id: "my_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            //主题色
            backgroundColor: Colors.transparent,
            //不局中
            centerTitle: false,
            title: Text(LocaleKeys.profileHomeTitle.tr),
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
