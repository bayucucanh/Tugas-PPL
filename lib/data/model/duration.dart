class SuspendDuration {
  String? id;
  String? name;

  SuspendDuration({this.id, this.name});

  factory SuspendDuration.fromJson(Map<String, dynamic> json) =>
      SuspendDuration(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  
}
