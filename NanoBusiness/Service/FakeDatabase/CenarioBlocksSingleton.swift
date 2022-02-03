import Foundation
import SpriteKit

final class CenarioBlocksSingleton {
    static var shared = CenarioBlocksSingleton()
    var cenarioBlocks: [CenarioBlock] = []
    
    private init() {
        cenarioBlocks = [
            // WARNING: Put correct arguments here
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            ),
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: "")),
                rightNode: CenarioNode(size: CGSize.init(width: 0, height: 0), xPosition: 0, texture: SKTexture(imageNamed: ""))
            )
        ]
    }
    
}
