import Foundation

final class UserDefaultsService {
    
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
}
