import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/data/model/message/message.dart' as m;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotification = AwesomeNotifications();

  bool _initialized = false;

  Future<void> init(
      Future<void> Function(RemoteMessage) onBackgroundMessage) async {
    if (!_initialized) {
      _initializeTimeZone();

      _initializeFirebase(onBackgroundMessage);

      _initializeLocalNotification();

      _initialized = true;
    }
  }

  void _initializeTimeZone() async {
    tz.initializeTimeZones();
  }

  void _initializeFirebase(
      Future<void> Function(RemoteMessage) onBackgroundMessage) async {
    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) => _handleNotification(message));

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print(message.notification!.title);
    });

    if (GetPlatform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
        badge: true,
      );
    }

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  void _initializeLocalNotification() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    _localNotification.initialize(
      'resource://drawable/ic_launcher',
      [
        // notification icon
        NotificationChannel(
          channelGroupKey: 'prima_academy_id',
          channelKey: 'PrimaAcademyChannel',
          channelName: 'Prima Academy notifications',
          channelDescription: 'Prima Academy Channel Notification',
          channelShowBadge: true,
          enableLights: true,
          importance: NotificationImportance.High,
        ),
        //add more notification type with different configuration
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'prima_academy_id',
            channelGroupName: 'Prima Academy')
      ],
      debug: true,
    );
    //  AwesomeNotifications().setListeners(onActionReceivedMethod: ,onDismissActionReceivedMethod: ,onNotificationCreatedMethod: ,onNotificationDisplayedMethod: ,);
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // final DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: initializationSettingsAndroid,
    //         iOS: initializationSettingsIOS);

    // await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onDidReceiveBackgroundNotificationResponse: onBackgroundNotification,
    //     onDidReceiveNotificationResponse: selectNotification);
  }

  Future<void> _handleNotification(RemoteMessage message) async {
    // print(message.toMap());
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      _localNotification.createNotification(
          content: NotificationContent(
        id: notification.hashCode,
        channelKey: 'PrimaAcademyChannel', //channel configuration key
        title: notification.title,
        body: notification.body,
        displayOnForeground: true,
        displayOnBackground: true,
        groupKey: 'prima_academy_id',
        wakeUpScreen: true,
        actionType: ActionType.Default,
        fullScreenIntent: true,
        roundedBigPicture: true,
        showWhen: false,
        largeIcon: GetPlatform.isAndroid
            ? notification.android?.imageUrl
            : notification.apple?.imageUrl,
        bigPicture: GetPlatform.isAndroid
            ? notification.android?.imageUrl
            : notification.apple?.imageUrl,
        notificationLayout: NotificationLayout.BigPicture,
      ));
      // await _flutterLocalNotificationsPlugin.show(notification.hashCode,
      //     notification.title, notification.body, configuredLocalNotification());
    }
  }

  Future<void> sendLocalNotification(m.Message message) async {
    _localNotification.createNotification(
        content: NotificationContent(
      id: message.hashCode,
      displayOnForeground: true,
      displayOnBackground: true,
      groupKey: 'prima_academy_id',
      wakeUpScreen: true,
      actionType: ActionType.Default,
      fullScreenIntent: true,
      roundedBigPicture: true,
      showWhen: false,
      largeIcon: message.imageUrl,
      bigPicture: message.imageUrl,
      channelKey: 'PrimaAcademyChannel', //channel configuration key
      title: message.title,
      body: message.message,
      notificationLayout: message.imageUrl == null
          ? NotificationLayout.Default
          : NotificationLayout.BigPicture,
    ));
  }

  Future<String?> getToken({String? vapidKey}) {
    return _firebaseMessaging.getToken(vapidKey: vapidKey);
  }

  Future<dynamic> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
