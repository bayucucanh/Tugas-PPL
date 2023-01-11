import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/balance.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';

class UserRequest extends NetworkBase {
  Future<Resource<List<User>>> getUsers({String? search, int? page = 1}) async {
    var resp = await network.get('/users', queryParameters: {
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<User>((data) => User.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<User> getUserDetail({required int userId}) async {
    var resp = await network.get('/users/detail/$userId');

    return User.fromJson(resp?.data['data']);
  }

  Future<User> getProfile() async {
    var resp = await network.get('/auth/profile');
    return User.fromJson(resp?.data['data']);
  }

  Future<bool> checkPremium() async {
    var resp = await network.get('/premium/check');
    return resp?.data['premium'];
  }

  Future<void> saveProfile(FormData data) async {
    await network.post('/auth/update-profile', body: data);
  }

  Future<void> changePassword({
    String? password,
    String? passwordConfirmation,
  }) async {
    await network.post('/auth/change-password', body: {
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<void> connectSocialMedia({
    String? id,
    String? provider,
    bool? connecting,
  }) async {
    await network.patch('/auth/connect-social-media', body: {
      'social_media_id': id,
      'provider': provider,
      'connecting': connecting,
    });
  }

  Future<void> editUser({required int userId, List<int?>? accessRole}) async {
    await network.patch('/users/$userId', body: {'access_roles': accessRole});
  }

  Future<void> createUser({
    int? userType,
    String? username,
    String? password,
    String? rePassword,
    String? email,
    String? name,
    String? phoneNumber,
    String? birthOfDate,
    List<int?>? accessRole,
  }) async {
    await network.post('/users', body: {
      'user_type': userType,
      'name': name,
      'username': username,
      'password': password,
      'password_confirmation': rePassword,
      'email': email,
      'date_of_birth': birthOfDate,
      'phone_number': phoneNumber,
      'access_roles': accessRole,
    });
  }

  Future<Balance> getBalance() async {
    var resp = await network.get('/users/balance');
    return Balance.fromJson(resp?.data['data']);
  }

  Future<void> deleteAccount() async {
    await network.post('/users/deletion');
  }
}
