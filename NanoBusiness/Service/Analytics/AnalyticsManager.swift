import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.asDict)
    }
    
    func log(userProperty: AnalyticsUserProperty) {
        Analytics.setUserProperty(userProperty.value, forName: userProperty.name)
    }
}
