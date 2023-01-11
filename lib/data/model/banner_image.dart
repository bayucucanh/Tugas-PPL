class BannerImage {
  int? id;
  String? title;
  String? description;
  String? imageUrl;
  String? blurhash;
  String? link;
  DateTime? expired;

  BannerImage({
    this.id,
    this.description,
    this.imageUrl,
    this.title,
    this.blurhash,
    this.link,
    this.expired,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        imageUrl: json['image'] as String?,
        blurhash: json['blurhash'] as String?,
        link: json['link'] as String?,
        expired: json['expired'] == null
            ? null
            : DateTime.parse(json['expired'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': imageUrl,
        'blurhash': blurhash,
        'link': link,
        'expired': expired?.toIso8601String(),
      };
}
