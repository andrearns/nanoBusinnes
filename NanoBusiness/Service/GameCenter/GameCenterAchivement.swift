import Foundation

enum GameCenterAchievement: CaseIterable {
    case quickPeek
    case noviceClimber
    case adventurer
    case athlete
    case focusedClimber
    case oceaniaMountain
    case antarcticaMountain
    case europeMountain
    case africaMountain
    case northAmericaMountain
    case southAmericaMountain
    case everestMountain
    case universeOlympian
    case payday
    case rentIsDue
    case moneyBags
    case ressurection
    case doubleRessurection
    
    var identifier: String {
        switch self {
        case .quickPeek:
            return "com.andrearns.everestClimber.quickPeek"
        case .noviceClimber:
            return "com.andrearns.everestClimber.noviceClimber"
        case .adventurer:
            return "com.andrearns.everestClimber.adventurer"
        case .athlete:
            return "com.andrearns.everestClimber.athlete"
        case .focusedClimber:
            return "com.andrearns.everestClimber.focusedClimber"
        case .oceaniaMountain:
            return "com.andrearns.everestClimber.oceania"
        case .antarcticaMountain:
            return "com.andrearns.everestClimber.antarctica"
        case .europeMountain:
            return "com.andrearns.everestClimber.mountElbrus"
        case .africaMountain:
            return "com.andrearns.everestClimber.africa"
        case .northAmericaMountain:
            return "com.andrearns.everestClimber.northAmerica"
        case .southAmericaMountain:
            return "com.andrearns.everestClimber.aconcagua"
        case .everestMountain:
            return "com.andrearns.everestClimber.mountEverest"
        case .universeOlympian:
            return "com.andrearns.everestClimber.mars"
        case .payday:
            return "com.andrearns.everestClimber.payday"
        case .rentIsDue:
            return "com.andrearns.everestClimber.rentIsDue"
        case .moneyBags:
            return "com.andrearns.everestClimber.moneyBags"
        case .ressurection:
            return "com.andrearns.everestClimber.ressurection"
        case .doubleRessurection:
            return "com.andrearns.everestClimber.doubleRessurection"
        }
    }
    
    var category: AchievementCategory {
        switch self {
        case .quickPeek, .noviceClimber, .adventurer, .athlete, .focusedClimber, .oceaniaMountain, .antarcticaMountain, .europeMountain, .africaMountain, .northAmericaMountain, .southAmericaMountain, .everestMountain, .universeOlympian:
            return .distance
        case .payday, .rentIsDue, .moneyBags:
            return .coins
        case .ressurection, .doubleRessurection:
            return . revive
        }
    }
    
    var goal: Int {
        switch self {
        case .quickPeek:
            return 500
        case .noviceClimber:
            return 1000
        case .adventurer:
            return 2000
        case .athlete:
            return 2500
        case .focusedClimber:
            return 3000
        case .oceaniaMountain:
            return 4884
        case .antarcticaMountain:
            return 4892
        case .europeMountain:
            return 5642
        case .africaMountain:
            return 5895
        case .northAmericaMountain:
            return 6190
        case .southAmericaMountain:
            return 6962
        case .everestMountain:
            return 8848
        case .universeOlympian:
            return 21900
        case .payday:
            return 500
        case .rentIsDue:
            return 1000
        case .moneyBags:
            return 1500
        case .ressurection:
            return 1
        case .doubleRessurection:
            return 2
        }
    }
}

enum AchievementCategory {
    case distance
    case coins
    case revive
}
