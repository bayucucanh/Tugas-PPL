class PerformanceCategory {
  int? id;
  String? name;
  String? slug;
  int? status;

  PerformanceCategory({
    this.id,
    this.name,
    this.slug,
    this.status,
  });

  factory PerformanceCategory.fromJson(Map<String, dynamic> json) =>
      PerformanceCategory(
        id: json['id'] as int?,
        name: json['name'] as String?,
        slug: json['slug'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'status': status,
      };
}
