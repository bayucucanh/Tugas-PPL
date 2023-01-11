import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/event_participant.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class EventRequest extends NetworkBase {
  Future<Resource<List<Event>>> gets({
    int? limit,
    int? page = 1,
    String? option = 'select',
    String? target,
    String? eventType,
  }) async {
    var resp = await network.get('/events', queryParameters: {
      'limit': limit,
      'page': page,
      'option': option,
      'target': target,
      'event_type': eventType,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Event>((data) => Event.fromJson(data))
          .toList(),
      meta: option != null
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<Event> detail({required int eventId}) async {
    var resp = await network.get('/events/$eventId/detail');
    return Event.fromJson(resp?.data['data']);
  }

  Future<void> create({required FormData data}) async {
    await network.post('/events', body: data);
  }

  Future<void> update({required int eventId, required FormData data}) async {
    await network.post('/events/$eventId/update', body: data);
  }

  Future<void> registerEvent({required String orderCode}) async {
    await network.post('/events/register', body: {
      'order_code': orderCode,
    });
  }

  Future<void> checkEventRegistered({required int eventId}) async {
    await network.get('/events/$eventId/check/register');
  }

  Future<void> eventAvailability({required int eventId}) async {
    await network.get('/events/$eventId/check/availability');
  }

  Future<void> remove({required int eventId}) async {
    await network.delete('/events/$eventId/delete');
  }

  Future<Resource<List<EventParticipant>>> getParticipants({
    required int eventId,
    int? limit,
    int? page = 1,
    String? option,
    bool? filterOnlySolo,
    bool? filterByTeam,
  }) async {
    Map<String, dynamic> params = {
      'limit': limit,
      'page': page,
      'option': option,
    };
    if (filterOnlySolo == true) {
      params.addAll({
        'filterBySolo': true,
      });
    }

    if (filterByTeam == true) {
      params.addAll({
        'filterByTeam': true,
      });
    }
    var resp = await network.get('/events/$eventId/registrations',
        queryParameters: params);

    return Resource(
      data: (resp?.data['data'] as List)
          .map<EventParticipant>((data) => EventParticipant.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }
}
