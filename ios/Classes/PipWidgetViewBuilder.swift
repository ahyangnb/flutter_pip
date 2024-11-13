import Flutter
import Foundation
 
import UIKit
import AVKit

class PipWidgetViewBuilder : NSObject,FlutterPlatformView, AVPictureInPictureControllerDelegate{
    let frame: CGRect;
    let viewId: Int64;
    var messenger: FlutterBinaryMessenger!
    let pipView = PipViewController()

     private var _view: UIView

    
    init(_ frame: CGRect,viewID: Int64,args :Any?, binaryMessenger: FlutterBinaryMessenger) {
    _view = UIView()
        self.frame = frame;
        self.viewId = viewID;
        self.messenger=binaryMessenger;
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }
 func createNativeView(view _view: UIView){
         _view.backgroundColor = UIColor.blue
         let nativeLabel = UILabel()
         nativeLabel.text = "Native text from iOS"
         nativeLabel.textColor = UIColor.red
         nativeLabel.textAlignment = .center
         nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
         _view.addSubview(nativeLabel)
     }
    
    func initMethodChannel(){
        let pipWidgetChannel = FlutterMethodChannel.init(name: "inner_channel_pip_plugin",
                                                         binaryMessenger: messenger);
        print("inner_channel_pip_plugin init success")
        pipWidgetChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if(call.method == "displayThePipWindow"){
                print("inner_channel_pip_plugin call displayThePipWindow")
                self.pipView.displayThePipWindow();
                result(true);
            } else if(call.method == "alreadyDisplayedPip"){
                result(self.pipView.alreadyDisplayedPip())
            } else if(call.method == "disposeThePip"){
                self.pipView.disposeThePip();
                result(true);
            } else if(call.method == "setDisplayText"){
                let arguments = call.arguments as! [String: Any]
                let name = arguments["name"];
                let content = arguments["content"];
                
                self.pipView.setDisplayText(name: name as! String, msg: content as! String);
                result(true);
            }
        });
    }
    
    
    func view() -> UIView {
        initMethodChannel()
        let containerView = UIView(frame: frame)
        containerView.addSubview(pipView.view)
        containerView.addSubview(_view)
        return containerView;
//        return pipView.view;
//        return _view;
    }
}
