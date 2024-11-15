import Flutter
import UIKit

public class FlutterPipPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pip", binaryMessenger: registrar.messenger())
    let instance = FlutterPipPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    /// Add the pip native widget factory.
    let factory = PipWidgetViewFactory(messenger: registrar.messenger() as! any NSObject & FlutterBinaryMessenger)
    registrar.register(factory, withId: "FlutterPipWidget-UiKitType")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
