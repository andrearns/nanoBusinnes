import UIKit
import GameKit

class GameOverViewController: UIViewController {
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var coinsCountLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    var gameViewController: GameViewController
    var progress: Int
    var coinsCount: Int
    
    init(progress: Int, coinsCount: Int, gameVC: GameViewController) {
        self.progress = progress
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
    }
    
    func reloadData() {
        coinsCountLabel.text = "\(coinsCount)"
        recordLabel.text = "\(UserDefaultsService.fetchRecord())m"
        progressLabel.text = "\(progress)m"
    }
}
