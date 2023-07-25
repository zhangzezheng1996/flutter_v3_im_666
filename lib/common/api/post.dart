import '../index.dart';

/// Post api
class PostApi {
  //Post列表
  static Future<List<PostViewModel>> posts(PageReq? req) async {
    var res = await WPHttpService.to.get(
      '/api/post/postView/list',
      params: req?.toJson(),
    );

    List<PostViewModel> posts = [];

    for (var item in res.data['page']['list']) {
      posts.add(PostViewModel.fromJson(item));
    }
    return posts;
  }

  //保存创建的群聊
  static Future<dynamic> saveChatGroup(
    String groupId,
    String groupName,
    String ownerAccount,
    String type,
  ) async {
    return WPHttpService.to.post(
      '/api/post/group/save',
      data: {
        "name": groupName,
        "type": type,
        "id": groupId,
        "ownerAccount": ownerAccount,
      },
    );
  }
}
