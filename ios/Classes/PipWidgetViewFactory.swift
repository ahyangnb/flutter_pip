import Flutter
import Foundation

@objcMembers class PipWidgetViewFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return PipWidgetViewBuilder(frame,viewID : viewId , args : args,binaryMessenger:messenger);
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        self.messenger = messenger
        super.init()
    }
}
