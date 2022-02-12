import UIKit
import GameKit

class MenuViewController: UIViewController, GKGameCenterControllerDelegate {

    var gameVC: GameViewController
    var gameCenterVC: GKGameCenterViewController?
    
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
        gameCenterVC = GKGameCenterViewController(leaderboardID: "com.andrearns.everestClimber.leaderboard", playerScope: .global, timeScope: .allTime)
        gameCenterVC!.gameCenterDelegate = self
        present(gameCenterVC!, animated: true, completion: nil)
        AnalyticsManager.shared.log(event: .openGameCenter)
    }
    
    @IBAction func startGame(_ sender: Any) {
        gameVC.startGame()
    }
    
    @IBAction func showShop(_ sender: Any) {
        print("Show shop")
        let shopVC = ShopViewController(gameVC: gameVC)
        let shopView = shopVC.view
        shopView!.frame.size.width = gameVC.view.frame.width
        shopView?.center.x = gameVC.view.center.x
        gameVC.showShop()
        gameVC.view.addSubview(shopView!)
        gameVC.addChild(shopVC)
        AnalyticsManager.shared.log(event: .openShop)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("Leaderboard closed")
        gameCenterVC?.dismiss(animated: true, completion: nil)
        AnalyticsManager.shared.log(event: .closeGameCenter)
    }
}
