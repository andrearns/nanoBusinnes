import UIKit
import GoogleMobileAds

final class ReviveViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet var backgroundTimerView: UIView!
    @IBOutlet var timerProgressView: UIView!
    @IBOutlet var timerProgressWidthConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var gameVC: GameViewController?
    
    var rewardedAd: GADRewardedAd?
    var rewardFunction: (() -> Void)? = nil
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
        super.init(nibName: "ReviveViewController", bundle: nil)
        loadReward()
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
                closeRevive()
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        closeRevive()
    }
    
    func closeRevive() {
        print("Close revive pop up")
        gameVC?.hideRevive()
        timer?.invalidate()
        timer = nil
    }
    
    func configureTimer() {
        self.timerProgressWidthConstraint.constant = 202
        timer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(updateBar), userInfo: nil, repeats: true)
    }
    
    @IBAction func watchRewardVideo(_ sender: Any) {
        self.gameVC?.currentGame?.audioPlayer?.stop()
        showAd {
            print("Reward gained")
            self.closeRevive()
            self.gameVC?.revivePlayer()
            self.gameVC?.numberOfTimesAdRewardWasCollected += 1
        }
        self.loadReward()
    }
    
    func loadReward() {
        let request = GADRequest()
        GADRewardedAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
            request: request,
            completionHandler: { (ad, error) in
                if error != nil {
                    print("Rewarded ad failed to load with error: \(error!.localizedDescription)")
                    return
                }
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        )
    }
    
    func showAd(rewardFunction: @escaping () -> Void) {
        let root = UIApplication.shared.windows.first?.rootViewController
        if let ad = rewardedAd {
            ad.present(
                fromRootViewController: root!,
                userDidEarnRewardHandler: {
                    let reward = ad.adReward
                    print("Ad reward:", reward.amount)
                    rewardFunction()
                }
            )
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        if let function = rewardFunction {
            function()
        }
    }
}
