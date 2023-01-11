import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/learning_task.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/task_detail.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/observables/file_observable.dart';

class TaskRequest extends NetworkBase {
  Future<LearningTask> uploadVideo({
    required int learningId,
    String? videoUrl,
    FileObservable? videoFile,
  }) async {
    var resp = await network.post(
      '/learning/player/task-upload/$learningId',
      body: FormData.fromMap({
        'video': videoUrl,
        'video_file': videoFile?.path == null ? null : await MultipartFile.fromFile(videoFile!.path!, filename: videoFile.name),
      }),
    );

    return LearningTask.fromJson(resp?.data['data']);
  }

  Future<TaskDetail> getTaskDetail(int taskId) async {
    var resp = await network.get(
      '/task/detail/$taskId',
    );

    return TaskDetail.fromJson(resp?.data);
  }

  Future<VerifyTask> getTaskVerifyDetail(int verifyId) async {
    var resp = await network.get(
      '/task/verify/detail/$verifyId',
    );

    return VerifyTask.fromJson(resp?.data['data']);
  }

  Future<Resource<List<Message>>> getTaskMessage(int taskId,
      {int? page = 1}) async {
    var resp = await network.get('/message/task/$taskId',
        queryParameters: {'sortBy': 'id', 'orderBy': 'desc', 'page': page});

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

  Future<void> sendComment(int taskId, String? message) async {
    await network.post('/task/comment', body: {
      'message': message,
      'learning_task_id': taskId,
    });
  }

  Future<void> postTaskMessage(int taskId, String? message) async {
    await network.post('/message/task', body: {
      'message': message,
      'learning_task_id': taskId,
    });
  }

  Future<Resource<List<VerifyTask>>> getTaskList({int? page}) async {
    var resp = await network.get('/task/verify/list',
        queryParameters: {'sortBy': 'id', 'orderBy': 'desc', 'page': page});

    return Resource(
      data: (resp?.data['data'])
          .map<VerifyTask>((data) => VerifyTask.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> acceptTask(
    int verifyId,
    int taskId, {
    String? reason,
    String? score,
  }) async {
    await network.post('/task/verify/accept/$verifyId', body: {
      'reason': reason,
      'task_id': taskId,
      'score': score,
    });
  }

  Future<void> deniedTask(
    int verifyId,
    int taskId, {
    String? reason,
    String? score,
  }) async {
    await network.post('/task/verify/reject/$verifyId', body: {
      'reason': reason,
      'task_id': taskId,
      'score': score,
    });
  }

  Future<Resource<List<VerifyTask>>> getSubmittedTaskList(
      {int? page, int? playerId}) async {
    var resp = await network.get('/task/list/submitted', queryParameters: {
      'page': page,
      'player_id': playerId,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<VerifyTask>((data) => VerifyTask.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }
}
