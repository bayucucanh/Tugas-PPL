/// message : "Registrasi berhasil. Silahkan periksa email yang telah didaftarkan untuk mengetahui kode OTP anda."
/// data : {"id":3,"username":"kevingg123","email":"kevin@mailinator.com","name":"Kevin","phone_number":"087811283379","address":null,"city_id":null,"city_name":null,"province_id":null,"province_name":null,"height":null,"weight":null,"dominant_foot":null,"national_id":null,"national_code":null,"national_name":null,"photo":null}
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYmUub2xhaHJhZ2Eua3VuY2kuY28uaWRcL2FwaVwvcGxheWVyXC9yZWdpc3RlciIsImlhdCI6MTY0Njg0MzczMCwibmJmIjoxNjQ2ODQzNzMwLCJqdGkiOiJqNmxsdVd5WUxYT1VZUEllIiwic3ViIjozLCJwcnYiOiJhMjBhOTgzZTRhOTM0ZGEwYTM4MzgzNWIyMTAyYzAxM2FlYzgyMjUzIn0.ZQKh5E3TA731mVHPrXRtW7mQnbmNuUSwsq05_WZDFeU"

class RegisterPlayerModel {
  RegisterPlayerModel({
    String? message,
    Data? data,
    String? token,
  }) {
    _message = message;
    _data = data;
    _token = token;
  }

  RegisterPlayerModel.fromJson(dynamic json) {
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _token = json['token'];
  }
  String? _message;
  Data? _data;
  String? _token;

  String? get message => _message;
  Data? get data => _data;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['token'] = _token;
    return map;
  }
}

/// id : 3
/// username : "kevingg123"
/// email : "kevin@mailinator.com"
/// name : "Kevin"
/// phone_number : "087811283379"
/// address : null
/// city_id : null
/// city_name : null
/// province_id : null
/// province_name : null
/// height : null
/// weight : null
/// dominant_foot : null
/// national_id : null
/// national_code : null
/// national_name : null
/// photo : null

class Data {
  Data({
    int? id,
    String? username,
    String? email,
    String? name,
    String? phoneNumber,
    dynamic address,
    dynamic cityId,
    dynamic cityName,
    dynamic provinceId,
    dynamic provinceName,
    dynamic height,
    dynamic weight,
    dynamic dominantFoot,
    dynamic nationalId,
    dynamic nationalCode,
    dynamic nationalName,
    dynamic photo,
  }) {
    _id = id;
    _username = username;
    _email = email;
    _name = name;
    _phoneNumber = phoneNumber;
    _address = address;
    _cityId = cityId;
    _cityName = cityName;
    _provinceId = provinceId;
    _provinceName = provinceName;
    _height = height;
    _weight = weight;
    _dominantFoot = dominantFoot;
    _nationalId = nationalId;
    _nationalCode = nationalCode;
    _nationalName = nationalName;
    _photo = photo;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _email = json['email'];
    _name = json['name'];
    _phoneNumber = json['phone_number'];
    _address = json['address'];
    _cityId = json['city_id'];
    _cityName = json['city_name'];
    _provinceId = json['province_id'];
    _provinceName = json['province_name'];
    _height = json['height'];
    _weight = json['weight'];
    _dominantFoot = json['dominant_foot'];
    _nationalId = json['national_id'];
    _nationalCode = json['national_code'];
    _nationalName = json['national_name'];
    _photo = json['photo'];
  }
  int? _id;
  String? _username;
  String? _email;
  String? _name;
  String? _phoneNumber;
  dynamic _address;
  dynamic _cityId;
  dynamic _cityName;
  dynamic _provinceId;
  dynamic _provinceName;
  dynamic _height;
  dynamic _weight;
  dynamic _dominantFoot;
  dynamic _nationalId;
  dynamic _nationalCode;
  dynamic _nationalName;
  dynamic _photo;

  int? get id => _id;
  String? get username => _username;
  String? get email => _email;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  dynamic get address => _address;
  dynamic get cityId => _cityId;
  dynamic get cityName => _cityName;
  dynamic get provinceId => _provinceId;
  dynamic get provinceName => _provinceName;
  dynamic get height => _height;
  dynamic get weight => _weight;
  dynamic get dominantFoot => _dominantFoot;
  dynamic get nationalId => _nationalId;
  dynamic get nationalCode => _nationalCode;
  dynamic get nationalName => _nationalName;
  dynamic get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['email'] = _email;
    map['name'] = _name;
    map['phone_number'] = _phoneNumber;
    map['address'] = _address;
    map['city_id'] = _cityId;
    map['city_name'] = _cityName;
    map['province_id'] = _provinceId;
    map['province_name'] = _provinceName;
    map['height'] = _height;
    map['weight'] = _weight;
    map['dominant_foot'] = _dominantFoot;
    map['national_id'] = _nationalId;
    map['national_code'] = _nationalCode;
    map['national_name'] = _nationalName;
    map['photo'] = _photo;
    return map;
  }
}
