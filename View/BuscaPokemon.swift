import Foundation
import SwiftUI

struct BuscaPokemon: View {
    // 1. Recebe o ViewModel do ambiente
    @EnvironmentObject var viewModel: PokemonViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Busca")
                        .bold()
                        .font(.largeTitle)
                        .padding(.horizontal)
                    
                    // 2. Barra de busca que chama o ViewModel
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Qual Pokémon deseja pesquisar?", text: $searchText)
                            .onSubmit {
                                // 3. Chama a função de busca ao pressionar "Enter"
                                Task {
                                    await viewModel.searchPokemon(query: searchText)
                                }
                            }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                Spacer()
            }
            
            // --- Área de Resultado ---
            if viewModel.isLoading {
                ProgressView("Buscando...")
                    .padding(.top, 50)
            } else if let pokemon = viewModel.searchResult {
                // 4. Mostra o resultado e permite navegar para os detalhes
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    PokemonRowView(pokemon: pokemon)
                        .padding()
                }
                .buttonStyle(.plain)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 50)
            }
            
            Spacer()
            
            // --- Barra de Navegação Inferior ---
            Divider()
            HStack {
                Button { /* Ação Estrela */ } label: {
                    Image("estrela")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Image("pokebola")
                    .resizable()
                    .frame(width: 70, height: 70)
                Spacer()
                Image("lupa") // Já estamos na Lupa, então fica desabilitada
                    .resizable()
                    .frame(width: 65, height: 65)
                    .opacity(0.5)
            }
            .padding(.horizontal, 30)
            .padding(.top, 5)
            .frame(height: 80)
        }
        .navigationBarHidden(true)
        .onAppear {
            // 5. Limpa a busca anterior ao entrar na tela
            viewModel.searchResult = nil
            viewModel.errorMessage = nil
            searchText = ""
        }
    }
}

#Preview {
    BuscaPokemon()
        .environmentObject(PokemonViewModel()) // Adiciona um ViewModel para o Preview
}