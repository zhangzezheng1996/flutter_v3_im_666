/// 视频地址
class VideoPathModel {
  String? thumbnail;
  String? url;

  VideoPathModel({this.thumbnail, this.url});

  factory VideoPathModel.fromJson(Map<String, dynamic> json) => VideoPathModel(
        thumbnail: json['thumbnail'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'thumbnail': thumbnail,
        'url': url,
      };
}
