/// 附件
class AccessoryModel {
  String? id;
  String? fileName;
  String? fileUrl;

  AccessoryModel({this.id, this.fileName, this.fileUrl});

  factory AccessoryModel.fromJson(Map<String, dynamic> json) => AccessoryModel(
        id: json['id'] as String?,
        fileName: json['file_name'] as String?,
        fileUrl: json['file_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_name': fileName,
        'file_url': fileUrl,
      };
}
