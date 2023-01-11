import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/consultation_classification_user.dart';
import 'package:mobile_pssi/data/model/consultation_schedule.dart';

class ConsultClassificationRequest extends NetworkBase {
  Future<ConsultationClassificationUser> getMy() async {
    var resp = await network.get('/consultation/classification/my');

    return ConsultationClassificationUser.fromJsonWithLevel(resp?.data);
  }

  Future<void> setupWorkTime({required List<ScheduleForm> schedules}) async {
    await network.post('/consultation/schedules/create', body: {
      'schedules': schedules.map((e) => e.toJson()).toList(),
    });
  }

  Future<void> deleteSchedule({required int id}) async {
    await network.delete('/consultation/schedules/$id/delete');
  }
}
