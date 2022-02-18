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
    
    func updateAchievements(reviveCount: Int) {
        let gameCenterAchievementsList = GameCenterAchievement.allCases
        
        for i in 0..<gameCenterAchievementsList.count {
            updateAchievement(gameCenterAchievement: gameCenterAchievementsList[i], reviveCount: reviveCount)
        }
    }
    
    private func updateAchievement(gameCenterAchievement: GameCenterAchievement, reviveCount: Int) {
        let achievement = GKAchievement(identifier: gameCenterAchievement.identifier)
        
        if !achievement.isCompleted {
            var progress: Double = 0
            switch gameCenterAchievement.category {
            case .distance:
                progress = Double(UserDefaultsService.fetchRecord() * 100 / gameCenterAchievement.goal)
            case .coins:
                progress = Double(UserDefaultsService.fetchCoinsCount() * 100 / gameCenterAchievement.goal)
            case .revive:
                progress = Double(reviveCount * 100 / gameCenterAchievement.goal)
            }
            
            if progress >= 100 {
                achievement.percentComplete = 100
                achievement.showsCompletionBanner = true
            } else {
                achievement.percentComplete = progress
            }
            
            GKAchievement.report([achievement]) { error in
                if error != nil {
                    print(error!.localizedDescription as String)
                }
            }
        }
    }
}
