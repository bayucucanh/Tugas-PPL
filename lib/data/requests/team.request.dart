import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/age_group.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';

class TeamRequest extends NetworkBase {
  Future<Resource<List<AgeGroup>>> fetchAgeGroups({String? option}) async {
    var resp = await network.get('/team/age-groups', queryParameters: {
      'option': option,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<AgeGroup>((data) => AgeGroup.fromJson(data))
          .toList(),
    );
  }

  Future<Resource<List<Team>>> getMyTeams(
      {required int clubId, String? option, int? page = 1}) async {
    var resp = await network.get('/team/club/$clubId', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Team>((data) => Team.fromJson(data))
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

  Future<void> createTeam({
    required FormData data,
  }) async {
    await network.post('/team', body: data);
  }

  Future<void> update({
    required int teamId,
    required FormData data,
  }) async {
    await network.post('/team/$teamId/update', body: data);
  }

  Future<Team> getDetailTeam(
      {required int teamId, int? page = 1, bool? withSecureDocument}) async {
    var resp = await network.get('/team/detail/$teamId', queryParameters: {
      'with_secure_document': withSecureDocument,
    });

    return Team.fromJson(resp?.data['data']);
  }

  Future<Resource<List<ClubPlayer>>> getClubPlayers({
    required int clubId,
    String? search,
    int? page = 1,
  }) async {
    var resp =
        await network.get('/club/players/$clubId/list', queryParameters: {
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<ClubPlayer>((data) => ClubPlayer.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<ClubCoach>>> getClubCoaches({
    required int clubId,
    String? search,
    int? page = 1,
  }) async {
    var resp = await network.get('/coach/$clubId/club', queryParameters: {
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<ClubCoach>((data) => ClubCoach.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<ClubPlayer> getClubPlayerPositions(
      {int? clubPlayerId, String? option = 'select'}) async {
    var resp = await network
        .get('/team/player/$clubPlayerId/positions', queryParameters: {
      'option': option,
    });

    return ClubPlayer.fromJson(resp?.data['data']);
  }

  Future<void> invitePlayer({
    int? teamId,
    int? clubPlayerId,
    PlayerPosition? position,
  }) async {
    await network.post('/team/add/player', body: {
      'team_id': teamId,
      'position': position?.id,
      'club_player_id': clubPlayerId,
    });
  }

  Future<void> inviteCoach({
    int? teamId,
    int? employeeId,
    CoachPosition? position,
  }) async {
    await network.post('/team/add/coach', body: {
      'team_id': teamId,
      'position': position?.id,
      'employee_id': employeeId,
    });
  }

  Future<void> cancelPlayer({
    int? playerTeamId,
  }) async {
    await network.delete('/team/delete/player/$playerTeamId');
  }

  Future<void> cancelCoach({
    int? coachTeamId,
  }) async {
    await network.delete('/team/delete/coach/$coachTeamId');
  }
}
