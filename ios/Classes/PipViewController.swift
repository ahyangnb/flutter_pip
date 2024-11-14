import UIKit
import AVKit

class PipViewController: UIViewController, AVPictureInPictureControllerDelegate {

    private let timerName = "floatTimer"

    private var playerLayer: AVPlayerLayer!
    var pipController: AVPictureInPictureController!
    var pipRealCustomView: FloatRealContentView! = FloatRealContentView()

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

            /// Try add the custom view to flutter page.
            view.addSubview(pipRealCustomView)
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

        let label = pipRealCustomView.nameLabel
        label.text = conContent
        label.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.colorWithHexString("#FF0000")
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
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
        // important: first window
        let window = UIApplication.shared.windows.first
        window?.addSubview(pipRealCustomView)
        // auto layout.
        pipRealCustomView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        print("Custom view added to PiP window")
    }

    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // print all the windows
        print("pictureInPictureControllerDidStartPictureInPicture: \(UIApplication.shared.windows)")
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        pipRealCustomView.removeFromSuperview()
        print("Custom view removed from PiP window")
    }
}
