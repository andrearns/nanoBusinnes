import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
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
    }
    
    @IBAction func restartGame(_ sender: Any) {
        currentGame?.game.status = .running
        currentGame?.startGame()
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        currentGame?.game.status = .paused
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
