import Flutter

open class FlFlutterAppDelegate: FlutterAppDelegate {
    public var flutterController: FlutterViewController?

    open func registerPlugin(_ registry: FlutterPluginRegistry) {}

    override open func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)
        flutterController?.view.isHidden = false
    }

    override open func applicationDidEnterBackground(_ application: UIApplication) {
        super.applicationDidEnterBackground(application)
        flutterController?.view.isHidden = false
    }
}
