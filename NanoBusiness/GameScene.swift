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
    var coinsCount = 0
    
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
                } else if location.x > 0 {
                    print("Touch right")
                    player.moveRight()
                }
                
                if (viewController?.timeBarWidthConstraint.constant)! <= 234 {
                    viewController?.timeBarWidthConstraint.constant += 2
                }
                
                let currentLeftNode = childNode(withName: "node\(count + 1)A")
                let currentRightNode = childNode(withName: "node\(count + 1)B")
                
                currentLeftNode?.position.x += 2000
                currentRightNode?.position.x += 2000
                
                let oldLeftNode = childNode(withName: "node\(count)A")
                let oldRightNode = childNode(withName: "node\(count)B")
                
                oldLeftNode?.removeFromParent()
                oldRightNode?.removeFromParent()
                
                createNewCenarioBlock()
                
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
        if firstBody.categoryBitMask == UInt32(1) && secondBody.categoryBitMask == UInt32(2) {
            print("Game over")
            game.status = .over
            
            if player.position == .left {
                let leftNode = SKSpriteNode(imageNamed: "paredeGameOverEsquerda")
                leftNode.size = CGSize(width: 260.055, height: 201.3)
                leftNode.position.y = -430.097
                leftNode.position.x = -210
                leftNode.zPosition = 10000000000
                leftNode.name = "deadNode"
                self.addChild(leftNode)
            } else {
                let rightNode = SKSpriteNode(imageNamed: "paredeGameOverDireita")
                rightNode.size = CGSize(width: 260.055, height: 201.3)
                rightNode.position.y = -430.097
                rightNode.position.x = 210
                rightNode.zPosition = 10000000000
                rightNode.name = "deadNode"
                self.addChild(rightNode)
            }
            
            player.node.zPosition = -10
            
            viewController?.showGameOver()
        }
        // Pega moeda
        else if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(4) {
            self.coinsCount += 1
            print("Coins:", coinsCount)
        }
    }
    
    func createNewCenarioBlock() {
        let randomBlockType = CenarioBlocksSingleton.shared.cenarioBlocks.randomElement()
        
        let newLeftNode = createNewNode(cenarioNode: randomBlockType!.leftNode, yPosition: 576.404, position: .left, count: self.count + 7)
        
        let newRightNode = createNewNode(cenarioNode: randomBlockType!.rightNode, yPosition: 576.404, position: .right, count: self.count + 7)
        
        let leftNode1 = childNode(withName: "node\(count + 1)A")
        let leftNode2 = childNode(withName: "node\(count + 2)A")
        let leftNode3 = childNode(withName: "node\(count + 3)A")
        let leftNode4 = childNode(withName: "node\(count + 4)A")
        let leftNode5 = childNode(withName: "node\(count + 5)A")
        let leftNode6 = childNode(withName: "node\(count + 6)A")
        
        let rightNode1 = childNode(withName: "node\(count + 1)B")
        let rightNode2 = childNode(withName: "node\(count + 2)B")
        let rightNode3 = childNode(withName: "node\(count + 3)B")
        let rightNode4 = childNode(withName: "node\(count + 4)B")
        let rightNode5 = childNode(withName: "node\(count + 5)B")
        let rightNode6 = childNode(withName: "node\(count + 6)B")
        
        self.addChild(newLeftNode)
        self.addChild(newRightNode)
        
        newLeftNode.position.y = leftNode6!.position.y
        leftNode6!.position.y = leftNode5!.position.y
        leftNode5!.position.y = leftNode4!.position.y
        leftNode4!.position.y = leftNode3!.position.y
        leftNode3!.position.y = leftNode2!.position.y
        leftNode2!.position.y = leftNode1!.position.y
        
        newRightNode.position.y = rightNode6!.position.y
        rightNode6!.position.y = rightNode5!.position.y
        rightNode5!.position.y = rightNode4!.position.y
        rightNode4!.position.y = rightNode3!.position.y
        rightNode3!.position.y = rightNode2!.position.y
        rightNode2!.position.y = rightNode1!.position.y
    }
    
    func startGame() {
        for i in count...(count + 6) {
            let leftNode = childNode(withName: "node\(i)A")
            leftNode?.removeFromParent()
            
            let rightNode = childNode(withName: "node\(i)B")
            rightNode?.removeFromParent()
        }
        
        let deadNode = childNode(withName: "deadNode")
        deadNode?.removeFromParent()
        self.player.node.zPosition = 10000000
        self.count = 0
        self.climbDistance = 0
        self.viewController?.counterLabel.text = String("\(climbDistance)m")
        self.viewController?.timeBarWidthConstraint.constant = 120
        
        // Criar os 6 blocos iniciais
        let initialBlockType = CenarioBlocksSingleton.shared.cenarioBlocks[8]
        
        for i in 1...6 {
            let yPosition = CGFloat(-430.097 + 201.3 * Double(i - 1))
            
            let newLeftNode =  createNewNode(cenarioNode: initialBlockType.leftNode, yPosition: yPosition, position: .left, count: i)
            let newRightNode = createNewNode(cenarioNode: initialBlockType.rightNode, yPosition: yPosition, position: .right, count: i)
            
            self.addChild(newLeftNode)
            self.addChild(newRightNode)
        }
        
        // Posicionar o player
        player.moveToInitialPosition()
        
        game.status = .running
    }
    
    func createNewNode(cenarioNode: CenarioNode, yPosition: CGFloat, position: Position, count: Int) -> SKSpriteNode {
        let newNode = SKSpriteNode(color: UIColor.green, size: cenarioNode.size)
        
        newNode.position.x = (position == .left) ? -210 : 210
        newNode.position.y = yPosition
        newNode.name = (position == .left) ? "node\(count)A" : "node\(count)B"
        newNode.texture = cenarioNode.texture
        
        let physicsBody = SKPhysicsBody(rectangleOf: cenarioNode.size)
        physicsBody.allowsRotation = false
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.friction = 1
        physicsBody.mass = 1000000
        physicsBody.categoryBitMask = UInt32(cenarioNode.categoryMask)
        physicsBody.collisionBitMask = UInt32(cenarioNode.collisionMask)
        physicsBody.contactTestBitMask = UInt32(cenarioNode.contactMask)
        
        newNode.physicsBody = physicsBody
        
        return newNode
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
}
