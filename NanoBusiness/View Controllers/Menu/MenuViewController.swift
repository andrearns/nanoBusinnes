import UIKit

class MenuViewController: UIViewController {
    var gameVC: GameViewController
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
        super.init(nibName: "MenuViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showGameCenter(_ sender: Any) {
        print("Show game center")
    }
    
    @IBAction func startGame(_ sender: Any) {
        self.gameVC.currentGame?.startGame()
        self.view.center.y = 1200
        self.view.removeFromSuperview()
        self.gameVC.gameOverVC!.view.center.y = -900
        self.gameVC.gameOverVC!.view.removeFromSuperview()
        self.gameVC.backgroundOverlay.alpha = 0
    }
    
    @IBAction func showShop(_ sender: Any) {
        print("Show shop")
    }
    
}
