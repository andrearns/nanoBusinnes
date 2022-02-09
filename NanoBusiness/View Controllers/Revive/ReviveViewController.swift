import UIKit

final class ReviveViewController: UIViewController {
    
    @IBOutlet var backgroundTimerView: UIView!
    @IBOutlet var timerProgressView: UIView!
    @IBOutlet var timerProgressWidthConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    
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
        
        self.timerProgressWidthConstraint.constant = 202
    }
    
    @objc func updateBar() {
        guard let _ = timer else {
            return
        }
        
        if gameVC?.currentGame?.game.status == .over {
            if timerProgressWidthConstraint.constant > 0 {
                timerProgressWidthConstraint.constant -= Double(20 * self.timer!.timeInterval)
            } else {
                gameVC?.hideRevive()
                self.timer!.invalidate()
                self.timer = nil
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        print("Close revive pop up")
        gameVC?.hideRevive()
        timer!.invalidate()
        timer = nil
    }
    
    func configureTimer() {
        self.timerProgressWidthConstraint.constant = 202
        timer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
    }
    
    @IBAction func watchRewardVideo(_ sender: Any) {
        print("Watch reward video")
    }
    
}
