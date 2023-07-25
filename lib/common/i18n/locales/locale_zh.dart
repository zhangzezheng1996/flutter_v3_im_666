import '../locale_keys.dart';

/// 多语言 中文
Map<String, String> localeZh = {
  // 通用
  LocaleKeys.commonSearchInput: '输入关键字',
  LocaleKeys.commonBottomSave: '保存',
  // LocaleKeys.commonBottomRemove: '删除',
  // LocaleKeys.commonBottomCancel: '取消',
  LocaleKeys.commonBottomConfirm: '确认',
  LocaleKeys.commonBottomApply: '应用',
  LocaleKeys.commonBottomBack: '返回',
  LocaleKeys.commonSelectTips: '请选择',
  LocaleKeys.commonMessageSuccess: '@method 成功',
  LocaleKeys.commonMessageIncorrect: '@method 不正确',
  LocaleKeys.commonRemoveTitle: '移除确认',
  // LocaleKeys.commonRemoveContent: '你确定要移除 @name ?',

  // 时间
  LocaleKeys.timeMinutes: '分钟',
  LocaleKeys.timeYesterday: '昨天',

  // 主页
  LocaleKeys.appTitle: '猫哥',
  LocaleKeys.appSubTitle: '视频学习',

  // 课程
  LocaleKeys.courseFree: '免费',
  LocaleKeys.courseMember: '会员',

  // 样式
  LocaleKeys.stylesTitle: '样式 && 功能 && 调试',

  // 验证提示
  LocaleKeys.validatorRequired: '字段不能为空',
  LocaleKeys.validatorEmail: '请输入 email 格式',
  LocaleKeys.validatorMin: '长度不能小于 @size',
  LocaleKeys.validatorMax: '长度不能大于 @size',
  LocaleKeys.validatorPassword: '密码长度必须 大于 @min 小于 @max',

  // 拍照、相册
  LocaleKeys.pickerTakeCamera: '拍照',
  LocaleKeys.pickerSelectAlbum: '从相册中选取',

  /////////////////////////////////////////////////////////////////

  // welcome 欢迎
  LocaleKeys.welcomeOneTitle: '选择您喜欢的课程',
  LocaleKeys.welcomeOneDesc: '全栈课程 移动 前端 后端',
  LocaleKeys.welcomeTwoTitle: '完成您的课程',
  LocaleKeys.welcomeTwoDesc: '完整的课程资料 文档、代码、设计稿、API接口',
  LocaleKeys.welcomeThreeTitle: '随时随地的学习体验',
  LocaleKeys.welcomeThreeDesc: 'PC端、手机端、IPAD 都可以学习',
  LocaleKeys.welcomeSkip: '跳过',
  LocaleKeys.welcomeNext: '下一页',
  LocaleKeys.welcomeStart: '立刻开始',

  // 登录、注册 - 通用
  LocaleKeys.loginForgotPassword: '忘记密码?',
  LocaleKeys.loginSignIn: '登 陆',
  LocaleKeys.loginSignUp: '注 册',
  LocaleKeys.loginOrText: '- 或者 -',

  // 注册 - register user
  LocaleKeys.registerTitle: '欢迎',
  LocaleKeys.registerDesc: '注册新账号',
  LocaleKeys.registerFormName: '登录账号',
  LocaleKeys.registerFormEmail: '电子邮件',
  LocaleKeys.registerFormPhoneNumber: '电话号码',
  LocaleKeys.registerFormPassword: '密码',
  LocaleKeys.registerFormRePassword: '确认密码',
  LocaleKeys.registerFormFirstName: '姓',
  LocaleKeys.registerFormLastName: '名',
  LocaleKeys.registerHaveAccount: '你有现成账号?',
  LocaleKeys.registerPasswordError: '密码两次输入不一致',
  LocaleKeys.registerUserAgreement: '阅读用户协议',
  LocaleKeys.registerUserAgreementError: '请确认用户协议',

  // 注册PIN - register pin
  LocaleKeys.registerPinTitle: '输入邮件验证码',
  LocaleKeys.registerPinDesc: '我们将向您发送邮件验证码以继续您的帐户注册',
  LocaleKeys.registerPinFormTip: '验证码',
  LocaleKeys.registerPinButton: '提交',

  // 找回密码 - find pwd
  LocaleKeys.findpwdTitle: '找回密码',
  LocaleKeys.findpwdDesc: '通过 email 找回密码',
  LocaleKeys.findpwdFormEmail: 'Email',
  LocaleKeys.findpwdFormPassword: '新密码',
  LocaleKeys.findpwdFormRePassword: '重复新密码',
  LocaleKeys.findpwdPasswordError: '密码两次输入不一致',

  // 找回密码PIN - find pwd pin
  LocaleKeys.findpwdPinTitle: '输入邮件验证码',
  LocaleKeys.findpwdPinDesc: '我们将向您发送邮件验证码以继续重置密码',
  LocaleKeys.findpwdPinFormTip: '验证码',
  LocaleKeys.findpwdPinButton: '提交',

  // 登录 - back login
  LocaleKeys.loginBackTitle: '欢迎登陆!',
  LocaleKeys.loginBackDesc: '登陆后继续',
  LocaleKeys.loginBackFieldEmail: '账号',
  LocaleKeys.loginBackFieldPassword: '登陆密码',

  // APP 导航
  LocaleKeys.tabBarHome: '首页',
  LocaleKeys.tabBarBlog: '博客',
  LocaleKeys.tabBarMessage: '聊天',
  LocaleKeys.tabBarProfile: '我的',

  /////////////////////////////////////////////////////////////////

  // 课程 详情页
  LocaleKeys.courseDetailTitle: '课程',
  LocaleKeys.courseDetailTabInfo: '介绍',
  LocaleKeys.courseDetailTabChapter: '章节',
  LocaleKeys.courseDetailChapterCount: '章数',
  LocaleKeys.courseDetailSectionCount: '节数',
  LocaleKeys.courseDetailTimes: '小时',

  // 课程 学习页
  LocaleKeys.courseLearnTitle: '学习',
  LocaleKeys.courseLearnTabMarkdown: '文档',
  LocaleKeys.courseLearnTabAccessorie: '附件',
  LocaleKeys.courseLearnTabOutline: '大纲',
  LocaleKeys.courseLearnNoAccessorie: '本课程没有附件.',

  // 我的 首页
  LocaleKeys.profileHomeTitle: '我的',
  LocaleKeys.profileHomeEmail: '邮件',
  LocaleKeys.profileHomeUserID: '用户 ID',
  LocaleKeys.profileHomeRegisterDate: '注册日期',
  LocaleKeys.profileHomeVipDeadline: '会员截止期日',
  LocaleKeys.profileHomeMenuChangeEmail: '修改邮件',
  LocaleKeys.profileHomeMenuChangePassword: '修改密码',
  LocaleKeys.profileHomeMenuChangeLanguage: '选择语言',
  LocaleKeys.profileHomeMenuChangeTheme: '切换主题',
  LocaleKeys.profileHomeMenuLogout: '退出登录',
  LocaleKeys.profileHomeMenuDestory: '销毁当前账户',
  LocaleKeys.profileHomeMenuDestoryInfo: '如果销毁当前账户,所属的vip资格、学习资料将全部被取消！',

  // 修改邮箱
  LocaleKeys.changeEmailTitle: '修改 Email',
  LocaleKeys.changeEmailTip: '请正确输入，以便接收邮件通知.',

  // 修改密码
  LocaleKeys.changePasswordTitle: '修改密码',
  LocaleKeys.changePasswordOld: '旧密码',
  LocaleKeys.changePasswordNew: '新密码',
  LocaleKeys.changePasswordConfirm: '重新输入',
  LocaleKeys.changePasswordErrTip: '新密码不一致，请重新输入',
// 消息
  // LocaleKeys.messageTitle: '消息',

  // 聊天
  // LocaleKeys.chatTitle: '聊天',
  // LocaleKeys.chatBarBtnSend: '发送',
  // LocaleKeys.chatBtnStart: '开聊',
  // LocaleKeys.chatTipDeleteConversation: '删除会话成功',
  // LocaleKeys.chatTipCreateChatFail: '创建聊天失败',
  // LocaleKeys.chatGroupTitle: '群聊 (@count)',
  // LocaleKeys.chatMessageUnit: '条',
  // LocaleKeys.chatCustomMessageGroupCreate: '@members 加入了聊天',
  // LocaleKeys.chatAppNotificationMessage: '@sender 给你发了新消息',

  // 聊天错误
  // LocaleKeys.chatErrorInit: '聊天初始化错误',
  // LocaleKeys.chatErrorDismissedGroup: '群聊已解散',
  // LocaleKeys.chatErrorConnectFailed: '您与服务器已断开，网络连接失败！',
  // LocaleKeys.chatErrorKickedOffline: '您的账号在其他设备登录，您已被迫下线，立刻重连？',
  // LocaleKeys.chatErrorMsgStatusSendFail: '发送失败，双击消息重发',

  // 群设置
  // LocaleKeys.chatGroupSettingMemberAdd: '+ 添加成员',
  // LocaleKeys.chatGroupSettingName: '群聊名称',
  // LocaleKeys.chatGroupSettingQuit: '退出群聊',
  // LocaleKeys.chatGroupSettingDismiss: '解散群聊',
  // LocaleKeys.chatGroupSettingMemberKick: '移除成员',

  // 聊天群提示类型
  // LocaleKeys.chatGroupTipEnter: '@members 进入了群聊天',
  // LocaleKeys.chatGroupTipInvited: '@members 被邀请入群',
  // LocaleKeys.chatGroupTipQuit: '@members 退出群',
  // LocaleKeys.chatGroupTipKick: '@members 被踢出群聊',
  // LocaleKeys.chatGroupTipSetAdmin: '@members 设置管理员',
  // LocaleKeys.chatGroupTipCancelAdmin: '@members 取消管理员',
  // LocaleKeys.chatGroupTipChangeInfo: '群资料变更',
  // LocaleKeys.chatGroupTipChangeMemberInfo: '@members 群成员资料变更',
};
