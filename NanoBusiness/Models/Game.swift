import Foundation

final class Game {
    var status: GameStatus
    
    init() {
        self.status = .start
    }
    
    enum GameStatus {
        case start
        case running
        case paused
        case over
    }
}
