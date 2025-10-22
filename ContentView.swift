import Foundation
import SwiftUI

struct ContentView: View {
    // 1. Cria uma instância do ViewModel com @StateObject
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        // Usa NavigationStack como na Aula 03
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
                    // Usa List e ForEach, como na Aula 03
                    List(viewModel.pokemonList) { pokemon in
                        // 2. NavigationLink para a DetailView
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRowView(pokemon: pokemon)
                        }
                        .listRowInsets(EdgeInsets()) // Remove padding da linha
                        .listRowSeparator(.hidden) // Remove divisor
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }
                    .listStyle(.plain) // Remove o estilo da lista
                }
                
                Divider()
                
                // --- Barra de Navegação Inferior ---
                HStack {
                    Image("estrela")
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                    Spacer()
                    
                    Image("pokebola")
                        .resizable()
                        .frame(width: 70, height: 70)
                    
                    Spacer()
                    
                    // Link para a sua tela de Busca
                    NavigationLink(destination: BuscaPokemon()) {
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
            .onAppear { // Usa .onAppear, como na Aula 03
                // 3. Chama a função para buscar os dados
                viewModel.fetchAllPokemon()
            }
        }
    }
}