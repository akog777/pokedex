import Foundation
import SwiftUI

// 1. Resposta da API para a LISTA de Pokémon (ex: .../pokemon?limit=151)
struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

// 2. Item individual na lista de Pokémon
struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: String
    
    // Pega o ID da URL, como você pediu!
    var id: Int? {
        return Int(url.split(separator: "/").last?.description ?? "0")
    }
}

// 3. Modelo para os DETALHES de um Pokémon (ex: .../pokemon/1/)
// Isto substitui o seu "PokemonDados"
struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int // Altura em decímetros
    let weight: Int // Peso em hectogramas
    let types: [TypeEntry]
    let stats: [StatEntry]
    let sprites: SpriteEntry
    
    // Propriedades formatadas para a View
    var formattedHeight: String {
        "\(Double(height) / 10.0) m"
    }
    
    var formattedWeight: String {
        "\(Double(weight) / 10.0) kg"
    }
    
    // Pega a cor do primeiro tipo para o card
    var primaryTypeColor: Color {
        let typeName = types.first?.type.name ?? "none"
        return TypeEnum(rawValue: typeName)?.color ?? .gray
    }
}

// --- Structs Auxiliares para Decodificação ---

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
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}