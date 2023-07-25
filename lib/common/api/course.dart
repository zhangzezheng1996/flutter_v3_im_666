import '../index.dart';

/// 课程 api
class CourseApi {
  /// 列表
  static Future<List<CourseModel>> courses(
      {bool? isFree, int? page, int? prePage}) async {
    var res =
        await WPHttpService.to.get('/courses', params: {"is_free": isFree});

    List<CourseModel> items = [];
    for (var item in res.data) {
      items.add(CourseModel.fromJson(item));
    }
    // 排序 menuOrder , 小号在前
    // categories.sort((a, b) => a.menuOrder!.compareTo(b.menuOrder as int));
    return items;
  }

  /// 详情
  static Future<CourseModel> detail(String uri) async {
    var res = await WPHttpService.to.get(
      '/courses/$uri',
    );
    return CourseModel.fromJson(res.data);
  }

  /// 学习
  static Future<CourseModel> learn(String curi, String suri) async {
    var res = await WPHttpService.to.get(
      '/courses/learn2/$curi/$suri',
    );
    return CourseModel.fromJson(res.data);
  }
}
