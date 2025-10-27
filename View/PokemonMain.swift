import Foundation
import SwiftUI

struct PokemonMain: View {
    @State private var user: PokemonResults?
    @State private var pokemons: [PokemonUrl] = []
    @State private var loadingError: String?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    Spacer(minLength: 30)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Creatures")
                                .bold()
                                .font(.title)
                                .frame(width: 160)
                            Text("Gen I")
                                .frame(width: 80)
                                .font(.system(size: 21))
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    if let loadingError {
                        Text(loadingError)
                            .foregroundStyle(.red)
                            .padding()
                    } else if pokemons.isEmpty {
                        ProgressView("Carregando Pokémons...")
                            .padding()
                    }
                    
                    ForEach(pokemons) { pokemon in
                        NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
                            PokemonCards(pokemon: pokemon)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Divider()
            HStack {
                NavigationLink(destination: PokemonFavorites()) {
                    Image(systemName: "star")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
                Spacer()
                Image("pokebola")
                    .resizable()
                    .frame(width: 60, height: 60)
                Spacer()
                NavigationLink(destination: PokemonSearch()) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .task {
            do {
                let list = try await PokemonAPI.getPokemon()
                self.pokemons = list
            } catch {
                self.loadingError = "Erro ao carregar Pokémons."
            }
        }
    }
}

#Preview {
    PokemonMain()
}
