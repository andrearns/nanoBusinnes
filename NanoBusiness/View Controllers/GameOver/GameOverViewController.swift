import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var coinsCountLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
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
        
        backgroundView.layer.cornerRadius = 16
        coinsCountLabel.text = "\(coinsCount)"
        recordLabel.text = "\(record)m"
        progressLabel.text = "\(progress)m"
    }
    
    @IBAction func retry(_ sender: Any) {
        self.dismiss(animated: true) {
            self.gameViewController.currentGame?.startGame()
        }
    }
}
