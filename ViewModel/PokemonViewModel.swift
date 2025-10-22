import Foundation
import SwiftUI

class PokemonViewModel: ObservableObject {
    
    @Published var pokemonList: [PokemonDetail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // NOVAS PROPRIEDADES PARA FAVORITOS
    @Published var favoriteIDs: Set<Int> = []
    @Published var favoritePokemon: [PokemonDetail] = []
    private let favoritesKey = "pokemonFavorites" // Chave para salvar no UserDefaults

    let baseURL = "https://pokeapi.co/api/v2/pokemon/"

    // MODIFICAR o init() para carregar os favoritos
    init() {
        loadFavorites()
    }
    
    // --- FUNÇÕES DE API (sem alteração) ---
    
    func fetchAllPokemon() {
        // ... (seu código existente para fetchAllPokemon) ...
        
        // APENAS ADICIONE UMA LINHA DENTRO DO group.notify
        
        // ... (seu código de dataTask) ...
        
        group.notify(queue: .main) {
            self.pokemonList = details.sorted(by: { $0.id < $1.id })
            self.isLoading = false
            
            // ADICIONE ESTA LINHA AQUI
            self.updateFavoritePokemonList() // Atualiza a lista de favoritos
        }
    }
    
    private func fetchPokemonList(completion: @escaping (Result<[PokemonListItem], apiError>) -> Void) {
        // ... (sem alterações) ...
    }
    
    private func fetchDetailsForAll(_ items: [PokemonListItem]) {
        // ... (sem alterações, exceto a linha que você já adicionou no fetchAllPokemon) ...
    }
    
    
    // --- NOVAS FUNÇÕES DE FAVORITOS ---
    
    // Carrega os IDs salvos no UserDefaults
    func loadFavorites() {
        let ids = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        self.favoriteIDs = Set(ids)
        // Atualiza a lista de objetos Pokemon com base nos IDs
        updateFavoritePokemonList()
    }
    
    // Salva os IDs no UserDefaults
    private func saveFavorites() {
        let ids = Array(self.favoriteIDs)
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
    
    // Verifica se um Pokémon é favorito
    func isFavorite(pokemon: PokemonDetail) -> Bool {
        return favoriteIDs.contains(pokemon.id)
    }
    
    // Adiciona ou remove um Pokémon dos favoritos
    func toggleFavorite(pokemon: PokemonDetail) {
        if isFavorite(pokemon: pokemon) {
            favoriteIDs.remove(pokemon.id)
        } else {
            favoriteIDs.insert(pokemon.id)
        }
        
        // Salva e atualiza a lista
        saveFavorites()
        updateFavoritePokemonList()
    }
    
    // Cria a lista [PokemonDetail] apenas com os favoritos
    func updateFavoritePokemonList() {
        // Filtra a lista principal de Pokémon (pokemonList)
        // para encontrar apenas aqueles cujos IDs estão no set favoriteIDs
        self.favoritePokemon = self.pokemonList
            .filter { favoriteIDs.contains($0.id) }
            .sorted(by: { $0.id < $1.id }) // Opcional: manter ordenado
    }
}