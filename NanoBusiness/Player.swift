import Foundation
import SpriteKit

final class Player {
    
    private var node: SKSpriteNode
    var position: Position
    
    init(node: SKSpriteNode) {
        self.node = node
        self.position = .left
    }
    
    func moveLeft() {
        if position != .left {
            node.position.x = -node.position.x
            position = .left
        }
    }
    
    func moveRight() {
        if position != .right {
            node.position.x = -node.position.x
            position = .right
        }
    }
    
    enum Position {
        case left
        case right
    }
}
