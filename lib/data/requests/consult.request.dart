import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/consultation.dart';
import 'package:mobile_pssi/data/model/consultation_quota.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class ConsultRequest extends NetworkBase {
  Future<Consultation> createRoom({
    required int coachUserId,
    required int quotaId,
    String? message,
  }) async {
    var resp = await network.post('/consultation/create', body: {
      'quota_id': quotaId,
      'coach_user_id': coachUserId,
      'message': message,
    });

    return Consultation.fromJson(resp?.data['data']);
  }

  Future<Resource<List<Consultation>>> getMyConsultations({
    int? page = 1,
  }) async {
    var resp = await network.get('/consultation/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Consultation>((data) => Consultation.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<Consultation>>> getConsultations({
    int? page = 1,
  }) async {
    var resp = await network.get('/consultation/list', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Consultation>((data) => Consultation.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<Message>>> getRoomChats({
    required int consultId,
    int? page = 1,
  }) async {
    var resp = await network
        .get('/consultation/chat/room/$consultId', queryParameters: {
      'sortBy': 'created_at',
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

  Future<void> chat({
    required int consultId,
    String? message,
    int? receiverId,
  }) async {
    await network.post('/consultation/chat/message', body: {
      'consultation_id': consultId,
      'message': message,
      'receiver_id': receiverId,
    });
  }

  Future<List<dynamic>> getMyQuota(int coachId) async {
    var resp = await network.get('/consultation/my/quota/$coachId');
    return [
      (resp?.data['data'] as List)
          .map((e) => ConsultationQuota.fromJson(e))
          .toList(),
      resp?.data['total_quota'],
    ];
  }

  Future<void> addQuota({required String orderId}) async {
    await network.post('/consultation/my/quota', body: {
      'order_id': orderId,
    });
  }

  Future<void> endConsult({required String roomId}) async {
    await network.post('/consultation/close', body: {
      'room_id': roomId,
    });
  }

  Future<void> rateConsult({
    required String roomId,
    required double rating,
    String? comment,
  }) async {
    await network.post('/consultation/rate', body: {
      'room_id': roomId,
      'rating': rating,
      'comment': comment,
    });
  }

  Future<Consultation> getDetail({
    required String roomId,
  }) async {
    var resp = await network.get('/consultation/detail/$roomId');

    return Consultation.fromJson(resp?.data['data']);
  }
}
