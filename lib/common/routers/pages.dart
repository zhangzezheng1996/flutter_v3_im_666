import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ducafecat_flutter_v3/pages/index.dart';

import 'index.dart';

// 路由 Pages
class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  // 列表
  static List<GetPage> list = [
    // app 首页
    GetPage(
      name: RouteNames.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    GetPage(
      name: RouteNames.blogBlogIndex,
      page: () => const BlogIndexPage(),
    ),
    GetPage(
      name: RouteNames.blogPost,
      page: () => const PostPage(),
    ),

    GetPage(
      name: RouteNames.chatChat,
      page: () => const ChatPage(),
    ),
    GetPage(
      name: RouteNames.chatChatIndex,
      page: () => const ChatIndexPage(),
    ),
    GetPage(
      name: RouteNames.chatChatFindUser,
      page: () => const ChatFindUserPage(),
    ),

    GetPage(
      name: RouteNames.courseCourseIndex,
      page: () => const CourseIndexPage(),
    ),
    GetPage(
      name: RouteNames.courseDetail,
      page: () => const DetailPage(),
    ),
    GetPage(
      name: RouteNames.courseLearn,
      page: () => const LearnPage(),
    ),

    GetPage(
      name: RouteNames.messageMessage,
      page: () => const MessagePage(),
    ),
    GetPage(
      name: RouteNames.messageMessageIndex,
      page: () => const MessageIndexPage(),
    ),
    GetPage(
      name: RouteNames.myChangeEmail,
      page: () => const ChangeEmailPage(),
    ),
    GetPage(
      name: RouteNames.myChangePwd,
      page: () => const ChangePwdPage(),
    ),
    GetPage(
      name: RouteNames.myLanguage,
      page: () => const LanguagePage(),
    ),
    GetPage(
      name: RouteNames.myMyIndex,
      page: () => const MyIndexPage(),
    ),
    GetPage(
      name: RouteNames.myProfile,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: RouteNames.mySubscribe,
      page: () => const SubscribePage(),
    ),
    GetPage(
      name: RouteNames.myTheme,
      page: () => const ThemePage(),
    ),
    GetPage(
      name: RouteNames.stylesStylesIndex,
      page: () => const StylesIndexPage(),
    ),
    GetPage(
      name: RouteNames.systemLogin,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteNames.systemMain,
      page: () => const MainPage(),
    ),
    GetPage(
      name: RouteNames.systemRegister,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: RouteNames.systemRegisterPin,
      page: () => const RegisterPinPage(),
    ),
    GetPage(
      name: RouteNames.systemFindpwd,
      page: () => const FindpwdPage(),
    ),
    GetPage(
      name: RouteNames.systemFindpwdPin,
      page: () => const FindpwdPinPage(),
    ),
    GetPage(
      name: RouteNames.systemSplash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: RouteNames.systemUserAgreement,
      page: () => const UserAgreementPage(),
    ),
    GetPage(
      name: RouteNames.systemWelcome,
      page: () => const WelcomePage(),
    ),

    //post
    GetPage(
      name: RouteNames.postPostIndex,
      page: () => const PostIndexPage(),
    ),
    GetPage(
      name: RouteNames.postRecommend,
      page: () => const RecommendPage(),
    ),
    GetPage(
      name: RouteNames.postChatArea,
      page: () => const ChatAreaPage(),
    ),

    //correlative
    GetPage(
      name: RouteNames.correlativeCorrelativeIndex,
      page: () => const CorrelativeIndexPage(),
    ),

    GetPage(
      name: RouteNames.myDy,
      page: () => const DyPage(),
    ),
  ];
}
