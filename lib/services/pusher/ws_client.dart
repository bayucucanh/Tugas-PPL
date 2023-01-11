import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pusher_client/pusher_client.dart';

class WsClient {
  WsClient._internal();

  static final WsClient instance = WsClient._internal();

  static PusherClient? _pusher;

  init() async {
    try {
      String? token = Storage.get(ProfileStorage.token);
      PusherOptions options = PusherOptions(
        host: F.isDev ? 'pssi-backend.test' : F.hostname,
        cluster: F.pusherCluster,
        wsPort: F.pusherPort,
        wssPort: F.pusherPort,
        encrypted: true,
        auth: PusherAuth(
          F.pusherAuthUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _pusher = PusherClient(F.pusherApiKey, options, autoConnect: true);

      _pusher?.onConnectionStateChange((state) {
        debugPrint(
            "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
      });

      _pusher?.onConnectionError((error) {
        debugPrint("error: ${error?.message}");
      });
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  // static _onConnectionStateChange(String currentState, String previousState) {
  //   debugPrint('Current State(Previous) : $currentState($previousState)');
  // }

  // static _onEvent(PusherEvent event) {
  //   debugPrint("onEvent: $event");
  // }

  // static _onError(String message, int? code, dynamic e) {
  //   debugPrint('Error ($code) : $message');
  // }

  // static _onSubscriptionSucceeded(String channelName, dynamic data) {
  //   debugPrint("onSubscriptionSucceeded: $channelName data: $data");
  // }

  // static _onSubscriptionError(String message, dynamic e) {
  //   debugPrint("onSubscriptionError: $message Exception: $e");
  // }

  // static _onDecryptionFailure(String event, String reason) {
  //   debugPrint("onDecryptionFailure: $event reason: $reason");
  // }

  // static _onMemberAdded(String channelName, PusherMember member) {
  //   debugPrint("onMemberAdded: $channelName member: $member");
  // }

  // static _onMemberRemoved(String channelName, PusherMember member) {
  //   debugPrint("onMemberRemoved: $channelName member: $member");
  // }

  // static _onAuthorizer(String channelName, String socketId, dynamic options) {
  //   debugPrint(
  //       "Channel Name: $channelName, Socket ID: $socketId, Options: $options");
  // }

  disconnect() async {
    await _pusher?.disconnect();
  }

  String? getSocketId() {
    return _pusher?.getSocketId();
  }

  // static PusherChannel? getChannel({required String channelName}) {
  //   return _pusher.getChannel(channelName);
  // }
}
