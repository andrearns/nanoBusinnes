import Foundation
import UIKit
import GameKit

final class GameCenterService {
    static let shared = GameCenterService()
    
    private var localPlayer = GKLocalPlayer.local
    private let leaderBoardID = "com.andrearns.everestClimber.leaderboard"
    private var leaderboard: GKLeaderboard?
    private(set) var isGameCenterEnabled: Bool = false
    
    func authenticateLocalPlayer(presentingVC: UIViewController) {
        localPlayer.authenticateHandler = { [weak self] (gameCenterVC, error) -> Void in
            if error != nil {
                print(error!)
            } else if gameCenterVC != nil {
                presentingVC.present(gameCenterVC!, animated: true, completion: nil)
            } else if (self?.localPlayer.isAuthenticated ?? false) {
                self?.isGameCenterEnabled = true
            } else {
                self?.isGameCenterEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    func updateScore(with value: Int) {
        if self.isGameCenterEnabled {
            GKLeaderboard.submitScore(value, context: 0, player: localPlayer, leaderboardIDs: [self.leaderBoardID], completionHandler: { error in
                if error != nil {
                    print("Error submiting score to leaderboard: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
}
