import UIKit
import SpriteKit
import GameplayKit
import FirebaseAnalytics
import GoogleMobileAds

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?
    
    var currentGame: GameScene?
    var backgroundOverlay = UIView()
    var gameOverVC: GameOverViewController?
    var gamePausedVC: GamePausedViewController?
    var menuVC: MenuViewController!
    var reviveVC: ReviveViewController?
    var homeVC: HomeViewController?
    
    var record: Int = 0
    var coinsCount: Int = 0
    var gamesPlayed: Int = 0
    var numberOfTimesAdRewardWasCollected = 0
    
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var timeView: UIView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var timeBarView: UIView!
    @IBOutlet var timeBarWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        record = UserDefaultsService.fetchRecord()
        coinsCount = UserDefaultsService.fetchCoinsCount()
        gamesPlayed = UserDefaultsService.fetchGamesPlayed()
        
        GameCenterService.shared.authenticateLocalPlayer(presentingVC: self)
        
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
        
        self.progressView.alpha = 0
        self.timeView.alpha = 0
        self.pauseButton.alpha = 0
        
        backgroundOverlay.frame = view.frame
        backgroundOverlay.backgroundColor = .black
        backgroundOverlay.alpha = 0
        
        view.addSubview(backgroundOverlay)
        
        gameOverVC = GameOverViewController(progress: currentGame!.climbDistance, coinsCount: currentGame!.coinsCount, gameVC: self)
        gameOverVC?.view.frame.size.width = (view.frame.width - 40)
        gameOverVC?.view.center.x = view.center.x
        gameOverVC?.view.center.y = -900
        
        menuVC = MenuViewController(gameVC: self)
        menuVC?.view.frame.size.width = (view.frame.width - 40)
        menuVC?.view.center.x = view.center.x
        menuVC?.view.center.y = 1200
        
        reviveVC = ReviveViewController(gameVC: self)
        reviveVC?.view.frame.size.width = (view.frame.width - 40)
        reviveVC?.view.center.x = -600
        reviveVC?.view.center.y = view.center.y
        
        homeVC = HomeViewController()
        homeVC?.view.frame.size.width = (view.frame.width - 40)
        homeVC?.view.center.x = view.center.x
        homeVC?.view.center.y = -900
        
        gamePausedVC = GamePausedViewController(gameVC: self)
        gamePausedVC?.view.frame.size.width = (view.frame.width - 40)
        gamePausedVC?.view.center.x = view.center.x
        gamePausedVC?.view.center.y = -900
        
        requestInterstitial()
    }
    
    func startGame() {
        numberOfTimesAdRewardWasCollected = 0
        self.gamesPlayed += 1
        UserDefaultsService.setGamesPlayed(self.gamesPlayed)
        
        self.currentGame?.startGame()
        self.hideHome()
        self.hideGameOver()
        self.hideMenu()
        self.showTopElements()
        self.backgroundOverlay.alpha = 0
        self.showTapButtons()
    }
    
    func revivePlayer() {
        self.hideGameOver()
        self.hideMenu()
        self.showTopElements()
        
        UIView.animate(withDuration: 0.2) {
            self.timeBarWidthConstraint.constant = 236
            self.backgroundOverlay.alpha = 0
            self.currentGame?.deadNodeLeft.alpha = 0
            self.currentGame?.deadNodeRight.alpha = 0
            self.currentGame?.player.node.alpha = 1
            self.currentGame?.player.moveToInitialPosition()
            self.currentGame?.prepareCenarioForRevival()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentGame?.game.status = .running
        }
    }
    
    func showPause() {
        currentGame?.game.status = .paused
        
        UIView.animate(withDuration: 0.3) {
            self.hideTapButtons()
            self.backgroundOverlay.alpha = 0.5
            self.gamePausedVC?.view.center.y = self.view.center.y
            self.view.addSubview(self.gamePausedVC!.view)
            self.addChild(self.gamePausedVC!)
        }
        
        AnalyticsManager.shared.log(event: .gamePause)
    }
    
    func hidePause() {
        currentGame?.game.status = .running
        UIView.animate(withDuration: 0.3) {
            self.gamePausedVC?.view.center.y = -1200
            self.backgroundOverlay.alpha = 0
        }
    }
    
    func showGameOver() {
        if currentGame!.climbDistance > record {
            UserDefaultsService.setNewRecord(currentGame!.climbDistance)
            record = currentGame!.climbDistance
            GameCenterService.shared.updateScore(with: record)
            homeVC?.reloadRecord()
            AnalyticsManager.shared.log(userProperty: .personalRecord(climbDistance: currentGame!.climbDistance))
        }
        
        self.coinsCount += currentGame?.coinsCount ?? 0
        UserDefaultsService.setCoinsCount(coinsCount)
        
        UIView.animate(withDuration: 0.5) {
            self.backgroundOverlay.alpha = 0.5
            self.gameOverVC?.progress = self.currentGame!.climbDistance
            self.gameOverVC?.coinsCount = self.currentGame!.coinsCount
            self.gameOverVC?.view.center.y = self.view.center.y - 40
            self.gameOverVC?.reloadData()
        
            self.view.addSubview(self.gameOverVC!.view)
            self.addChild(self.gameOverVC!)
        }
        
        showMenu()
        
        AnalyticsManager.shared.log(event: .levelEnd(climbDistance: currentGame!.climbDistance))
    }
    
    func hideGameOver() {
        UIView.animate(withDuration: 0.5) {
            self.gameOverVC!.view.center.y = -900
        }
    }
    
    func showHome() {
        print("Show home")
        showMenu()
        hideTopElements()
        
        UIView.animate(withDuration: 0.5) {
            self.backgroundOverlay.alpha = 0
            self.homeVC?.view.center.y = 250
            self.view.addSubview(self.homeVC!.view)
            self.addChild(self.homeVC!)
        }
    }
    
    func hideHome() {
        print("Show home")
        hideMenu()
        showTopElements()
        
        UIView.animate(withDuration: 0.5) {
            self.homeVC?.view.center.y = -600
        }
    }
    
    func showTopElements() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 1
            self.timeView.alpha = 1
            self.pauseButton.alpha = 1
        }
    }
    
    func hideTopElements() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 0
            self.timeView.alpha = 0
            self.pauseButton.alpha = 0
        }
    }
    
    func showMenu() {
        menuVC?.view.center.y = view.frame.height - 80
        self.view.addSubview(menuVC!.view)
        self.addChild(menuVC!)
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 1) {
            self.menuVC.view.center.y = 1200
            self.menuVC.view.removeFromSuperview()
        }
    }
    
    func showRevive() {
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.backgroundOverlay.alpha = 0.5
            self.reviveVC?.view.center.x = self.view.center.x
            self.view.addSubview(self.reviveVC!.view)
            self.addChild(self.reviveVC!)
            self.reviveVC?.configureTimer()
        }
    }
    
    func hideRevive() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.reviveVC?.view.center.x = 600
            self.showGameOver()
        }
        
        if self.gamesPlayed % 3 == 0 {
            showInterstitial()
        }
    }
    
    func blinkTimeBar() {
        UIView.animate(withDuration: 0.1) {
            self.timeBarView.alpha = 0.3
        }
        UIView.animate(withDuration: 0.1) {
            self.timeBarView.alpha = 1
        }
    }
    
    func showTapButtons() {
        UIView.animate(withDuration: 0.3) {
            self.currentGame?.tapRightNode.alpha = 1
            self.currentGame?.tapLeftNode.alpha = 1
        }
    }
    
    func hideTapButtons() {
        UIView.animate(withDuration: 0.3) {
            self.currentGame?.tapRightNode.alpha = 0
            self.currentGame?.tapLeftNode.alpha = 0
        }
    }
    

    @IBAction func pauseGame(_ sender: Any) {
        showPause()
    }
    
    func requestInterstitial() {
        let request = GADRequest()

        GADInterstitialAd.load(
            withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
            }
        )
    }
    
    func showInterstitial() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        currentGame?.audioPlayer?.stop()
    }

    // Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        print("Error:", error.localizedDescription)
    }

    // TadWillPresentFullScreenContent presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }

    // Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        requestInterstitial()
        currentGame?.audioPlayer?.play()
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
    
    override var shouldAutorotate: Bool {
        return false
    }
}
