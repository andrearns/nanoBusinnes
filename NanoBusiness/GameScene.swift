import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController?
    
    var player: Player!
    var game = Game()
    var cam = SKCameraNode()
    var count = 0
    var climbDistance = 0
    var currentTime = TimeInterval(0)
    
    let nodeTypes: [CenarioNode] = [
        CenarioNode(size: CGSize(width: 400, height: 198.005), xPosition: 120, texture: SKTexture(imageNamed: "nodedanger")),
        CenarioNode(size: CGSize(width: 400, height: 198.005), xPosition: -120, texture: SKTexture(imageNamed: "nodedanger")),
        CenarioNode(size: CGSize(width: 162.371, height: 198.005), xPosition: 0, texture: SKTexture(imageNamed: "nodesimpleBlue")),
    ]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        view.showsPhysics = true
        view.showsNodeCount = true
        
        let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        player = Player(node: playerNode!)
        
        self.startGame()
        
        self.camera = cam
        addChild(cam)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.status == .running {
            for touch in touches {
                let location = touch.location(in: self)
                
                if location.x < 0 {
                    print("Touch left")
                    player.moveLeft()
                    player.attackSetup()
                } else if location.x > 0 {
                    print("Touch right")
                    player.moveRight()
                    player.attackSetup()
                }
                
                if (viewController?.timeBarWidthConstraint.constant)! <= 234 {
                    viewController?.timeBarWidthConstraint.constant += 2
                }
                
                let actualNode = childNode(withName: "tree\(count + 1)")
                
                if player.position == .left {
                    actualNode?.position.x += 2000
                } else {
                    actualNode?.position.x -= 2000
                }
                
                let pastNode = childNode(withName: "tree\(count)")
                pastNode?.removeFromParent()
                
                createNewTreeNode()
                
                count += 1
                climbDistance += 10
                viewController?.counterLabel.text = String("\(climbDistance)m")
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Colisão acontece e o jogo acaba
        if firstBody.categoryBitMask == CategoryMask.player.rawValue && secondBody.categoryBitMask == CategoryMask.tree.rawValue {
            print("contact")
            game.status = .over
            viewController?.showGameOver()
        }
    }
    
    func createNewTreeNode() {
        let oldNode = childNode(withName: "tree\(count + 6)")
        
        var randomNodeType = nodeTypes.randomElement()
        
        // Review: bugging
        while randomNodeType!.xPosition == -oldNode!.position.x {
            randomNodeType = nodeTypes.randomElement()
        }
        
        let newNode = SKSpriteNode(color: UIColor.green, size: randomNodeType!.size)
        
        newNode.position.x = randomNodeType!.xPosition
        newNode.position.y = 1000
        newNode.name = "tree\(count + 7)"
        newNode.texture = randomNodeType?.texture
        
        let physicsBody = SKPhysicsBody(rectangleOf: randomNodeType!.size)
        physicsBody.allowsRotation = false
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.friction = 1
        physicsBody.mass = 1000000
        physicsBody.categoryBitMask = CategoryMask.tree.rawValue
        physicsBody.collisionBitMask = CategoryMask.player.rawValue
        physicsBody.contactTestBitMask = CategoryMask.player.rawValue
        
        newNode.physicsBody = physicsBody
        
        let tree1 = childNode(withName: "tree\(count + 1)")
        let tree2 = childNode(withName: "tree\(count + 2)")
        let tree3 = childNode(withName: "tree\(count + 3)")
        let tree4 = childNode(withName: "tree\(count + 4)")
        let tree5 = childNode(withName: "tree\(count + 5)")
        let tree6 = childNode(withName: "tree\(count + 6)")
        
        self.addChild(newNode)
        
        newNode.position.y = tree6!.position.y
        tree6!.position.y = tree5!.position.y
        tree5!.position.y = tree4!.position.y
        tree4!.position.y = tree3!.position.y
        tree3!.position.y = tree2!.position.y
        tree2!.position.y = tree1!.position.y
    }
    
    override func update(_ currentTime: TimeInterval) {
        if game.status == .running {
            if (viewController?.timeBarWidthConstraint.constant)! > 1 {
                if climbDistance > 0 && climbDistance < 1000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.1
                } else if climbDistance >= 1000 && climbDistance < 2000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.2
                } else if climbDistance >= 2000 && climbDistance < 3000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.3
                } else if climbDistance >= 3000 && climbDistance < 4000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.4
                } else if climbDistance >= 4000 && climbDistance < 5000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.5
                } else if climbDistance >= 5000 && climbDistance < 6000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.6
                } else if climbDistance >= 6000 && climbDistance < 7000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.7
                } else if climbDistance >= 7000 {
                    viewController?.timeBarWidthConstraint.constant -= 0.8
                }
            } else if (viewController?.timeBarWidthConstraint.constant)! < 1 {
                game.status = .over
                viewController?.showGameOver()
            }
        }
    }
    
    func startGame() {
        for i in count...(count + 6) {
            let node = childNode(withName: "tree\(i)")
            node?.removeFromParent()
        }
    
        self.count = 0
        self.climbDistance = 0
        self.viewController?.counterLabel.text = String("\(climbDistance)m")
        self.viewController?.timeBarWidthConstraint.constant = 120
        
        // Criar os 6 blocos iniciais
        let initialNodeType = nodeTypes[2]
        
        for i in 1...6 {
            let newNode = SKSpriteNode(color: UIColor.green, size: initialNodeType.size)
            
            newNode.position.x = initialNodeType.xPosition
            newNode.position.y = CGFloat(-629.19 + 199.4 * Double(i))
            newNode.name = "tree\(i)"
            newNode.texture = initialNodeType.texture
            
            let physicsBody = SKPhysicsBody(rectangleOf: initialNodeType.size)
            physicsBody.allowsRotation = false
            physicsBody.isDynamic = true
            physicsBody.affectedByGravity = false
            physicsBody.friction = 1
            physicsBody.mass = 1000000
            physicsBody.categoryBitMask = CategoryMask.tree.rawValue
            physicsBody.collisionBitMask = CategoryMask.player.rawValue
            physicsBody.contactTestBitMask = CategoryMask.player.rawValue
            
            newNode.physicsBody = physicsBody
            
            self.addChild(newNode)
        }
        
        // Posicionar o player
        player.moveToInitialPosition()
        
        game.status = .running
    }
}
