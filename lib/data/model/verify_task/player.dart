class Player {
  int? id;
  String? name;

  Player({this.id, this.name});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
