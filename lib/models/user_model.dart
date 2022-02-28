class UserModel {
  late String name;

  late String email;

  late String phone;
  late String uID;

  late String profileImage;
  late String bio;

  List<dynamic>? followers;

  List<dynamic>? following;

  List<dynamic>? devices;


  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uID,
    required this.bio,
    required this.profileImage,
    required this.followers,
    required this.following,
    required this.devices,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    uID = json['uID'];
    profileImage = json['profileImage'];
    bio = json['bio'];
    followers = json['followers'];
    following = json['following'];
    devices = json['devices'];

  }

  Map<String, dynamic> toJason() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uID': uID,
      'profileImage': profileImage,
      'bio': bio,
      'followers': followers,
      'following': following,
      'devices':devices,
    };
  }
}
