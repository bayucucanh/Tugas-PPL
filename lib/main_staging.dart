import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/firebase_options.dart';
import 'package:mobile_pssi/services/midtrans/midtrans_service.dart';
import 'package:mobile_pssi/services/notification_service.dart';
import 'package:mobile_pssi/web_app.dart';

import 'app.dart';
import 'flavors.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance
      .sendLocalNotification(Message.fromRemoteMessage(message));
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  F.appFlavor = Flavor.staging;
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  Fimber.plantTree(DebugTree(useColors: true));
  if (kIsWeb) {
    webApp();
  } else {
    mobileApp();
  }
}

void mobileApp() async {
  MidtransService.instance.init();
  await NotificationService.instance.init(_firebaseMessagingBackgroundHandler);
  runApp(App());
}

void webApp() async {
  runApp(WebApp());
}
