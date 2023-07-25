import 'section_model.dart';

/// 章
class ChapterModel {
  String? id;
  String? title;
  dynamic subTitle;
  dynamic cover;
  List<SectionModel>? sections;

  ChapterModel({this.id, this.title, this.subTitle, this.cover, this.sections});

  factory ChapterModel.fromJson(Map<String, dynamic> json) => ChapterModel(
        id: json['id'] as String?,
        title: json['title'] as String?,
        subTitle: json['sub_title'] as dynamic,
        cover: json['cover'] as dynamic,
        sections: (json['sections'] as List<dynamic>?)
            ?.map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sub_title': subTitle,
        'cover': cover,
        'sections': sections?.map((e) => e.toJson()).toList(),
      };
}
