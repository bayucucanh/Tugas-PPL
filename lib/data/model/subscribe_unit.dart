class SubscribeUnit
{
  String? id;
  String? name;

  SubscribeUnit({this.id, this.name});

  factory SubscribeUnit.fromJson(Map<String, dynamic> json) =>
      SubscribeUnit(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}