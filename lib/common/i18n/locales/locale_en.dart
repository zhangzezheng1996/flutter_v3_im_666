import '../locale_keys.dart';

/// 多语言 英文
Map<String, String> localeEn = {
  // 通用
  LocaleKeys.commonSearchInput: 'Enter keyword',
  LocaleKeys.commonBottomSave: 'Save',
  // LocaleKeys.commonBottomRemove: 'Remove',
  // LocaleKeys.commonBottomCancel: 'Cancel',
  LocaleKeys.commonBottomConfirm: 'Confirm',
  LocaleKeys.commonBottomApply: 'Apply',
  LocaleKeys.commonBottomBack: 'Back',
  LocaleKeys.commonSelectTips: 'Please select',
  LocaleKeys.commonMessageSuccess: '@method successfully',
  LocaleKeys.commonMessageIncorrect: '@method incorrect',
  LocaleKeys.commonRemoveTitle: 'Confirm Delete',
  // LocaleKeys.commonRemoveContent: 'Are you sure you want to delete @name ?',

  // 时间
  LocaleKeys.timeMinutes: 'minutes',
  LocaleKeys.timeYesterday: 'Yesterday',

  // 主页
  LocaleKeys.appTitle: 'ducafecat',
  LocaleKeys.appSubTitle: 'video learning',

  // 课程
  LocaleKeys.courseFree: 'Free',
  LocaleKeys.courseMember: 'Member',

  // 样式
  LocaleKeys.stylesTitle: 'Sytles && Function',

  // 验证提示
  LocaleKeys.validatorRequired: 'The field is obligatory',
  LocaleKeys.validatorEmail: 'The field must be an email',
  LocaleKeys.validatorMin: 'Length cannot be less than @size',
  LocaleKeys.validatorMax: 'Length cannot be greater than @size',
  LocaleKeys.validatorPassword:
      'password must have between @min and @max digits',

  // 拍照、相册
  LocaleKeys.pickerTakeCamera: 'Take camera',
  LocaleKeys.pickerSelectAlbum: 'Select from album',

  /////////////////////////////////////////////////////////////////

  // welcome 欢迎
  LocaleKeys.welcomeOneTitle: 'Choose the course you like',
  LocaleKeys.welcomeOneDesc: 'Full-stack courses Mobile front-end Backend',
  LocaleKeys.welcomeTwoTitle: 'Complete your course',
  LocaleKeys.welcomeTwoDesc:
      'Complete course materials Documentation, code, design drafts, API interfaces',
  LocaleKeys.welcomeThreeTitle: 'A learning experience anytime, anywhere',
  LocaleKeys.welcomeThreeDesc: 'PC, MOBILE, AND IPAD CAN ALL BE LEARNED',
  LocaleKeys.welcomeSkip: 'Skip',
  LocaleKeys.welcomeNext: 'Next',
  LocaleKeys.welcomeStart: 'Get Started',

  // 登录、注册 - 通用
  LocaleKeys.loginForgotPassword: 'Forgot Password?',
  LocaleKeys.loginSignIn: 'Sign In',
  LocaleKeys.loginSignUp: 'Sign Up',
  LocaleKeys.loginOrText: '- OR -',

  // 注册 - new user
  LocaleKeys.registerTitle: 'Register',
  LocaleKeys.registerDesc: 'Sign up to continue',
  LocaleKeys.registerFormName: 'User Name',
  LocaleKeys.registerFormEmail: 'Email',
  LocaleKeys.registerFormPhoneNumber: 'Phone number',
  LocaleKeys.registerFormPassword: 'Password',
  LocaleKeys.registerFormRePassword: 'Confirm password',
  LocaleKeys.registerFormFirstName: 'First name',
  LocaleKeys.registerFormLastName: 'Last name',
  LocaleKeys.registerHaveAccount: 'Already have an account?',
  LocaleKeys.registerPasswordError: 'The password entered twice does not match',
  LocaleKeys.registerUserAgreement: 'Read user agreement',
  LocaleKeys.registerUserAgreementError: 'Please confirm the user agreement',

  // 注册PIN - register pin
  LocaleKeys.registerPinTitle: 'Enter the email verification code',
  LocaleKeys.registerPinDesc:
      'We will send you an email verification code to proceed with your account registration',
  LocaleKeys.registerPinFormTip: 'Verification code',
  LocaleKeys.registerPinButton: 'Submit',

  // 找回密码 - find pwd
  LocaleKeys.findpwdTitle: 'Find password',
  LocaleKeys.findpwdDesc: 'Recover password by email',
  LocaleKeys.findpwdFormEmail: 'Email',
  LocaleKeys.findpwdFormPassword: 'New password',
  LocaleKeys.findpwdFormRePassword: 'Repeat new password',
  LocaleKeys.findpwdPasswordError: 'The password entered twice does not match',

  // 找回密码PIN - find pwd pin
  LocaleKeys.findpwdPinTitle: 'Enter the email verification code',
  LocaleKeys.findpwdPinDesc:
      'We\'ll send you an email verification code to proceed with resetting your password',
  LocaleKeys.findpwdPinFormTip: 'Verification code',
  LocaleKeys.findpwdPinButton: 'Submit',

  // 登录 - back login
  LocaleKeys.loginBackTitle: 'Welcome login!',
  LocaleKeys.loginBackDesc: 'Sign in to continue',
  LocaleKeys.loginBackFieldEmail: 'Name',
  LocaleKeys.loginBackFieldPassword: 'Password',

  // APP 导航
  LocaleKeys.tabBarHome: 'Home',
  LocaleKeys.tabBarBlog: 'Blog',
  LocaleKeys.tabBarMessage: 'Chat',
  LocaleKeys.tabBarProfile: 'Profile',

  /////////////////////////////////////////////////////////////////

  // 课程详情页
  LocaleKeys.courseDetailTitle: 'Course',
  LocaleKeys.courseDetailTabInfo: 'Detail',
  LocaleKeys.courseDetailTabChapter: 'Chapter',
  LocaleKeys.courseDetailChapterCount: 'Chapters',
  LocaleKeys.courseDetailSectionCount: 'Sections',
  LocaleKeys.courseDetailTimes: 'Hours',

  // 课程 学习页
  LocaleKeys.courseLearnTitle: 'Learn',
  LocaleKeys.courseLearnTabMarkdown: 'Document',
  LocaleKeys.courseLearnTabAccessorie: 'Accessorie',
  LocaleKeys.courseLearnTabOutline: 'Outline',
  LocaleKeys.courseLearnNoAccessorie:
      'There are no attachments to this course.',

  // 我的 首页
  LocaleKeys.profileHomeTitle: 'My',
  LocaleKeys.profileHomeEmail: 'Email',
  LocaleKeys.profileHomeUserID: 'User ID',
  LocaleKeys.profileHomeRegisterDate: 'Register Date',
  LocaleKeys.profileHomeVipDeadline: 'Vip Deadline',
  LocaleKeys.profileHomeMenuChangeEmail: 'Change Email',
  LocaleKeys.profileHomeMenuChangePassword: 'Change Password',
  LocaleKeys.profileHomeMenuChangeLanguage: 'Change Language',
  LocaleKeys.profileHomeMenuChangeTheme: 'Change Theme',
  LocaleKeys.profileHomeMenuLogout: 'Logout',
  LocaleKeys.profileHomeMenuDestory: 'Destroy the current account',
  LocaleKeys.profileHomeMenuDestoryInfo:
      'If you destroy your current account, all VIP qualifications and learning materials will be canceled!',

  // 修改邮箱
  LocaleKeys.changeEmailTitle: 'Change Email',
  LocaleKeys.changeEmailTip:
      'Please enter it correctly in order to receive email notifications.',

  // 修改密码
  LocaleKeys.changePasswordTitle: 'Change Password',
  LocaleKeys.changePasswordOld: 'Old Password',
  LocaleKeys.changePasswordNew: 'New Password',
  LocaleKeys.changePasswordConfirm: 'Re-enter',
  LocaleKeys.changePasswordErrTip:
      'The new password does not match, please re-enter it.',
// 消息
  // LocaleKeys.messageTitle: 'Message',

  // 聊天
  // LocaleKeys.chatTitle: 'Chat',
  // LocaleKeys.chatBarBtnSend: 'Send',
  // LocaleKeys.chatBtnStart: 'Start',
  // LocaleKeys.chatTipDeleteConversation: 'Delete conversation succeed',
  // LocaleKeys.chatTipCreateChatFail: 'Create chat fail',
  // LocaleKeys.chatGroupTitle: 'Group (@count)',
  // LocaleKeys.chatMessageUnit: 'Message',
  // LocaleKeys.chatCustomMessageGroupCreate: '@members create group',
  // LocaleKeys.chatAppNotificationMessage: '@sender Sent you a new message',

  // 聊天错误
  // LocaleKeys.chatErrorInit: 'Chat init error',
  // LocaleKeys.chatErrorDismissedGroup: 'Group has been dismissed',
  // LocaleKeys.chatErrorConnectFailed: 'Connect failed',
  // LocaleKeys.chatErrorKickedOffline:
  //     'Your account has been logged in on another device, you have been forced offline, reconnect immediately?',
  // LocaleKeys.chatErrorMsgStatusSendFail:
  //     'Sending failed, double-click the message to retransmit',

  // 群设置
  // LocaleKeys.chatGroupSettingMemberAdd: '+ Add member',
  // LocaleKeys.chatGroupSettingName: 'Group name',
  // LocaleKeys.chatGroupSettingQuit: 'Quit group',
  // LocaleKeys.chatGroupSettingDismiss: 'Dismiss group',
  // LocaleKeys.chatGroupSettingMemberKick: 'Kick group member',

  // 聊天群提示类型
  // LocaleKeys.chatGroupTipEnter: '@members enter group',
  // LocaleKeys.chatGroupTipInvited: 'invite @members to group',
  // LocaleKeys.chatGroupTipQuit: '@members quit group',
  // LocaleKeys.chatGroupTipKick: 'kick @members',
  // LocaleKeys.chatGroupTipSetAdmin: '@members set admin',
  // LocaleKeys.chatGroupTipCancelAdmin: '@members cancel admin',
  // LocaleKeys.chatGroupTipChangeInfo: 'change group info',
  // LocaleKeys.chatGroupTipChangeMemberInfo: '@members change member info'
};
