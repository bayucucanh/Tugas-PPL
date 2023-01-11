import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_pssi/app.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/firebase_options.dart';
import 'package:mobile_pssi/services/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance
      .sendLocalNotification(Message.fromRemoteMessage(message));
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.init(_firebaseMessagingBackgroundHandler);
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  Fimber.plantTree(DebugTree(useColors: true));
  runApp(App());
}
