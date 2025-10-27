import Foundation
import SwiftUI

struct PokemonAPI{
    static func getPokemon() async throws -> [PokemonUrl] {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        guard let url = URL(string: endpoint) else{
            throw PokemonError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
            response.statusCode == 200 else{
            throw PokemonError.invalidResponse
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(PokemonResults.self, from: data).results
        }catch{
            throw PokemonError.invalidData
        }
    }
}

func getPokemonDados(from urlString: String) async throws -> PokemonDados{
    guard let url = URL(string: urlString) else{ throw PokemonError.invalidURL}
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let http = response as? HTTPURLResponse,
        http.statusCode == 200 else{
        throw PokemonError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(PokemonDados.self, from: data)
}
#Preview {
    ContentView()
}
