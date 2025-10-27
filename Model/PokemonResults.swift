
import Foundation
import SwiftUI

struct PokemonResults: Codable {
    let results: [PokemonUrl]
}

struct PokemonDados: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let stats: [PokemonStat]
    let abilities: [AbilityEntry]
    let species: NamedAPIResource
}

struct PokemonStat: Codable {
    let baseStat: Int
    let stat: StatInfo
}

struct StatInfo: Codable {
    let name: String
}

struct PokemonTypeEntry: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonUrl: Codable, Identifiable {
    let name: String
    let url: String
    var id: String { url }
}

struct Sprites: Codable {
    let frontDefault: String
}

struct AbilityEntry: Codable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}
