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
        self.node.physicsBody?.categoryBitMask = CategoryMask.player.rawValue
        self.node.physicsBody?.collisionBitMask = CategoryMask.tree.rawValue
        self.node.physicsBody?.contactTestBitMask = CategoryMask.tree.rawValue
        attackSetup()
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
    
    func attackSetup() {
        
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "playerattack"))
        textures.append(SKTexture(imageNamed: "player"))
        
        let frames = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: false)
        
        attack = SKAction.sequence([frames])
        
        node.run(attack)
    }
    
    enum Position {
        case left
        case right
    }
}
