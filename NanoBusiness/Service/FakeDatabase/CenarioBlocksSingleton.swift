import Foundation
import SpriteKit

final class CenarioBlocksSingleton {
    static var shared = CenarioBlocksSingleton()
    var cenarioBlocks: [CenarioBlock] = []
    
    private init() {
        cenarioBlocks = [
            //0
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 4, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeEstalactiteDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverDireita"), categoryMask: 1, collisionMask: 0, contactMask: 0)
            ),
            //1
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeEstalactiteEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverEsquerda"), categoryMask: 1, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 4, collisionMask: 0, contactMask: 0)
            ),
            //2
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredePedraEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverEsquerda"), categoryMask: 1, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 8, collisionMask: 0, contactMask: 0)
            ),
            //3
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredePedraDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverDireita"), categoryMask: 1, collisionMask: 0, contactMask: 0)
            ),
            //4
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeEstalactiteEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverEsquerda"), categoryMask: 1, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 8, collisionMask: 0, contactMask: 0)
            ),
            //5
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeEstalactiteDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverDireita"), categoryMask: 1, collisionMask: 0, contactMask: 0)
            ),
            //6
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 4, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 8, collisionMask: 0, contactMask: 0)
            ),
            //7
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 4, collisionMask: 0, contactMask: 0)
            ),
            //8
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 8, collisionMask: 0, contactMask: 0)
            ),
            //9
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 4, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredePedraDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverDireita"), categoryMask: 1, collisionMask: 0, contactMask: 0)
            ),
            //10
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredePedraEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverEsquerda"), categoryMask: 1, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 4, collisionMask: 0, contactMask: 0)
            ),
            //11
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 4, collisionMask: 0, contactMask: 0)
            ),
            //12
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 8, collisionMask: 0, contactMask: 0)
            ),
            //13
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaEsquerda"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 4, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredePedraDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeGameOverDireita"), categoryMask: 1, collisionMask: 0, contactMask: 0)
            ),
            //14
            CenarioBlock(
                leftNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeVaziaEsquerda"), categoryMask: 8, collisionMask: 0, contactMask: 0),
                rightNode: CenarioNode(size: CGSize.init(width: 287.227, height: 252.04), texture: SKTexture(imageNamed: "paredeMoedaDireita"), afterCollisionTexture: SKTexture(imageNamed: "paredeVaziaDireita"), categoryMask: 4, collisionMask: 0, contactMask: 0)
            ),
        ]
    }
    
}
