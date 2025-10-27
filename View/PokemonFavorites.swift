import Foundation
import SwiftUI

struct PokemonFavorites: View {
    private let favManager = FavoriteManager.shared
    @State private var favoritePokemons: [PokemonUrl] = []
    @State private var allPokemons: [PokemonUrl] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Favoritos")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                if favoritePokemons.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Nenhum favorito ainda")
                            .font(.title2)
                            .bold()
                        Text("Adicione pokémons aos favoritos")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(favoritePokemons) { pokemon in
                            NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
                                PokemonCards(pokemon: pokemon)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadFavorites()
        }
        .task {
            do {
                allPokemons = try await PokemonAPI.getPokemon()
                loadFavorites()
            } catch {
                print("Erro ao carregar favoritos")
            }
        }
    }
    
    private func loadFavorites() {
        favManager.reloadFavorites()
        favoritePokemons = allPokemons.filter { favManager.favorites.contains($0.name) }
    }
}

#Preview {
    PokemonFavorites()
}
