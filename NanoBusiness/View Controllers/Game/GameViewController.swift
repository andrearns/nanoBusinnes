import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    var backgroundOverlay = UIView()
    var gameOverVC: GameOverViewController?
    
    var record: Int = 0
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var timeBarView: UIView!
    @IBOutlet var timeBarWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
        }
        
        timeBarView.layer.cornerRadius = 19
        timeBarWidthConstraint.constant = 120
        
        backgroundOverlay.frame = view.frame
        backgroundOverlay.backgroundColor = .black
        backgroundOverlay.alpha = 0
        
        view.addSubview(backgroundOverlay)
        
        record = UserDefaultsManager.fetchRecord()
       
        gameOverVC = GameOverViewController(progress: currentGame!.climbDistance, record: record, coinsCount: currentGame!.coinsCount, gameVC: self)
        gameOverVC?.view.frame.size.width = (view.frame.width - 40)
        gameOverVC?.view.center.x = view.center.x
        gameOverVC?.view.center.y = -900
    }
    
    func showGameOver() {
        if currentGame!.climbDistance > record {
            UserDefaultsManager.setNewRecord(currentGame!.climbDistance)
            record = currentGame!.climbDistance
        }
        
        self.backgroundOverlay.alpha = 0.5
        gameOverVC?.progress = currentGame!.climbDistance
        gameOverVC?.coinsCount = currentGame!.coinsCount
        gameOverVC?.view.center.y = view.center.y
        gameOverVC?.reloadData()
    
        self.view.addSubview(gameOverVC!.view)
        self.addChild(gameOverVC!)
    }
    
    func showTapButtons() {
        
    }
    
    func hideTapButtons() {
        
    }

    @IBAction func pauseGame(_ sender: Any) {
        currentGame?.game.status = .paused
        
        let gamePausedVC = GamePausedViewController(gameVC: self)
        gamePausedVC.view.frame.size.width = (view.frame.width - 40)
        gamePausedVC.view.center = view.center
        
        self.view.addSubview(gamePausedVC.view)
        self.addChild(gamePausedVC)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
