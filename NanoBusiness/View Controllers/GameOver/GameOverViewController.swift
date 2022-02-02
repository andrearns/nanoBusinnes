import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var coinsCountLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var retryButton: UIButton!
    
    var gameViewController: GameViewController
    var progress: Int
    var record: Int
    var coinsCount: Int
    
    init(progress: Int, record: Int, coinsCount: Int, gameVC: GameViewController) {
        self.progress = progress
        self.record = record
        self.coinsCount = coinsCount
        self.gameViewController = gameVC
        super.init(nibName: "GameOverViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButton.layer.cornerRadius = 16
        backgroundView.layer.cornerRadius = 16
        coinsCountLabel.text = "\(coinsCount)"
        recordLabel.text = "\(record)m"
        progressLabel.text = "\(progress)m"
        self.gameViewController.backgroundOverlay.alpha = 0.5
    }
    
    @IBAction func retry(_ sender: Any) {
        self.dismiss(animated: true) {
            self.gameViewController.currentGame?.startGame()
            self.view.removeFromSuperview()
            self.gameViewController.backgroundOverlay.alpha = 0
        }
    }
}
