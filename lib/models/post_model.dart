class PostModel {
  String? uID;
  String? date;
  String? postText;

  List<dynamic>? postImages;
  List<dynamic>? postLikes;
  List<CommentModel>? comments;

  PostModel({
    required this.uID,
    required this.date,
    this.postText,
    this.postImages,
    this.postLikes,
    this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uID: json['uID'],
      date: json['date'],
      postText: json['postText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uID': uID,
      'date': date,
      'postText': postText,
      'postImages': postImages,
      'postLikes': postLikes,
      'comments':comments,
    };
  }
}
class CommentModel{
  String? uID;
  String? comment;

  CommentModel({
    required this.uID,
    required this.comment,
});

  Map<String, dynamic> toJson(){
    return{
      'uID': uID,
      'comment':comment,
    };
  }
}
