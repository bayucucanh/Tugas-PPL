class Help {
  int? id;
  String? title;
  String? slug;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;

  Help({
    this.content,
    this.createdAt,
    this.id,
    this.slug,
    this.title,
    this.updatedAt,
  });

  factory Help.fromJson(Map<String, dynamic> json) => Help(
        id: json['id'] as int?,
        title: json['title'] as String?,
        slug: json['slug'] as String?,
        content: json['content'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'content': content,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
