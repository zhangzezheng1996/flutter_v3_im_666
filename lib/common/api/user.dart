import '../index.dart';

/// 用户 api
class UserApi {
  //手机号自动登录 获取token
  // static Future<UserTokenModel> phoneLogin(PhoneCodeRegistReq? req) async {
  //   var res = await WPHttpService.to.post(
  //     '/api/auth/member/phoneAutoRegister',
  //     data: req,
  //   );
  //   return UserTokenModel.fromJson(res.data);
  // }

  //手机号登录 获取token
  static Future<UserTokenModel> phoneLogin(String phone) async {
    Map<String, dynamic> req = {
      "phone": phone,
    };

    var res = await WPHttpService.to.get(
      '/api/member/member/phoneLogin',
      params: req,
    );

    return UserTokenModel.fromJson(res.data);
  }

  // 获取闪忆登录用户信息  请求头里面自
  static Future<UserProfileModel> profile() async {
    var res = await WPHttpService.to.get(
      '/api/member/member/getMemberInfo',
    );
    if (res.data['code'] == 200) {
      return UserProfileModel.fromJson(res.data['userInfo']);
    } else {
      //token过期
      return UserProfileModel();
    }
  }

  /// 注册
  static Future<bool> register(UserRegisterReq req) async {
    var res = await WPHttpService.to.post(
      '/users/register',
      data: req.toJson(),
    );

    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  /// 登录
  static Future<UserTokenModel> login(UserLoginReq req) async {
    var res = await WPHttpService.to.post(
      '/users/login',
      data: req.toJson(),
    );
    return UserTokenModel.fromJson(res.data);
  }

  /// Profile
  static Future<UserProfileModel> profile2() async {
    var res = await WPHttpService.to.get(
      '/users/me',
    );
    return UserProfileModel.fromJson(res.data);
  }

  /// 发送验证邮件
  static Future<UserProfileModel> sendEmailVerify(
      String email, String type) async {
    var res = await WPHttpService.to.post(
      '/users/verify',
      data: {
        'email': email,
        'type': type,
      },
    );
    return UserProfileModel.fromJson(res.data);
  }

  /// 找回密码
  static Future<void> findPassword(UserRegisterReq req) async {
    await WPHttpService.to.post(
      '/users/findpwd',
      data: {
        'email': req.email,
        'verify_code': req.verifyCode,
        'password': req.password,
      },
    );
  }

  /// 加密
  static Future<String> encrypt(String password) async {
    password = await EncryptUtil().sha(password);
    var res = await WPHttpService.to.post(
      '/users/encrypt',
      data: {
        'password': password,
      },
    );

    return res.data["hash"] as String;
  }

  /// 修改邮件
  static Future<void> changeEmail(
    String email,
  ) async {
    await WPHttpService.to.put(
      '/users/me',
      data: {
        'email': email,
      },
    );
  }

  /// 修改密码
  static Future<void> changePassword(
      String oldPassword, String reEnterPassword) async {
    await WPHttpService.to.put(
      '/users/me',
      data: {
        'old_password': oldPassword,
        'password': reEnterPassword,
      },
    );
  }

  /// 销毁账户
  static Future<void> destory() async {
    await WPHttpService.to.post(
      '/users/destory',
      data: {},
    );
  }

  /// tim 数据准备
  static Future<dynamic> chatPr9epare(List<String> uids) async {
    return WPHttpService.to.post(
      '/users/chatPrepare',
      data: {"user_ids": uids},
    );
  }

  /// tim 解散群聊天
  static Future<dynamic> chatDeleteGroup(
    String groupId,
    String userId,
  ) async {
    return WPHttpService.to.post(
      '/api/post/group/deleteGroup',
      data: {
        "groupId": groupId,
        "id": userId,
      },
    );
  }

  //创建群聊
  static Future<dynamic> chatCreateGroup(
    String groupName,
    String type,
  ) async {
    return WPHttpService.to.post(
      '/api/post/group/createGroup',
      data: {
        "name": groupName,
        "type": type,
      },
    );
  }

  /// 用户列表
  static Future<List<UserModel>> findList1(String keyword,
      {int? page, int? pageSize}) async {
    var res = await WPHttpService.to.post(
      '/users/findList',
      data: {
        "key": keyword,
        "page": page,
        "limit": pageSize,
      },
    );

    return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
  }

  /// 用户列表
  static Future<List<UserModel>> findList({
    int? page,
    int? pageSize,
    String? keyword,
  }) async {
    Map<String, dynamic> req = {
      "key": keyword,
      "page": page,
      "limit": pageSize,
    };
    String id = "0";
    var res = await WPHttpService.to.get(
      '/api/member/member/memberList/$id',
      params: req,
    );

    // return (res.data["page"]["list"] as List)
    //     .map((e) => UserModel.fromJson(e))
    //     .toList();

    List<UserModel> memberList = [];

    for (var item in res.data['page']['list']) {
      memberList.add(UserModel.fromJson(item));
    }

    return memberList;
  }
}
