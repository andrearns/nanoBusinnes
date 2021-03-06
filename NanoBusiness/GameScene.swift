import Foundation
import SpriteKit
import GameplayKit
import FirebaseAnalytics
import AVFoundation

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
    
    let blockHeight: Double = 222.8835
    let blockWidth: Double = 254
    let blockXPosition: Double = 180
    
    var tapLeftNode: SKSpriteNode!
    var tapRightNode: SKSpriteNode!
    var leftTapAnimation: SKAction!
    var rightTapAnimation: SKAction!
    
    // Sounds
    var audioPlayer: AVAudioPlayer?
    var hurtSoundAction = SKAction.playSoundFileNamed("hurt", waitForCompletion: true)
    var coinSoundAction = SKAction.playSoundFileNamed("coin", waitForCompletion: true)
    var changeVolumeAction = SKAction.changeVolume(to: 0.5, duration: 0)
    
    // Haptics
    let stepFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    let gameOverImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        player = Player(node: playerNode!)
        
        self.camera = cam
        addChild(cam)
        
        prepareCenario()
        
        deadNodeLeft = SKSpriteNode(imageNamed: "paredeGameOverEsquerda")
        deadNodeLeft.position.x = -blockXPosition
        deadNodeLeft.position.y = -333.92
        deadNodeLeft.zPosition = 10000000
        deadNodeLeft.alpha = 0
        deadNodeLeft.size = CGSize(width: blockWidth, height: blockHeight)
        addChild(deadNodeLeft)
        
        deadNodeRight = SKSpriteNode(imageNamed: "paredeGameOverDireita")
        deadNodeRight.position.x = blockXPosition
        deadNodeRight.position.y = -333.92
        deadNodeRight.zPosition = 10000000
        deadNodeRight.alpha = 0
        deadNodeRight.size = CGSize(width: blockWidth, height: blockHeight)
        addChild(deadNodeRight)
        
        tapLeftNode = childNode(withName: "tapLeft") as? SKSpriteNode
        tapRightNode = childNode(withName: "tapRight") as? SKSpriteNode
        
        tapLeftNode.alpha = 0
        tapRightNode.alpha = 0
        
        setupLeftTapAnimation()
        setupRightTapAnimation()
        
        tapLeftNode.run(leftTapAnimation)
        tapRightNode.run(rightTapAnimation)
        
        playSound(sound: "background", type: "mp3", volume: 0.5)
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
                stepFeedback()
                viewController?.blinkTimeBar()
            }
            
            if (viewController?.timeBarWidthConstraint.constant)! <= 234 {
                viewController?.timeBarWidthConstraint.constant += 6
            }
            
            let currentLeftNode = childNode(withName: "node\(count + 1)A")
            let currentRightNode = childNode(withName: "node\(count + 1)B")

            currentLeftNode?.position.x = 2000
            currentRightNode?.position.x = 2000
            
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
            
            player.node.alpha = 0
            
            if player.position == .left {
                deadNodeLeft.alpha = 1
            } else {
                deadNodeRight.alpha = 1
            }
            
            gameOverFeedback()
            
            if viewController!.numberOfTimesAdRewardWasCollected < 2 {
                self.viewController?.showRevive()
            } else {
                self.viewController?.showGameOver()
            }
        }
        // Collect coin
        else if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(4) {
            self.coinsCount += 1
            print("Coins:", coinsCount)
        
            let contactNode = secondBody.node as? SKSpriteNode
            
            let effectAudioGroup = SKAction.group([coinSoundAction, changeVolumeAction])
            run(effectAudioGroup)
            
            contactNode?.physicsBody?.categoryBitMask = 8
            contactNode?.zPosition = 0
            UIView.animate(withDuration: 0.3) {
                contactNode!.texture = (self.player.position == .left) ? SKTexture(imageNamed: "paredeVaziaEsquerda") : SKTexture(imageNamed: "paredeVaziaDireita")
            }
        }
    }
    
    func playSound(sound: String, type: String, volume: Float, loops: Int = -1) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = loops
                audioPlayer?.play()
            } catch {
                print("ERROR")
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
                newLeftNode.position.y = (leftNode?.position.y)!
                newRightNode.position.y = (rightNode?.position.y)!
            } else {
                leftAboveNode?.position.y = (leftNode?.position.y)!
                rightAboveNode?.position.y = (rightNode?.position.y)!
            }
        }
    }
    
    func startGame() {
        prepareCenario()
        
        player.node.alpha = 1
        
        self.count = 0
        self.coinsCount = 0
        self.climbDistance = 0
        self.viewController?.counterLabel.text = String("\(climbDistance)m")
        self.viewController?.timeBarWidthConstraint.constant = 120
        
        game.status = .running
        
        viewController?.showTopElements()
        
        AnalyticsManager.shared.log(event: .levelStart)
    }
    
    func prepareCenario() {
        for i in count...(count + 6) {
            let leftNode = childNode(withName: "node\(i)A")
            leftNode?.removeFromParent()
            
            let rightNode = childNode(withName: "node\(i)B")
            rightNode?.removeFromParent()
        }
        
        deadNodeLeft?.alpha = 0
        deadNodeRight?.alpha = 0
        
        // Criar os 6 blocos iniciais
        let initialBlockType = CenarioBlocksSingleton.shared.cenarioBlocks[8]
        
        for i in 0...6 {
            let yPosition = CGFloat(-555.85 + (blockHeight - 0.6) * Double(i - 1))
            
            let newLeftNode =  createNewNode(cenarioNode: initialBlockType.leftNode, yPosition: yPosition, position: .left, count: i)
            let newRightNode = createNewNode(cenarioNode: initialBlockType.rightNode, yPosition: yPosition, position: .right, count: i)
            
            self.addChild(newLeftNode)
            self.addChild(newRightNode)
        }
        
        // Posicionar o player
        self.player.node.zPosition = 10000000
        
        let selectedSkin = SkinsSingleton.shared.skins.first { skin in
            skin.name == UserDefaultsService.fetchSelectedSkinName()
        }
        
        self.player.node.texture = SKTexture(imageNamed: selectedSkin!.spriteImageName)
        
        player.moveToInitialPosition()
    }
    
    func prepareCenarioForRevival() {
        let initialBlockType = CenarioBlocksSingleton.shared.cenarioBlocks[8]
        
        for i in count...(count + 3) {
            let leftNode = childNode(withName: "node\(i)A") as? SKSpriteNode
            leftNode?.texture = initialBlockType.leftNode.texture
            leftNode!.physicsBody?.categoryBitMask = UInt32(initialBlockType.leftNode.categoryMask)
            leftNode!.physicsBody?.contactTestBitMask = UInt32(initialBlockType.leftNode.contactMask)
            leftNode!.physicsBody?.collisionBitMask = UInt32(initialBlockType.leftNode.collisionMask)
            
            let rightNode = childNode(withName: "node\(i)B") as? SKSpriteNode
            rightNode?.texture = initialBlockType.rightNode.texture
            rightNode!.physicsBody?.categoryBitMask = UInt32(initialBlockType.rightNode.categoryMask)
            rightNode!.physicsBody?.contactTestBitMask = UInt32(initialBlockType.rightNode.contactMask)
            rightNode!.physicsBody?.collisionBitMask = UInt32(initialBlockType.rightNode.collisionMask)
        }
    }
    
    func createNewNode(cenarioNode: CenarioNode, yPosition: CGFloat, position: Position, count: Int) -> SKSpriteNode {
        let newNode = SKSpriteNode(color: UIColor.green, size: CGSize(width: blockWidth, height: blockHeight))
        
        newNode.position.x = (position == .left) ? -blockXPosition : blockXPosition
        newNode.position.y = yPosition
        newNode.name = (position == .left) ? "node\(count)A" : "node\(count)B"
        newNode.texture = cenarioNode.texture
        
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: blockWidth, height: blockHeight))
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
    
    func stepFeedback() {
        stepFeedbackGenerator.prepare()
        stepFeedbackGenerator.impactOccurred()
    }
    
    func gameOverFeedback() {
        gameOverImpactGenerator.prepare()
        gameOverImpactGenerator.impactOccurred()
        run(hurtSoundAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if game.status == .running {
            if (viewController?.timeBarWidthConstraint.constant)! > 1 {
                switch climbDistance {
                case 0:
                    print("Waiting game to start")
                case 1...999:
                    viewController?.timeBarWidthConstraint.constant -= 0.4
                case 1000...1999:
                    viewController?.timeBarWidthConstraint.constant -= 0.525
                case 2000...2999:
                    viewController?.timeBarWidthConstraint.constant -= 0.65
                case 3000...3999:
                    viewController?.timeBarWidthConstraint.constant -= 0.775
                default:
                    viewController?.timeBarWidthConstraint.constant -= 0.9
                }
                
                if climbDistance != 0 {
                    viewController?.hideTapButtons()
                }
            } else {
                game.status = .over
                gameOverFeedback()
                viewController?.showRevive()
            }
        }
    }
}
