import Foundation

enum AnalyticsEvent {
    case levelStart // OK
    case levelEnd(climbDistance: Int) // OK
    case gamePause // OK
    case gameContinue // OK
    case openGameCenter // OK
    case closeGameCenter // OK
    case openShop // OK
    case closeShop
    case changePlayerSkin
    
    var name: String {
        switch self {
        case .levelStart:
            return "level_start"
        case .levelEnd:
            return "level_end"
        case .gamePause:
            return "game_pause"
        case .gameContinue:
            return "game_continue"
        case .openGameCenter:
            return "open_game_center"
        case .closeGameCenter:
            return "close_game_center"
        case .openShop:
            return "open_shop"
        case .closeShop:
            return "close_shop"
        case .changePlayerSkin:
            return "change_player_skin"
        }
    }
    
    var asDict: [String: NSObject] {
        switch self {
        case .levelStart:
            return [:]
        case .levelEnd(let climbDistance):
            return ["climb_distance" : climbDistance as NSObject]
        case .gamePause:
            return [:]
        case .gameContinue:
            return [:]
        case .openGameCenter:
            return [:]
        case .closeGameCenter:
            return [:]
        case .openShop:
            return [:]
        case .closeShop:
            return [:]
        case .changePlayerSkin:
            return [:]
        }
    }
}
