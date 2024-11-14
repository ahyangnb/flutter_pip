import UIKit
import AVKit
import Flutter

class PipViewController: UIViewController, AVPictureInPictureControllerDelegate {

    private let timerName = "floatTimer"

    private var playerLayer: AVPlayerLayer!
    var pipController: AVPictureInPictureController!

    private var rootWindow: UIWindow?
    private var flPiPEngine: FlutterEngine?
    private var engineGroup = FlutterEngineGroup(name: "pip.flutter", project: nil)
    private var delegate : FlFlutterAppDelegate?
    private var firstWindow: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true, options: [])
            } catch {
                print("PipViewController error : AVAudioSession.sharedInstance()")
                print(error)
            }
            setupPlayer()
            setupPip()
        } else {
            print("The function needs to support iOS 14 and above, please upgrade your mobile phone system.")
        }
    }

    // Setup the player
    private func setupPlayer() {
        playerLayer = AVPlayerLayer()
        playerLayer.frame = .init(x: 0, y: 0, width: 213, height: 114)
        if let mp4Video = Bundle.main.url(forResource: "background_video_of_pip", withExtension: "mp4") {
            let asset = AVAsset(url: mp4Video)
            let playerItem = AVPlayerItem(asset: asset)
            print("Video loaded successfully: \(mp4Video)")

            let player = AVPlayer(playerItem: playerItem)
            playerLayer.player = player
            player.isMuted = true
            player.allowsExternalPlayback = true

            view.layer.addSublayer(playerLayer)

            // Start playing the video
            player.play()

            rootWindow = UIApplication.shared.windows.first
            let rootController = (rootWindow?.rootViewController as! FlutterViewController)
            flPiPEngine = engineGroup.makeEngine(withEntrypoint: "pipReamContentMain", libraryURI: nil)
            flPiPEngine!.run(withEntrypoint: "pipReamContentMain")

            delegate = UIApplication.shared.delegate as! FlFlutterAppDelegate
            delegate!.flutterController = FlutterViewController(
                                                                     engine: flPiPEngine!,
                                                                     nibName: rootController.nibName,
                                                                     bundle: rootController.nibBundle)

            delegate!.registerPlugin(delegate!.flutterController!.pluginRegistry())

            let rect = rootController.view.frame ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            delegate!.flutterController?.view.frame = rect

//            view.addSubview(delegate!.flutterController!.view)
//            delegate!.flutterController?.view.isHidden = false
//            delegate!.flutterController!.

        } else {
            print("Failed to load video.")
        }
    }

    // Setup the picture in picture.
    private func setupPip() {
        pipController = AVPictureInPictureController(playerLayer: playerLayer)!
        pipController.delegate = self
        // Hide play button, fast forward and rewind buttons
        pipController.setValue(1, forKey: "controlsStyle")
        print("setupPip:: Success");
    }

    // Enable/disable Picture in Picture
    @objc public func pipButtonClicked() {
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            openPiPHandle()
        }
    }

    @objc public func displayThePipWindow() {
        openPiPHandle()
    }

    // Check if picture-in-picture is turned on
    @objc func alreadyDisplayedPip() -> Bool {
        return pipController.isPictureInPictureActive
    }

    @objc public func disposeThePip() {
        pipController.stopPictureInPicture()
    }

    @objc public func setDisplayText(name: String, msg: String) {
        let conContent = name + "：" + msg
        print("setDisplayText::receive::" + conContent)

        let oldContent = delegate!.flutterController!.view
        // Remove the existing flutterController view from its superview
        delegate!.flutterController!.view = nil


        /// 尝试清空然后赋值旧版
        /// error: Execution of the command buffer was aborted due to an error during execution. Insufficient Permission (to submit GPU work from background) (00000006:kIOGPUCommandBufferCallbackErrorBackgroundExecutionNotPermitted)
//        delegate!.flutterController!.view = oldContent
        /// 尝试用这个解决Permission error，结果是：pip.flutter.1.2.raster (32): EXC_BAD_ACCESS (code=1, address=0x30)
//        DispatchQueue.main.async {
//            self.delegate!.flutterController!.view = oldContent
//        }
        /// 然后尝试这个pip.flutter.1.2.raster (29): EXC_BAD_ACCESS (code=1, address=0x30)
//        delegate!.flutterController!.viewDidLoad()

        /// 测试添加为新的引擎内容
        /// Error: Thread 1: "A view can only be associated with at most one view controller at a time! View <FlutterView: 0x10290c800; frame = (inf inf; 0 0); autoresize = W+H; gestureRecognizers = <NSArray: 0x30366f030>; backgroundColor = UIExtendedGrayColorSpace 0 0; layer = <CAMetalLayer: 0x30366e2b0>> is associated with <FlutterViewController: 0x10501fa00>. Clear this association before associating this view with <FlutterViewController: 0x10a010400>."
//        let rootController = (rootWindow?.rootViewController as! FlutterViewController)
//                flPiPEngine = engineGroup.makeEngine(withEntrypoint: "pipReamContentMain", libraryURI: nil)
//                flPiPEngine!.run(withEntrypoint: "pipReamContentMain")
//        delegate!.flutterController!.view = FlutterViewController(
//                                                        engine: flPiPEngine!,
//                                                        nibName: rootController.nibName,
//                                                        bundle: rootController.nibBundle
//                                                    ).view
        /// 然后尝试，删除内容之后不会赋值新内容到view
//        let rootController = (rootWindow?.rootViewController as! FlutterViewController)
//                        flPiPEngine = engineGroup.makeEngine(withEntrypoint: "pipReamContentMain", libraryURI: nil)
//                        flPiPEngine!.run(withEntrypoint: "pipReamContentMain")
//                delegate!.flutterController! = FlutterViewController(
//                                                                engine: flPiPEngine!,
//                                                                nibName: rootController.nibName,
//                                                                bundle: rootController.nibBundle
//                                                            )
        ///然后尝试添加旧内容到新的内容，结果：还是删除内容之后不会赋值新内容到view
//        delegate!.flutterController?.view.addSubview(oldContent!)
        
        

        /// 测试添加为新的Label，完全正常【即使在后台时中途修改】
        let nativeLabel = UILabel()
        nativeLabel.text = "New Content"
        nativeLabel.textColor = UIColor.red
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        delegate!.flutterController!.view = nativeLabel
        /// 尝试重新赋值到旧版内容，结果：Execution of the command buffer was aborted due to an error during execution. Insufficient Permission (to submit GPU work from background) (00000006:kIOGPUCommandBufferCallbackErrorBackgroundExecutionNotPermitted)
        delegate!.flutterController!.view = oldContent


        // 最后的添加操作。
        firstWindow?.addSubview(delegate!.flutterController!.view)
    }

    // Open Picture-in-Picture
    // Will check if can be open the pip content.
    func openPiPHandle() {
        print("Open pip, pipController.startPictureInPicture")
        if pipController.isPictureInPicturePossible {
            pipController.startPictureInPicture()
        } else {
            print("Picture in Picture is not possible at this time, Please make sure you has config `UIBackgroundModes` in file `Info.plist` of project.")
        }
    }

    // MARK: - Delegate
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        firstWindow = UIApplication.shared.windows.first
        firstWindow?.addSubview(delegate!.flutterController!.view)
//        delegate!.flutterController?.view.isHidden = false
        print("Custom view added to PiP window")
    }

    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerDidStartPictureInPicture: \(UIApplication.shared.windows)")
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("Custom view removed from PiP window")
    }
}
