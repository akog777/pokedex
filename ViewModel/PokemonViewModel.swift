import Foundation
import Combine

@MainActor // Garante que as atualizações de @Published ocorram na thread principal
class PokemonViewModel: ObservableObject {
    
    @Published var pokemonList: [PokemonDetail] = []
    @Published var searchResult: PokemonDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let baseURL = "https://pokeapi.co/api/v2/pokemon/"

    // Função principal chamada pela ContentView
    func fetchAllPokemon() async {
        // Evita recarregar se a lista já estiver cheia
        guard pokemonList.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Buscar a lista inicial (nomes e URLs)
            let listItems = try await fetchPokemonList()
            
            // 2. Buscar os detalhes para cada item da lista
            // Usamos um TaskGroup para fazer várias chamadas em paralelo
            var details: [PokemonDetail] = []
            
            try await withThrowingTaskGroup(of: PokemonDetail.self) { group in
                for item in listItems {
                    group.addTask {
                        // `fetchPokemonDetail` precisa de uma URL
                        return try await self.fetchPokemonDetail(from: item.url)
                    }
                }
                
                // Coleta os resultados conforme chegam
                for try await detail in group {
                    details.append(detail)
                }
            }
            
            // 3. Ordena pela ID e atualiza a View
            self.pokemonList = details.sorted(by: { $0.id < $1.id })
            
        } catch let error as apiError {
            self.errorMessage = "Erro de API: \(error)"
        } catch {
            self.errorMessage = "Erro desconhecido: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Função de busca chamada pela BuscaPokemon
    func searchPokemon(query: String) async {
        let searchQuery = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !searchQuery.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        searchResult = nil // Limpa busca anterior
        
        do {
            let detail = try await fetchPokemonDetail(from: "\(baseURL)\(searchQuery)/")
            self.searchResult = detail
        } catch {
            self.errorMessage = "Pokémon '\(query)' não encontrado."
        }
        
        isLoading = false
    }

    // --- Funções Privadas de Fetch ---
    
    // Busca a lista de 151 Pokémon
    private func fetchPokemonList() async throws -> [PokemonListItem] {
        guard let url = URL(string: "\(baseURL)?limit=151") else {
            throw apiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw apiError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonListResponse.self, from: data).results
        } catch {
            throw apiError.invalidData
        }
    }
    
    // Busca os detalhes de UM Pokémon
    private func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail {
        guard let url = URL(string: urlString) else {
            throw apiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw apiError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonDetail.self, from: data)
        } catch {
            print("Erro ao decodificar: \(error)")
            throw apiError.invalidData
        }
    }
}