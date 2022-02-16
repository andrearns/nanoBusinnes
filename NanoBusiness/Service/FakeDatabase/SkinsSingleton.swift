import Foundation

final class SkinsSingleton {
    static var shared = SkinsSingleton()
    var skins: [Skin] = []
    
    private init() {
        skins = [
            Skin(spriteImageName: "player-1", name: "Eve Rise", description: "An ascending climber", coinCost: nil, distanceRequired: nil, isLocked: false),
            Skin(spriteImageName: "playerRobot", name: "SKP-N0W", description: "Nobody can track them here", coinCost: 5000, distanceRequired: nil, isLocked: true),
            Skin(spriteImageName: "playerSnowman", name: "Snowman", description: "The others melted", coinCost: 1000, distanceRequired: 10000, isLocked: true)
        ]
    }
}
