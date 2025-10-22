import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ... (Cabeçalho e Lista de Pokémon - sem alterações) ...
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Creatures")
                            .bold()
                            .font(.largeTitle)
                        Text("Gen I")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                    // ... (ProgressView) ...
                } else if let error = viewModel.errorMessage {
                    // ... (Text(error)) ...
                } else {
                    List(viewModel.pokemonList) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRowView(pokemon: pokemon)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }
                    .listStyle(.plain)
                }
                
                Divider()
                
                // --- Barra de Navegação Inferior (MODIFICADA) ---
                HStack {
                    
                    // MUDANÇA AQUI: Agora é um NavigationLink
                    NavigationLink(destination: FavoritesView()) {
                        Image("estrela")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .opacity(0.5) // Fica "desselecionado"
                    }
                    
                    Spacer()
                    
                    Image("pokebola") // Este é o "Home", fica selecionado
                        .resizable()
                        .frame(width: 70, height: 70)
                    
                    Spacer()
                    
                    NavigationLink(destination: BuscaPokemon()) {
                        Image("lupa")
                            .resizable()
                            .frame(width: 65, height: 65)
                            .opacity(0.5)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 5)
                .frame(height: 80)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchAllPokemon()
            }
            // PASSA O VIEWMODEL PARA AS OUTRAS TELAS
            .environmentObject(viewModel) 
        }
    }
}