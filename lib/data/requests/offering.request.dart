import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/club_coach_offering.dart';
import 'package:mobile_pssi/data/model/club_player_offering.dart';
import 'package:mobile_pssi/data/model/coach_offering.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/player_offering.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:path/path.dart';

class OfferingRequest extends NetworkBase {
  Future<String> offerPlayer({
    required int? playerId,
    required List<int?>? positions,
    required String? offerText,
    required File? offerFile,
  }) async {
    FormData data = FormData.fromMap({
      'player_id': playerId,
      'positions[]': positions,
      'offer_text': offerText,
      'offer_file': await MultipartFile.fromFile(offerFile!.path,
          filename: basename(offerFile.path)),
    });
    var resp = await network.post('/offer/player', body: data);

    return resp?.data['message'];
  }

  Future<String> offerCoach({
    required int? employeeId,
    required List<int?>? positions,
    required String? offerText,
    required File? offerFile,
  }) async {
    FormData data = FormData.fromMap({
      'employee_id': employeeId,
      'positions[]': positions,
      'offer_text': offerText,
      'offer_file': await MultipartFile.fromFile(offerFile!.path,
          filename: basename(offerFile.path)),
    });
    var resp = await network.post('/offer/coach', body: data);

    return resp?.data['message'];
  }

  Future<PlayerOffering> detailOfferPlayer({required int? offerId}) async {
    var resp = await network.get('/offer/player/detail/$offerId');

    return PlayerOffering.fromJson(resp?.data['data']);
  }

  Future<CoachOffering> detailOfferCoach({required int? offerId}) async {
    var resp = await network.get('/offer/coach/detail/$offerId');

    return CoachOffering.fromJson(resp?.data['data']);
  }

  Future<void> changeStatusOfferPlayer({int? offerId, int? status}) async {
    await network.patch('/offer/player/change/$offerId', body: {
      'status': status,
    });
  }

  Future<void> changeStatusOfferCoach({int? offerId, int? status}) async {
    await network.patch('/offer/coach/change/$offerId', body: {
      'status': status,
    });
  }

  Future<Resource<List<PlayerOffering>>> historyOfferingPlayers({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/players', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<PlayerOffering>((data) => PlayerOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<ClubPlayerOffering>>> clubPlayerOfferings({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/club/', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<ClubPlayerOffering>((data) => ClubPlayerOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<ClubCoachOffering>>> clubCoachOfferings({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/club/coach/', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<ClubCoachOffering>((data) => ClubCoachOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<ClubPlayerOffering>>> historyOfferingClubPlayers({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/club/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<ClubPlayerOffering>((data) => ClubPlayerOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<ClubCoachOffering>>> historyOfferingClubCoaches({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/club/coach/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<ClubCoachOffering>((data) => ClubCoachOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<CoachOffering>>> historyOfferingCoaches({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/coaches', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<CoachOffering>((data) => CoachOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> cancelOfferingPlayer({required int? offerId}) async {
    await network.delete('/offer/player/cancel/$offerId');
  }

  Future<void> cancelOfferingClubPlayer({required int? offerId}) async {
    await network.delete('/offer/club/cancel/$offerId');
  }

  Future<void> cancelOfferingClubCoach({required int? offerId}) async {
    await network.delete('/offer/club/coach/cancel/$offerId');
  }

  Future<void> cancelOfferingCoach({required int? offerId}) async {
    await network.delete('/offer/coach/cancel/$offerId');
  }

  Future<Resource<List<PlayerOffering>>> offerListPlayer({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/player', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<PlayerOffering>((data) => PlayerOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<CoachOffering>>> offerListCoach({
    int? page = 1,
  }) async {
    var resp = await network.get('/offer/coach', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<CoachOffering>((data) => CoachOffering.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<PlayerTeam>>> offersTeamPlayer({
    int? page = 1,
  }) async {
    var resp = await network.get('/team/offers/player', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<PlayerTeam>((data) => PlayerTeam.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<CoachTeam>>> offersTeamCoach({
    int? page = 1,
  }) async {
    var resp = await network.get('/team/offers/coach', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<CoachTeam>((data) => CoachTeam.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> changeStatusOfferTeamPlayer(
      {int? playerTeamId, int? status}) async {
    await network.patch('/team/offers/change/$playerTeamId/player', body: {
      'status': status,
    });
  }

  Future<void> transferPlayer(
      {int? clubPlayerOfferId, required FormData data}) async {
    await network.post('/offer/club/player/$clubPlayerOfferId/transfer',
        body: data);
  }

  Future<void> transferCoach(
      {int? clubCoachOfferId, required FormData data}) async {
    await network.post('/offer/club/coach/$clubCoachOfferId/transfer',
        body: data);
  }

  Future<void> changeStatusOfferTeamCoach(
      {int? coachTeamId, int? status}) async {
    await network.patch('/team/offers/change/$coachTeamId/coach', body: {
      'status': status,
    });
  }
}
