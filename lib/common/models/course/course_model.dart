import 'package:video_ducafecat_flutter_v3/common/index.dart';

/// 课程 模型
class CourseModel {
  String? id;
  String? uri;
  String? title;
  bool? isFree;
  String? subTitle;
  String? introMd;
  String? cover;
  int? order;
  List<String>? tags;
  List<dynamic>? marketing;
  List<ChapterModel>? chapters;
  List<AccessoryModel>? accessories;
  VideoPathModel? path;

  CourseModel({
    this.id,
    this.uri,
    this.title,
    this.isFree,
    this.subTitle,
    this.introMd,
    this.cover,
    this.order,
    this.tags,
    this.marketing,
    this.chapters,
    this.accessories,
    this.path,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] as String?,
        uri: json['uri'] as String?,
        title: json['title'] as String?,
        isFree: json['is_free'] as bool?,
        subTitle: json['sub_title'] as String?,
        introMd: json['intro_md'] as String?,
        cover: json['cover'] as String?,
        order: json['order'] as int?,
        tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
        marketing: json['marketing'] as List<dynamic>?,
        chapters: (json['chapters'] as List<dynamic>?)
            ?.map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        accessories: (json['accessories'] as List<dynamic>?)
            ?.map((e) => AccessoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        path: json['path'] == null
            ? null
            : VideoPathModel.fromJson(json['path'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'title': title,
        'is_free': isFree,
        'sub_title': subTitle,
        'intro_md': introMd,
        'cover': cover,
        'order': order,
        'tags': tags,
        'marketing': marketing,
        'chapters': chapters?.map((e) => e.toJson()).toList(),
        'accessories': accessories?.map((e) => e.toJson()).toList(),
        'path': path?.toJson(),
      };
}
