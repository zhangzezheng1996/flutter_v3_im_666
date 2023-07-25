/// 常量
class Constants {
  // wp 服务器
  // static const wpApiBaseUrl = 'https://videoapi.ducafecat.tech';
  // static const wpApiBaseUrl = 'http://192.168.43.12:8888';
  static const wpApiBaseUrl = 'http://shanyi.natapp4.cc';

  // 图片服务器
  static const imageServer =
      "https://ducafecat.oss-cn-beijing.aliyuncs.com/ducafecat-video-flutter";

  // 用户协议网址
  static const userAgreement = "https://learn.ducafecat.tech/privacy-policy-2/";

  // 本地存储key
  static const storageLanguageCode = 'language_code';
  static const storageThemeCode = 'theme_code';
  static const storageAlreadyOpen = 'already_open'; // 首次打开
  static const storageToken = 'token'; // 登录成功后 token
  static const storageProfile = 'profile'; // 用户资料缓存

  //聊天信息列表
  static const storageChatConversations = 'storage_chat_conversations';
  //聊天消息列表
  static const storageChatMessages = 'storage_chat_messages';

  // AES
  static const aesKey = '';
  static const aesIV = '';

  // 首页离线
  static const storageHomeCourses = 'storage_home_courses';

  // 腾讯 tim app id
  static const timAppID = 1400747818;

  //抖音
  static String clientkey = "aw071q09sq8b8xdr";

  static String clientSecrett = "83dbda222470d65e7ba3888ec82e509e";
}
