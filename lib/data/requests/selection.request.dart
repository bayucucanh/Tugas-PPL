import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/selection_participant.dart';

class SelectionRequest extends NetworkBase {
  Future<bool> checkParticipation({required int selectionFormId}) async {
    var resp = await network
        .get('/promotions/selection-form/participant/$selectionFormId/check');

    if (resp?.data['data'] == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> participate({required int selectionFormId}) async {
    await network.post('/promotions/selection-form/apply', body: {
      'selection_form_id': selectionFormId,
    });
  }

  Future<Resource<List<SelectionParticipant>>> getMyParticipations(
      {int? page = 1}) async {
    var resp =
        await network.get('/promotions/selection-form/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<SelectionParticipant>(
              (data) => SelectionParticipant.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<SelectionParticipant>>> getParticipations({
    required int selectionFormId,
    int? page = 1,
  }) async {
    var resp = await network.get(
        '/promotions/selection-form/$selectionFormId/participants',
        queryParameters: {
          'page': page,
        });

    return Resource(
      data: (resp?.data['data'])
          .map<SelectionParticipant>(
              (data) => SelectionParticipant.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> changeStatusParticipate(
      {required int participantId, int? status}) async {
    await network.patch(
        '/promotions/selection-form/participant/$participantId/status',
        body: {
          'status': status,
        });
  }

  Future<void> acceptAll({required int selectionFormId}) async {
    await network
        .patch('/promotions/selection-form/$selectionFormId/status/accept');
  }
}
