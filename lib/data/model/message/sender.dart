import 'package:simple_gravatar/simple_gravatar.dart';

class Sender {
  int? id;
  int? userId;
  String? name;
  String? photo;
  String? photoUrl;
  String? ktpUrl;

  Sender({
    this.id,
    this.userId,
    this.name,
    this.photo,
    this.photoUrl,
    this.ktpUrl,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        name: json['name'] as String?,
        photo: json['photo'] as String?,
        photoUrl: json['photo_url'] as String?,
        ktpUrl: json['ktp_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'photo': photo,
        'photo_url': photoUrl,
        'ktp_url': ktpUrl,
      };

  String gravatar() {
    var gravatar = Gravatar(name.toString());
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }
}
