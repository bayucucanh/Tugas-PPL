import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/student_participant.dart';

class NewStudentRequest extends NetworkBase {
  Future<bool> checkParticipation({required int studentFormId}) async {
    var resp = await network
        .get('/promotions/student-form/participant/$studentFormId/check');

    if (resp?.data['data'] == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> participate({required int studentFormId}) async {
    await network.post('/promotions/student-form/apply', body: {
      'new_student_form_id': studentFormId,
    });
  }

  Future<Resource<List<StudentParticipant>>> getMyParticipations(
      {int? page = 1}) async {
    var resp =
        await network.get('/promotions/student-form/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<StudentParticipant>((data) => StudentParticipant.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<StudentParticipant>>> getParticipations({
    required int studentFormId,
    int? page = 1,
  }) async {
    var resp = await network.get(
        '/promotions/student-form/$studentFormId/participants',
        queryParameters: {
          'page': page,
        });

    return Resource(
      data: (resp?.data['data'])
          .map<StudentParticipant>((data) => StudentParticipant.fromJson(data))
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
        '/promotions/student-form/participant/$participantId/status',
        body: {
          'status': status,
        });
  }

  Future<void> acceptAll({required int selectionFormId}) async {
    await network
        .patch('/promotions/student-form/$selectionFormId/status/accept');
  }
}
