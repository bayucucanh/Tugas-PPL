import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class NotificationRequest extends NetworkBase {
  Future<Resource<List<Message>>> getNotifications(
      {int? page = 1, int? limit = 15}) async {
    var resp = await network.get('/notifications', queryParameters: {
      'sortBy': 'created_at',
      'limit': limit,
      'page': page,
    });
    return Resource(
      data: (resp?.data['data'])
          .map<Message>((data) => Message.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<int?> totalUnreadNotification() async {
    var resp = await network.get('/notifications/unread/count');

    return int.tryParse(resp!.data['data']['unread_notification'].toString());
  }

  Future<void> readNotification({required String? id}) async {
    await network.get('/notifications/read/$id');
  }

  Future<void> markAllNotification() async {
    await network.patch('/notifications/mark/all');
  }
}
