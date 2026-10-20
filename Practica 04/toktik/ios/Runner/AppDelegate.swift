import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "toktik/app_icon",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "setSeasonIcon",
        let args = call.arguments as? [String: Any],
        let season = args["season"] as? String
      {
        // Normal = icono primario (img.jpg). El resto son
        // iconos alternos: HalloweenIcon, ChristmasIcon, ValentineIcon.
        var iconName: String? = nil
        if season == "halloween" {
          iconName = "HalloweenIcon"
        } else if season == "christmas" {
          iconName = "ChristmasIcon"
        } else if season == "valentine" {
          iconName = "ValentineIcon"
        }
        guard UIApplication.shared.supportsAlternateIcons else {
          result(
            FlutterError(
              code: "UNSUPPORTED",
              message: "Iconos alternos no soportados en este dispositivo",
              details: nil
            ))
          return
        }
        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
            result(
              FlutterError(
                code: "ICON_ERROR",
                message: error.localizedDescription,
                details: nil
              ))
          } else {
            result(nil)
          }
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
