class UserModel {
  String? id;
  String? username;
  String? nickname;
  String? avatar;

  UserModel({
    this.id,
    this.username,
    this.nickname,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      // username: json['attributes']['username'] as String?,
      // nickname: json['attributes']['nick_name'] as String?,
      // avatar: json['attributes']['avatar'] as String?,
      username: json['username'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nickname': nickname,
        'avatar': avatar,
      };
}
