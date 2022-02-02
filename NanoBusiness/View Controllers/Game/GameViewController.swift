import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    var backgroundOverlay = UIView()
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
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
        
        timeBarView.layer.cornerRadius = 6
        timeBarWidthConstraint.constant = 120
        
        backgroundOverlay.frame = view.frame
        backgroundOverlay.backgroundColor = .black
        backgroundOverlay.alpha = 0
        
        view.addSubview(backgroundOverlay)
    }
    
    func showGameOver() {
        let gameOverVC = GameOverViewController(progress: currentGame!.climbDistance, record: 0, coinsCount: 0, gameVC: self)
        gameOverVC.view.frame.size.width = (view.frame.width - 40)
        gameOverVC.view.center = view.center
    
        self.view.addSubview(gameOverVC.view)
        self.addChild(gameOverVC)
    }

    @IBAction func restartGame(_ sender: Any) {
        currentGame?.game.status = .running
        currentGame?.startGame()
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
