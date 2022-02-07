import Foundation

enum AnalyticsEvent {
    case levelStart
    case levelEnd(Int)
    case gamePause
    case gameContinue
    case openGameCenter
    case closeGameCenter
    case newPersonalRecord(Int)
    
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
        case .newPersonalRecord:
            return "new_personal_record"
        }
    }
    
    var asDict: [String: NSObject] {
        switch self {
        case .levelStart:
            return [:]
        case .levelEnd(let int):
            return ["climb_distance" : int as NSObject]
        case .gamePause:
            return [:]
        case .gameContinue:
            return [:]
        case .openGameCenter:
            return [:]
        case .closeGameCenter:
            return [:]
        case .newPersonalRecord(let int):
            return ["new_record" : int as NSObject]
        }
    }

}
