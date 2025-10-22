import Foundation
import SwiftUI

// Usa ObservableObject, como na Aula 03
class PokemonViewModel: ObservableObject {
    
    // Usa @Published para atualizar a View
    @Published var pokemonList: [PokemonDetail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let baseURL = "https://pokeapi.co/api/v2/pokemon/"

    // Função principal chamada pela ContentView
    func fetchAllPokemon() {
        guard pokemonList.isEmpty else { return } // Evita recarregar
        
        self.isLoading = true
        self.errorMessage = nil
        
        // 1. Buscar a lista inicial (nomes e URLs)
        fetchPokemonList { [weak self] result in
            
            // Garante que estamos na thread principal para atualizar a UI
            DispatchQueue.main.async {
                switch result {
                case .success(let listItems):
                    // 2. Se a lista veio, busca os detalhes de cada um
                    self?.fetchDetailsForAll(listItems)
                    
                case .failure(let error):
                    self?.errorMessage = "Falha ao carregar lista: \(error.localizedDescription)"
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Busca a lista de 151 Pokémon
    private func fetchPokemonList(completion: @escaping (Result<[PokemonListItem], apiError>) -> Void) {
        guard let url = URL(string: "\(baseURL)?limit=151") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Usa URLSession.shared.dataTask, como na Aula 04
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.invalidData)) // Ou um erro mais específico
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let listResponse = try decoder.decode(PokemonListResponse.self, from: data)
                completion(.success(listResponse.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume() // Não esqueça de .resume()!
    }
    
    // Função para buscar os detalhes de todos os Pokémon da lista
    private func fetchDetailsForAll(_ items: [PokemonListItem]) {
        let group = DispatchGroup() // Usamos um DispatchGroup para saber quando todos terminaram
        var details: [PokemonDetail] = []
        
        for item in items {
            guard let detailURL = URL(string: item.url) else { continue }
            
            group.enter() // Entra no grupo antes de cada chamada
            
            URLSession.shared.dataTask(with: detailURL) { data, _, error in
                defer { group.leave() } // Sai do grupo ao final, mesmo se der erro
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let detail = try decoder.decode(PokemonDetail.self, from: data)
                        // Adiciona o detalhe de forma segura (multi-thread)
                        // (Para este caso simples, podemos adicionar fora)
                        // Mas para garantir, vamos usar uma fila serial
                        DispatchQueue.main.async {
                            details.append(detail)
                        }
                    } catch {
                        print("Erro ao decodificar \(item.name): \(error)")
                    }
                }
            }.resume()
        }
        
        // 3. Notifica quando TODAS as chamadas terminarem
        group.notify(queue: .main) {
            // Ordena pela ID e atualiza a UI
            self.pokemonList = details.sorted(by: { $0.id < $1.id })
            self.isLoading = false
        }
    }
    
    // ATENÇÃO: A função de busca (BuscaPokemon) ainda precisará ser implementada
    // usando a mesma lógica de URLSession.
}