import Foundation
import SpriteKit

final class Player {
    
    private var node: SKSpriteNode
    var position: Position
    private var attack: SKAction!
    
    init(node: SKSpriteNode) {
        self.node = node
        self.position = .left
        self.node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        self.node.physicsBody?.categoryBitMask = UInt32(2)
        self.node.physicsBody?.collisionBitMask = UInt32(1)
        self.node.physicsBody?.contactTestBitMask = UInt32(15)
        self.node.zPosition = 10000000
    }
    
    func moveLeft() {
        if position != .left {
            node.position.x = -node.position.x
            position = .left
        }
        node.xScale = -node.xScale
    }
    
    func moveRight() {
        if position != .right {
            node.position.x = -node.position.x
            position = .right
        }
        node.xScale = -node.xScale
    }
    
    func moveToInitialPosition() {
        node.position.x = -216
        node.position.y = -435.494
        position = .left
    }
}
