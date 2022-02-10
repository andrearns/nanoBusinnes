import Foundation

enum AnalyticsUserProperty {
    case personalRecord(climbDistance: Int)
    
    var name: String {
        switch self {
        case .personalRecord:
            return "personal_record"
        }
    }
    
    var value: String {
        switch self {
        case .personalRecord(let climbDistance):
            return climbDistance.description
        }
    }
}
