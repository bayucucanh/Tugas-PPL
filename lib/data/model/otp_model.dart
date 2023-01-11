/// total_loss : 1
/// message : "OTP yang anda masukan salah."

class OtpModel {
  OtpModel({
    int? totalLoss,
    String? message,
  }) {
    _totalLoss = totalLoss;
    _message = message;
  }

  OtpModel.fromJson(dynamic json) {
    _totalLoss = json['total_loss'];
    _message = json['message'];
  }
  int? _totalLoss;
  String? _message;

  int? get totalLoss => _totalLoss;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_loss'] = _totalLoss;
    map['message'] = _message;
    return map;
  }
}
