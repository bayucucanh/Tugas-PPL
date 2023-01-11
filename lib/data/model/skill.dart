class Skill {
  int? id;
  String? name;
  String? description;
  String? image;
  String? blurhash;

  Skill({
    this.id,
    this.name,
    this.description,
    this.image,
    this.blurhash,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        blurhash: json['blurhash'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'blurhash': blurhash,
      };
}
