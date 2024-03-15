import UIKit
import Flutter
import flutter_local_notifications
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    AppDelegate.registerPlugins(with: self) // Register the app's plugins in the context of a normal run
        
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in  
        // The following code will be called upon WorkmanagerPlugin's registration.
        // Note : all of the app's plugins may not be required in this context ;
        // instead of using GeneratedPluginRegistrant.register(with: registry),
        // you may want to register only specific plugins.
        AppDelegate.registerPlugins(with: registry)
    }

    GeneratedPluginRegistrant.register(with: self)
  
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
