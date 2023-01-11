class Learning {
  int? id;
  String? name;

  Learning({this.id, this.name});

  factory Learning.fromJson(Map<String, dynamic> json) => Learning(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
