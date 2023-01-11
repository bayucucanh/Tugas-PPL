import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';

class AuthRequest extends NetworkBase {
  Future<Response<dynamic>?> login({
    required String username,
    required String password,
    String? token,
  }) async {
    return await network.post('/auth/login', body: {
      'username': username,
      'password': password,
      'token': token,
    });
  }

  Future<bool> isRegistered({String? email}) async {
    Map<String, dynamic> data = {'email': email};
    var resp = await network.post('/auth/check/social-media', body: data);
    if (resp?.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Response<dynamic>?> loginWithSocialMedia({
    required String provider,
    required String id,
    String? token,
    int? userType,
    String? name,
    String? email,
    String? phoneNumber,
    String? birthDate,
    String? photo,
    bool? register,
  }) async {
    Map<String, dynamic> data = {
      'provider': provider,
      'id': id,
      'token': token,
      'email': email,
    };

    if (register == true) {
      data.addAll({
        'user_type': userType,
        'name': name,
        'phone_number': phoneNumber,
        'date_of_birth': birthDate,
        'photo': photo,
      });
    }
    return await network.post('/auth/login/social-media', body: data);
  }

  Future<void> logout() async {
    await network.post('/auth/logout');
  }

  Future<void> updateFcmToken({String? token}) async {
    await network.put('/auth/update/token', body: {'token': token});
  }

  Future<void> forgotPassword({String? email}) async {
    await network.post('/auth/forgot-password', body: {
      'email': email,
    });
  }
}
