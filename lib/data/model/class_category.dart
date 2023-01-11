class ClassCategory {
  int? id;
  String? name;
  String? description;
  String? image;
  String? blurhash;
  String? createdBy;

  ClassCategory({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.blurhash,
    this.image,
  });

  factory ClassCategory.fromJson(Map<String, dynamic> json) => ClassCategory(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        blurhash: json['blurhash'] as String?,
        image: json['image'] as String?,
        createdBy: json['created_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'blurhash': blurhash,
        'created_by': createdBy,
      };
}
