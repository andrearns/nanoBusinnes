import Foundation

final class UserDefaultsService {
    
    // Record
    static func setNewRecord(_ record: Int) {
        let data = try? JSONEncoder().encode(record)
        return UserDefaults.standard.set(data, forKey: "Record")
    }
    
    static func fetchRecord() -> Int {
        guard let data = UserDefaults.standard.data(forKey: "Record") else {
            return 0
        }
        let record = try? JSONDecoder().decode(Int.self, from: data)
        return record!
    }
    
    // Coins
    static func setCoinsCount(_ count: Int) {
        let data = try? JSONEncoder().encode(count)
        return UserDefaults.standard.set(data, forKey: "Coins")
    }
    
    static func fetchCoinsCount() -> Int {
        guard let data = UserDefaults.standard.data(forKey: "Coins") else {
            return 0
        }
        let record = try? JSONDecoder().decode(Int.self, from: data)
        return record!
    }
    
    // Games played
    static func setGamesPlayed(_ count: Int) {
        let data = try? JSONEncoder().encode(count)
        return UserDefaults.standard.set(data, forKey: "Games Played")
    }
    
    static func fetchGamesPlayed() -> Int {
        guard let data = UserDefaults.standard.data(forKey: "GamesPlayed") else {
            return 0
        }
        let record = try? JSONDecoder().decode(Int.self, from: data)
        return record!
    }
    
    // Current skin image name
    static func setSelectedSkinName(_ name: String) {
        let data = try? JSONEncoder().encode(name)
        return UserDefaults.standard.set(data, forKey: "Current skin")
    }
    
    static func fetchSelectedSkinName() -> String {
        guard let data = UserDefaults.standard.data(forKey: "Current skin") else {
            return "Eve Rise"
        }
        let record = try? JSONDecoder().decode(String.self, from: data)
        return record!
    }
    
    // Skins unlocked
    static func setUnlockedSkinsNames(_ array: [String]) {
        let data = try? JSONEncoder().encode(array)
        return UserDefaults.standard.set(data, forKey: "Unlocked skins IDs")
    }
    
    static func fetchUnlockedSkinsNames() -> [String] {
        guard let data = UserDefaults.standard.data(forKey: "Unlocked skins IDs") else {
            return ["Eve Rise"]
        }
        let record = try? JSONDecoder().decode([String].self, from: data)
        return record!
    }
    
}
