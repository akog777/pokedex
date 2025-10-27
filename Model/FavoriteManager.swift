import Foundation
import SwiftUI

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private(set) var favorites: [String] = []
    
    private init() {
        favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? []
    }
    
    func toggleFavorite(pokemon: PokemonUrl) {
        if let index = favorites.firstIndex(of: pokemon.name) {
            favorites.remove(at: index)
        } else {
            favorites.append(pokemon.name)
        }
        save()
    }
    
    func isFavorite(pokemon: PokemonUrl) -> Bool {
        favorites.contains(pokemon.name)
    }
    
    func reloadFavorites() {
        favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? []
    }
    
    private func save() {
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
}
