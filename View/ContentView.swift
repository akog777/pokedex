import Foundation
import SwiftUI

struct ContentView: View {
    // 1. Cria uma instância do ViewModel
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // --- Cabeçalho ---
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
                
                // --- Lista de Pokémon ---
                if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                    ProgressView("Carregando Pokémon...")
                        .frame(maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.pokemonList) { pokemon in
                                // 2. Navega para a DetailView com o Pokémon
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    PokemonRowView(pokemon: pokemon)
                                }
                                .buttonStyle(.plain) // Remove a cor azul do link
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                // --- Barra de Navegação Inferior ---
                HStack {
                    Button {
                        // Ação Estrela (Favoritos)
                    } label: {
                        Image("estrela")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    Image("pokebola")
                        .resizable()
                        .frame(width: 70, height: 70)
                    
                    Spacer()
                    
                    // 3. Passa o ViewModel para a tela de Busca
                    NavigationLink(destination: BuscaPokemon().environmentObject(viewModel)) {
                        Image("lupa")
                            .resizable()
                            .frame(width: 65, height: 65)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 5)
                .frame(height: 80)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .task {
                // 4. Chama a função para buscar os dados quando a View aparecer
                await viewModel.fetchAllPokemon()
            }
        }
    }
}

#Preview {
    ContentView()
}