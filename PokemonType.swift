import Foundation

struct PokemonType: Codable {
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
}
