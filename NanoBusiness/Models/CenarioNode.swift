import Foundation
import SpriteKit

struct CenarioNode {
    let id = UUID()
    var size: CGSize
    var texture: SKTexture
    var afterCollisionTexture: SKTexture?
    var categoryMask: Int
    var collisionMask: Int
    var contactMask: Int
}
