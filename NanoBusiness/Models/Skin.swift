import Foundation
import UIKit

struct Skin: Identifiable, Equatable, Codable {
    var id = UUID().uuidString
    var spriteImageName: String
    var name: String
    var description: String
    var coinCost: Int?
    var distanceRequired: Int?
    var isLocked: Bool
    
    func buy() {
        print("Buy skin: \(name)")
    }
}
