import Foundation
import SwiftUI

// 1. Resposta da API para a LISTA (limit=151)
struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

// 2. Item individual na lista
struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: String
    
    // Pega o ID da URL
    var id: Int? {
        return Int(url.split(separator: "/").last?.description ?? "0")
    }
}

// 3. Modelo para os DETALHES de um Pokémon (Baseado no seu JsonPokeAPI.pdf)
// Isto substitui o seu "PokemonDados"
struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int // Altura
    let weight: Int // Peso
    let types: [TypeEntry]
    let stats: [StatEntry]
    let sprites: SpriteEntry
    
    // Propriedade para pegar a cor do primeiro tipo
    var primaryTypeColor: Color {
        let typeName = types.first?.type.name ?? "none"
        return TypeEnum(rawValue: typeName)?.color ?? .gray
    }
}

// --- Structs Auxiliares (Exatamente como no JsonPokeAPI.pdf) ---

struct TypeEntry: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String // "grass", "poison", etc.
}

struct StatEntry: Codable {
    let baseStat: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatInfo: Codable {
    let name: String // "hp", "attack", etc.
}

struct SpriteEntry: Codable {
    let other: OtherSprites?
    
    // Propriedade para pegar a imagem bonita (como na sua imagem de design)
    var officialArtwork: String {
        return other?.officialArtwork.frontDefault ?? ""
    }
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}