/// Post查询请求
class PageReq {
  /// 当前页码
  final int? page;

  /// 页尺寸
  final int? limit;

  /// 关键词
  final String? key;

  /// 排序方向 desc asc
  final String? order;

  /// 排序字段
  final String? sidx;

  PageReq({
    this.page,
    this.limit,
    this.sidx,
    this.order,
    this.key,
  });

  Map<String, dynamic> toJson() => {
        'page': page ?? 1,
        'limit': limit ?? 5,
        'sidx': sidx ?? 'id', //这里要注意
        'order': order ?? 'desc',
        'key': key ?? '',
      };
}
