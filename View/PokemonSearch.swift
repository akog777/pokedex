import SwiftUI
import Foundation

struct PokemonSearch: View {
    @State private var searchText = ""
    @State private var pokemons: [PokemonUrl] = []

    var pokemonsfiltrados: [PokemonUrl] {
        if searchText.isEmpty {
            pokemons
        } else {
            pokemons.filter { pokemon in
                pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(pokemonsfiltrados) { pokemon in
                            NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
                                PokemonCards(pokemon: pokemon)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .navigationTitle("Search")
                .searchable(text: $searchText, prompt: "Qual Pokémon deseja buscar?")
                
                Divider()
            }
        }
        .task {
            do {
                let list = try await PokemonAPI.getPokemon()
                self.pokemons = list
            } catch {
                print("Erro ao buscar pokémons: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonSearch()
    }
}
