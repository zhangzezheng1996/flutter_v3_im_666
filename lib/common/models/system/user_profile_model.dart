class UserProfileModel {
  String? id;
  int? levelId;
  String? username;
  String? password;
  String? nickname;
  String? mobile;
  String? email;
  String? avatar;
  int? gender;
  dynamic birth;
  String? city;
  String? job;
  String? sign;
  int? sourceType;
  int? integration;
  int? growth;
  int? status;
  String? createTime;
  String? socialUid;
  String? accessToken;
  String? expiresIn;
  int? version;
  String? background;
  String? imSign;

  UserProfileModel({
    this.id,
    this.levelId,
    this.username,
    this.password,
    this.nickname,
    this.mobile,
    this.email,
    this.avatar,
    this.gender,
    this.birth,
    this.city,
    this.job,
    this.sign,
    this.sourceType,
    this.integration,
    this.growth,
    this.status,
    this.createTime,
    this.socialUid,
    this.accessToken,
    this.expiresIn,
    this.version,
    this.background,
    this.imSign,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] as String?,
        levelId: json['levelId'] as int?,
        username: json['username'] as String?,
        password: json['password'] as String?,
        nickname: json['nickname'] as String?,
        mobile: json['mobile'] as String?,
        email: json['email'] as String?,
        avatar: json['avatar'] as String?,
        gender: json['gender'] as int?,
        birth: json['birth'] as dynamic,
        city: json['city'] as String?,
        job: json['job'] as String?,
        sign: json['sign'] as String?,
        sourceType: json['sourceType'] as int?,
        integration: json['integration'] as int?,
        growth: json['growth'] as int?,
        status: json['status'] as int?,
        createTime: json['createTime'] as String?,
        socialUid: json['socialUid'] as String?,
        accessToken: json['accessToken'] as String?,
        expiresIn: json['expiresIn'] as String?,
        version: json['version'] as int?,
        background: json['background'] as String?,
        imSign: json['imSign'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'levelId': levelId,
        'username': username,
        'password': password,
        'nickname': nickname,
        'mobile': mobile,
        'email': email,
        'avatar': avatar,
        'gender': gender,
        'birth': birth,
        'city': city,
        'job': job,
        'sign': sign,
        'sourceType': sourceType,
        'integration': integration,
        'growth': growth,
        'status': status,
        'createTime': createTime,
        'socialUid': socialUid,
        'accessToken': accessToken,
        'expiresIn': expiresIn,
        'version': version,
        'background': background,
        'imSign': imSign,
      };
}
