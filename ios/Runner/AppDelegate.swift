import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistr
      GMSServices.provideAPIKey("AIzaSyDXZA0nQX3SQQbj1nw9MxL0pogOh2fvyAs");ant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
