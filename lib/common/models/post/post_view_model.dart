class PostViewModel {
  String? id;
  int? postType;
  String? chatAreaId;
  List<String>? images;

  PostViewModel({this.id, this.postType, this.chatAreaId, this.images});

  factory PostViewModel.fromJson(Map<String, dynamic> json) => PostViewModel(
        id: json['id'] as String?,
        postType: json['postType'] as int?,
        chatAreaId: json['chatAreaId'] as String?,
        images: json['images'].cast<String>(),
        // List<String> labelList = json['labelList'].cast<String>();
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'postType': postType,
        'chatAreaId': chatAreaId,
        'images': images,
      };
}
