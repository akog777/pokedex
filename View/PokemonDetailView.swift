import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.presentationMode) var presentationMode // Para o botão de voltar
    @EnvironmentObject var viewModel: PokemonViewModel // Recebe o ViewModel
    let pokemon: PokemonDetail
    
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack {
                // --- Cabeçalho com Imagem ---
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(pokemon.primaryTypeColor)
                        .frame(height: 300)
                        .ignoresSafeArea()
                    
                    // --- (NOVO) Botões de Voltar e Favorito ---
                    HStack {
                        // Botão Voltar
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        // Botão Favorito
                        Button {
                            viewModel.toggleFavorite(pokemon: pokemon)
                        } label: {
                            Image(systemName: viewModel.isFavorite(pokemon: pokemon) ? "star.fill" : "star")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.isFavorite(pokemon: pokemon) ? .yellow : .white)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 50) // Ajuste para a safe area
                    .frame(maxHeight: .infinity, alignment: .top)
                    // --- Fim dos Botões ---

                    
                    AsyncImage(url: URL(string: pokemon.sprites.officialArtwork)) {
                        // ... (código da imagem sem alteração) ...
                    }
                    .padding(.bottom, 20)
                }
                
                // --- Informações (Card Branco) ---
                VStack(spacing: 16) {
                    // ... (Restante do card: Nome, Tipos, Picker, Abas) ...
                    // ... (Nenhuma alteração aqui) ...
                }
                .padding()
                .background(.white)
                .cornerRadius(30)
                .offset(y: -50)
                .padding(.bottom, -50)
                
                Spacer() // Empurra a barra de nav para baixo
                
                // --- (NOVO) Barra de Navegação Inferior ---
                Divider()
                HStack {
                    // Nota: Os botões aqui não farão nada,
                    // pois estamos em uma tela "funda" na navegação.
                    // Eles estão aqui para manter o design.
                    Image("estrela")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .opacity(0.5)
                    Spacer()
                    Image("pokebola")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(0.5)
                    Spacer()
                    Image("lupa")
                        .resizable()
                        .frame(width: 65, height: 65)
                        .opacity(0.5)
                }
                .padding(.horizontal, 30)
                .padding(.top, 5)
                .frame(height: 80)
                // --- Fim da Barra ---
                
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true) // Continua escondida
        .edgesIgnoringSafeArea(.top) // Ignora o topo
    }
}