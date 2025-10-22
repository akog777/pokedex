import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let sprites: Sprites
    let height: Int
    let weight: Int
    let stats: [Stat]
    let abilities: [Ability]
    
    var formattedHeight: String {
        let meters = Double(height) / 10.0
        return String(format: "%.1f m", meters)
    }
    
    var formattedWeight: String {
        let kg = Double(weight) / 10.0
        return String(format: "%.1f kg", kg)
    }
    
    var imageUrl: String {
        sprites.other.officialArtwork.frontDefault ?? sprites.frontDefault ?? ""
    }
}
