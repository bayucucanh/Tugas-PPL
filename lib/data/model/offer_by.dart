class OfferBy {
  int? userId;
  int? id;
  String? name;

  OfferBy({this.id, this.name, this.userId});

  factory OfferBy.fromJson(Map<String, dynamic> json) => OfferBy(
        id: json['id'] as int?,
        name: json['name'] as String?,
        userId: json['user_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'user_id': userId,
  };
}
