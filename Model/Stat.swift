import Foundation

struct Stat: Codable {
    let baseStat: Int
    let stat: StatDetail
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatDetail: Codable {
    let name: String
}
