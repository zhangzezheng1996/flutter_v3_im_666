/// 用户注册请求
class UserRegisterReq {
  String? username;
  String? password;
  String? email;
  String? verifyCode;

  UserRegisterReq({
    this.username,
    this.password,
    this.email,
    this.verifyCode,
  });

  factory UserRegisterReq.fromJson(Map<String, dynamic> json) {
    return UserRegisterReq(
      username: json['username'] as String?,
      password: json['password'] as String?,
      email: json['email'] as String?,
      verifyCode: json['verify_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'verify_code': verifyCode,
      };
}
