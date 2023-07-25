/// 节
class SectionModel {
  String? id;
  String? uri;
  String? title;
  String? contentMd;
  String? subTitle;
  int? minutes;
  bool? isPreview;
  String? bili;
  String? youtube;
  bool? isDocOk;
  String? cover;
  String? videoUrl;

  SectionModel({
    this.id,
    this.uri,
    this.title,
    this.contentMd,
    this.subTitle,
    this.minutes,
    this.isPreview,
    this.bili,
    this.youtube,
    this.isDocOk,
    this.cover,
    this.videoUrl,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        id: json['id'] as String?,
        uri: json['uri'] as String?,
        title: json['title'] as String?,
        contentMd: json['content_md'] as String?,
        subTitle: json['sub_title'] as String?,
        minutes: json['minutes'] as int?,
        isPreview: json['is_preview'] as bool?,
        bili: json['bili'] as String?,
        youtube: json['youtube'] as String?,
        isDocOk: json['is_doc_ok'] as bool?,
        cover: json['cover'] as String?,
        videoUrl: json['video_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'title': title,
        'content_md': contentMd,
        'sub_title': subTitle,
        'minutes': minutes,
        'is_preview': isPreview,
        'bili': bili,
        'youtube': youtube,
        'is_doc_ok': isDocOk,
        'cover': cover,
        'video_url': videoUrl,
      };
}
