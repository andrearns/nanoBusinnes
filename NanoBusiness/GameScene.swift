import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    
    var count = 0
    var counterLabel: SKLabelNode!
    
    var cam = SKCameraNode()
    
    var tree1: SKSpriteNode!
    var tree2: SKSpriteNode!
    var tree3: SKSpriteNode!
    var tree4: SKSpriteNode!
    var tree5: SKSpriteNode!
    var tree6: SKSpriteNode!
    var tree7: SKSpriteNode!
    
    let nodeTypes: [NodeType] = [
        NodeType(size: CGSize(width: 400, height: 198.005), xPosition: 120),
        NodeType(size: CGSize(width: 400, height: 198.005), xPosition: -120),
        NodeType(size: CGSize(width: 162.371, height: 198.005), xPosition: 0),
    ]
    
    override func didMove(to view: SKView) {
        let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        player = Player(node: playerNode!)
        
        counterLabel = self.childNode(withName: "counterLabel") as? SKLabelNode
        
        tree1 = self.childNode(withName: "tree1") as? SKSpriteNode
        tree2 = self.childNode(withName: "tree2") as? SKSpriteNode
        tree3 = self.childNode(withName: "tree3") as? SKSpriteNode
        tree4 = self.childNode(withName: "tree4") as? SKSpriteNode
        tree5 = self.childNode(withName: "tree5") as? SKSpriteNode
        tree6 = self.childNode(withName: "tree6") as? SKSpriteNode
        tree7 = self.childNode(withName: "tree7") as? SKSpriteNode
        
        self.camera = cam
        addChild(cam)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x < 0 {
                print("Touch left")
                player.moveLeft()
            } else if location.x > 0 {
                print("Touch right")
                player.moveRight()
            }
            
            let actualNode = childNode(withName: "tree\(count + 1)")
            
            if player.position == .left {
                actualNode?.position.x += 2000
            } else {
                actualNode?.position.x -= 2000
            }
            
            let pastNode = childNode(withName: "tree\(count)")
            pastNode?.removeFromParent()
            print("node cutted:", actualNode?.name)
            
            createNewTreeNode()
            
            count += 1
            counterLabel.text = String(count)
        }
    }
    
    func createNewTreeNode() {
        let oldNode = childNode(withName: "tree\(count + 7)")
        
        
        let randomNodeType = nodeTypes.randomElement()
        let newNode = SKSpriteNode(color: UIColor.green, size: randomNodeType!.size)
        
        newNode.position.x = randomNodeType!.xPosition
        newNode.position.y = 800
        newNode.name = "tree\(count + 8)"
        
        let physicsBody = SKPhysicsBody(rectangleOf: randomNodeType!.size)
        physicsBody.allowsRotation = false
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0
        physicsBody.friction = 1
        physicsBody.mass = 1000000
        
        newNode.physicsBody = physicsBody
        
        print("newNode:", newNode.name)
        
        let tree1 = childNode(withName: "tree\(count + 1)")
        let tree2 = childNode(withName: "tree\(count + 2)")
        let tree3 = childNode(withName: "tree\(count + 3)")
        let tree4 = childNode(withName: "tree\(count + 4)")
        let tree5 = childNode(withName: "tree\(count + 5)")
        let tree6 = childNode(withName: "tree\(count + 6)")
        let tree7 = childNode(withName: "tree\(count + 7)")
        
        self.addChild(newNode)
        
        newNode.position.y = tree7!.position.y
        tree7!.position.y = tree6!.position.y
        tree6!.position.y = tree5!.position.y
        tree5!.position.y = tree4!.position.y
        tree4!.position.y = tree3!.position.y
        tree3!.position.y = tree2!.position.y
        tree2!.position.y = tree1!.position.y
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

struct NodeType {
    var size: CGSize
    var xPosition: CGFloat
}
