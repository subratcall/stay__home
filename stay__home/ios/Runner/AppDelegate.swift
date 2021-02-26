import Flutter
import workmanager
import shared_preferences

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.register(with: self.registrar(forPlugin: "be.tramckrijte.workmanager.WorkmanagerPlugin")!)
    UNUserNotificationCenter.current().delegate = self
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*10))

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in        
        FLTSharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
        
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}