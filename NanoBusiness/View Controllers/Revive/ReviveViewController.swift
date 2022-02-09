import UIKit

final class ReviveViewController: UIViewController {
    
    @IBOutlet var backgroundTimerView: UIView!
    @IBOutlet var timerProgressView: UIView!
    @IBOutlet var timerProgressWidthConstraint: NSLayoutConstraint!
    
    var gameVC: GameViewController?
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
        super.init(nibName: "ReviveViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundTimerView.layer.cornerRadius = 25
        self.timerProgressView.layer.cornerRadius = 20
    }
    
    @IBAction func close(_ sender: Any) {
        print("Close revive pop up")
        gameVC?.hideRevive()
    }
    
    @IBAction func watchRewardVideo(_ sender: Any) {
        print("Watch reward video")
    }
    
}
