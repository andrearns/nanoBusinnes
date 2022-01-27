import Foundation

final class Game {
    var status: GameStatus
    
    init() {
        self.status = .running
    }
    
    enum GameStatus {
        case start
        case running
        case over
    }
}
