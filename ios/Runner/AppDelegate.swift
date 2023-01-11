import UIKit
import Flutter
import awesome_notifications
import shared_preferences_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
//    if #available(iOS 10.0, *) {
//      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//    }
      
      SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
        SwiftAwesomeNotificationsPlugin.register(
          with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
        FLTSharedPreferencesPlugin.register(
          with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
    }

//    if(!UserDefaults.standard.bool(forKey: "Notification")) {
//      UIApplication.shared.cancelAllLocalNotifications()
//      UserDefaults.standard.set(true, forKey: "Notification")
//    }

    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
