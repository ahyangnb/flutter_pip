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


        /// Tested adding it as a new Label and it worked perfectly [even if it was changed midway through the background]
        let nativeLabel = UILabel()
        nativeLabel.text = "New Content"
        nativeLabel.textColor = UIColor.red
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        delegate!.flutterController!.view = nativeLabel
        /// Trying to reassign to the old version of the content results in: Execution of the command buffer was aborted due to an error during execution. Insufficient Permission (to submit GPU work from background) (00000006:kIOGPUCommandBufferCallbackErrorBackgroundExecutionNotPermitted)
        delegate!.flutterController!.view = oldContent


        // The final add operation.
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
