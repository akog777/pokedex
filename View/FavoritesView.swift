import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: PokemonViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // --- Cabeçalho ---
            HStack {
                Text("Your favorites Pokémons:")
                    .bold()
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            
            // --- Lista de Favoritos ---
            if viewModel.favoritePokemon.isEmpty {
                Spacer()
                Text("Você ainda não favoritou nenhum Pokémon.")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(viewModel.favoritePokemon) { pokemon in
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
            
            // --- Barra de Navegação Inferior (Cópia da ContentView) ---
            HStack {
                // O botão de estrela fica "selecionado"
                Image("estrela")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .colorMultiply(.red) // Cor para indicar seleção
                
                Spacer()
                
                // Botão "Home" (pokebola) leva de volta (usa presentationMode)
                // Nota: Esta navegação é básica. O ideal seria um TabView.
                Image("pokebola")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .opacity(0.5) // Indica que não está selecionado
                
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
        .navigationBarHidden(true)
        .onAppear {
            // Garante que a lista de favoritos esteja atualizada
            viewModel.updateFavoritePokemonList()
        }
    }
}