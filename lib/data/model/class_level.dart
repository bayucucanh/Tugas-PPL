class ClassLevel {
  int? id;
  String? name;
  String? description;
  String? createdBy;

  ClassLevel({this.id, this.name, this.description, this.createdBy});

  factory ClassLevel.fromJson(Map<String, dynamic> json) => ClassLevel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        createdBy: json['created_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'created_by': createdBy,
      };
}
