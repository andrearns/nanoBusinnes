import Foundation
import SpriteKit
import GameplayKit
import FirebaseAnalytics

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController?
    
    var player: Player!
    var game = Game()
    var cam = SKCameraNode()
    var count = 0
    var climbDistance = 0
    var currentTime = TimeInterval(0)
    var coinsCount = 0
    
    var deadNodeLeft: SKSpriteNode!
    var deadNodeRight: SKSpriteNode!
    
    var tapLeftNode: SKSpriteNode!
    var tapRightNode: SKSpriteNode!
    var leftTapAnimation: SKAction!
    var rightTapAnimation: SKAction!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        player = Player(node: playerNode!)
        
        self.startGame()
        
        self.camera = cam
        addChild(cam)
        
        deadNodeLeft = SKSpriteNode(imageNamed: "paredeGameOverEsquerda")
        deadNodeLeft.position.x = -200
        deadNodeLeft.position.y = -333.5
        deadNodeLeft.zPosition = 10000000
        deadNodeLeft.alpha = 0
        deadNodeLeft.size = CGSize(width: 287.227, height: 222.333)
        addChild(deadNodeLeft)
        
        deadNodeRight = SKSpriteNode(imageNamed: "paredeGameOverDireita")
        deadNodeRight.position.x = 200
        deadNodeRight.position.y = -333.5
        deadNodeRight.zPosition = 10000000
        deadNodeRight.alpha = 0
        deadNodeRight.size = CGSize(width: 287.227, height: 222.333)
        addChild(deadNodeRight)
        
        tapLeftNode = childNode(withName: "tapLeft") as? SKSpriteNode
        tapRightNode = childNode(withName: "tapRight") as? SKSpriteNode
        
        setupLeftTapAnimation()
        setupRightTapAnimation()
        
        tapLeftNode.run(leftTapAnimation)
        tapRightNode.run(rightTapAnimation)
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
                viewController?.blinkTimeBar()
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
        
        // Collision with dangerous node -> Game over
        if firstBody.categoryBitMask == UInt32(1) && secondBody.categoryBitMask == UInt32(2) {
            print("Game over")
            game.status = .over
            player.node.zPosition = -10
            
            if player.position == .left {
                deadNodeLeft.alpha = 1
            } else {
                deadNodeRight.alpha = 1
            }
            
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut) {
                self.viewController?.showGameOver()
            }
        }
        // Collect coin
        else if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(4) {
            self.coinsCount += 1
            print("Coins:", coinsCount)
        
            let contactNode = secondBody.node as? SKSpriteNode
            
            contactNode?.physicsBody?.categoryBitMask = 8
            contactNode?.zPosition = 0
            UIView.animate(withDuration: 0.3) {
                contactNode!.texture = (self.player.position == .left) ? SKTexture(imageNamed: "paredeVaziaEsquerda") : SKTexture(imageNamed: "paredeVaziaDireita")
            }
        }
    }
    
    func createNewCenarioBlock() {
        let randomBlockType = CenarioBlocksSingleton.shared.cenarioBlocks.randomElement()
        
        let newLeftNode = createNewNode(cenarioNode: randomBlockType!.leftNode, yPosition: 778.167, position: .left, count: self.count + 7)
        let newRightNode = createNewNode(cenarioNode: randomBlockType!.rightNode, yPosition: 778.167, position: .right, count: self.count + 7)
        
        self.addChild(newLeftNode)
        self.addChild(newRightNode)
        
        for i in (1...6).reversed() {
            let leftNode = childNode(withName: "node\(count + i)A") as? SKSpriteNode
            let rightNode = childNode(withName: "node\(count + i)B") as? SKSpriteNode
            
            let leftAboveNode = childNode(withName: "node\(count + i + 1)A") as? SKSpriteNode
            let rightAboveNode = childNode(withName: "node\(count + i + 1)B") as? SKSpriteNode
            
            if i == 6 {
                newLeftNode.position.y = leftNode!.position.y
                newRightNode.position.y = rightNode!.position.y
            } else {
                leftAboveNode?.position.y = (leftNode?.position.y)!
                rightAboveNode?.position.y = (rightNode?.position.y)!
            }
        }
    }
    
    func startGame() {
        for i in count...(count + 6) {
            let leftNode = childNode(withName: "node\(i)A")
            leftNode?.removeFromParent()
            
            let rightNode = childNode(withName: "node\(i)B")
            rightNode?.removeFromParent()
        }

        self.player.node.zPosition = 10000000
        self.player.node.texture = SKTexture(imageNamed: "player-1")
        
        deadNodeLeft?.alpha = 0
        deadNodeRight?.alpha = 0
        
        self.count = 0
        self.coinsCount = 0
        self.climbDistance = 0
        self.viewController?.counterLabel.text = String("\(climbDistance)m")
        self.viewController?.timeBarWidthConstraint.constant = 120
        
        // Criar os 6 blocos iniciais
        let initialBlockType = CenarioBlocksSingleton.shared.cenarioBlocks[8]
        
        for i in 1...6 {
            let yPosition = CGFloat(-555.89 + 221.89 * Double(i - 1))
            
            let newLeftNode =  createNewNode(cenarioNode: initialBlockType.leftNode, yPosition: yPosition, position: .left, count: i)
            let newRightNode = createNewNode(cenarioNode: initialBlockType.rightNode, yPosition: yPosition, position: .right, count: i)
            
            self.addChild(newLeftNode)
            self.addChild(newRightNode)
        }
        
        game.status = .running
        
        // Posicionar o player
        player.moveToInitialPosition()
        
        Analytics.logEvent("level_start", parameters: nil)
    }
    
    func createNewNode(cenarioNode: CenarioNode, yPosition: CGFloat, position: Position, count: Int) -> SKSpriteNode {
        let newNode = SKSpriteNode(color: UIColor.green, size: cenarioNode.size)
        
        newNode.position.x = (position == .left) ? -200 : 200
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
    
    func setupRightTapAnimation() {
        let moveRight = SKAction.move(by: CGVector(dx: 35, dy: 0), duration: 0.4)
        let moveLeft = SKAction.move(by: CGVector(dx: -35, dy: 0), duration: 0.4)
        
        self.rightTapAnimation = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft]))
    }
    
    func setupLeftTapAnimation() {
        let moveLeft = SKAction.move(by: CGVector(dx: -35, dy: 0), duration: 0.4)
        let moveRight = SKAction.move(by: CGVector(dx: 35, dy: 0), duration: 0.4)
        
        self.leftTapAnimation = SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if game.status == .running {
            if (viewController?.timeBarWidthConstraint.constant)! > 1 {
                switch climbDistance {
                case 0:
                    viewController?.timeBarWidthConstraint.constant -= 0
                case 1...999:
                    viewController?.timeBarWidthConstraint.constant -= 0.1
                case 1000...1999:
                    viewController?.timeBarWidthConstraint.constant -= 0.2
                case 2000...2999:
                    viewController?.timeBarWidthConstraint.constant -= 0.3
                case 3000...3999:
                    viewController?.timeBarWidthConstraint.constant -= 0.4
                default:
                    viewController?.timeBarWidthConstraint.constant -= 0.5
                }
            } else if (viewController?.timeBarWidthConstraint.constant)! < 1 {
                game.status = .over
                viewController?.showGameOver()
            }
            
            if climbDistance == 0 {
                tapLeftNode.alpha = 1
                tapRightNode.alpha = 1
            } else {
                tapLeftNode.alpha = 0
                tapRightNode.alpha = 0
            }
        }
    }
}
