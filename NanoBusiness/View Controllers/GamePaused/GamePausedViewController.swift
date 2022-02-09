import UIKit
import FirebaseAnalytics

class GamePausedViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var homeButton: UIButton!
    
    let gameViewController: GameViewController
    
    init(gameVC: GameViewController) {
        self.gameViewController = gameVC
        super.init(nibName: "GamePausedViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameViewController.backgroundOverlay.alpha = 0.5
        backgroundView.layer.cornerRadius = 16
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.view.removeFromSuperview()
        gameViewController.backgroundOverlay.alpha = 0
        gameViewController.showHome()
        gameViewController.currentGame?.tapRightNode.alpha = 0
        gameViewController.currentGame?.tapLeftNode.alpha = 0
    }
    
    @IBAction func playGame(_ sender: Any) {
        self.view.removeFromSuperview()
        gameViewController.backgroundOverlay.alpha = 0
        gameViewController.currentGame?.game.status = .running
        AnalyticsManager.shared.log(event: .gameContinue)
    }
}
