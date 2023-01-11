class ScatQuestion {
  int? id;
  String? question;
  int? rarely;
  int? sometimes;
  int? often;

  ScatQuestion({
    this.id,
    this.question,
    this.often,
    this.rarely,
    this.sometimes,
  });

  factory ScatQuestion.fromJson(Map<String, dynamic> json) => ScatQuestion(
        id: json['id'] as int?,
        question: json['question'] as String?,
        rarely: json['rarely_value'] as int?,
        sometimes: json['sometimes_value'] as int?,
        often: json['often_value'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'rarely_value': rarely,
        'sometimes_value': sometimes,
        'often_value': often,
      };
}
