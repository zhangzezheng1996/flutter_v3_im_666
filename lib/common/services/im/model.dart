/// 服务器状态
enum IMServerStatus {
  none,
  connecting, // 正在连接服务器
  success, // 连机成功
  failed, // 连机失败
}

/// 用户状态
enum IMUserStatus {
  none,
  login, // 登录成功
  failed, // 登录失败
  offline, // 断开连接
  expired, // 登录过期
  kicked, // 被踢下线
}

/// 自定义消息
enum IMCustomMessageType {
  c2cCreate, // 单聊天开始
  enter, // 进入聊天
  groupCreate, // 群聊开始
  groupKicked, // 群聊踢出
}

/// 群消息类型
/// 1:主动入群（memberList 加入群组，非 Work 群有效）
/// 2:被邀请入群（opMember 邀请 memberList 入群，Work 群有效）
/// 3:退出群 (opMember 退出群组)
/// 4:踢出群 (opMember 把 memberList 踢出群组)
/// 5:设置管理员 (opMember 把 memberList 设置为管理员)
/// 6:取消管理员 (opMember 取消 memberList 管理员身份)
/// 7:群资料变更 (opMember 修改群资料： groupName & introduction & notification & faceUrl & owner & custom)
/// 8:群成员资料变更 (opMember 修改群成员资料：muteTime)
enum IMGroupTipsType {
  unknown, // 未知 0
  enter, // 主动入群 1
  invited, // 被邀请入群 2
  leave, // 主动退群 3
  kicked, // 被踢出群  4
  setAdmin, // 被设置为管理员 5
  cancelAdmin, // 被取消管理员 6
  groupInfoChange, // 群资料变更  7
  memberInfoChange, // 群成员资料变更 8
}

///////////////////////////////////////

/// IM 状态
class IMStatus {
  IMServerStatus? server; // 服务器
  IMUserStatus? user; // 用户
  IMStatus({this.server, this.user});
}
