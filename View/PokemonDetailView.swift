import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: PokemonViewModel
    let pokemon: PokemonDetail
    
    // O @State agora só precisa ir de 0 (About) a 1 (Stats)
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack {
                // --- Cabeçalho com Imagem (Sem alterações) ---
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(pokemon.primaryTypeColor)
                        .frame(height: 300)
                        .ignoresSafeArea()
                    
                    // Botões de Voltar e Favorito (Sem alterações)
                    HStack {
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
                    .padding(.top, 50)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    // Imagem (Sem alterações)
                    AsyncImage(url: URL(string: pokemon.sprites.officialArtwork)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                    .padding(.bottom, 20)
                }
                
                // --- Informações (Card Branco) ---
                VStack(spacing: 16) {
                    // Nome e Tipos (Sem alterações)
                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        ForEach(pokemon.types, id: \.slot) { typeEntry in
                            Text(typeEntry.type.name.capitalized)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(TypeEnum(rawValue: typeEntry.type.name)?.color ?? .gray)
                                .cornerRadius(20)
                        }
                    }
                    
                    // --- MODIFICAÇÃO AQUI ---
                    // Picker (Abas) - Removida a tag "Evolution"
                    Picker("Details", selection: $selectedTab) {
                        Text("About").tag(0)
                        Text("Stats").tag(1)
                        // Text("Evolution").tag(2) // REMOVIDO
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // --- MODIFICAÇÃO AQUI ---
                    // Conteúdo das Abas - Removido o 'else' para Evolution
                    if selectedTab == 0 {
                        PokemonAboutView(pokemon: pokemon)
                    } else { // MODIFICADO (era 'else if selectedTab == 1')
                        PokemonStatsView(pokemon: pokemon)
                    }
                    // O 'else' para Evolution foi totalmente REMOVIDO
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(30)
                .offset(y: -50)
                .padding(.bottom, -50)
                
                Spacer() 
                
                // --- Barra de Navegação Inferior (Sem alterações) ---
                Divider()
                HStack {
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
                
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

// --- Sub-views para as Abas (Sem alterações) ---
// O alinhamento já estava correto aqui, usando VStack(alignment: .leading)
// e .frame(maxWidth: .infinity, alignment: .leading)

struct PokemonAboutView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Pokédex Data")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text("Height")
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                Text("\(Double(pokemon.height) / 10.0, specifier: "%.1f") m")
            }
            HStack {
                Text("Weight")
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                Text("\(Double(pokemon.weight) / 10.0, specifier: "%.1f") kg")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Garante o alinhamento à esquerda
    }
}

struct PokemonStatsView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Base Stats")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(pokemon.stats, id: \.stat.name) { statEntry in
                HStack {
                    Text(statEntry.stat.name.capitalized)
                        .frame(width: 80, alignment: .leading)
                        .foregroundColor(.gray)
                    Text("\(statEntry.baseStat)")
                        .frame(width: 35)
                    
                    ProgressView(value: Double(statEntry.baseStat), total: 200)
                        .tint(statEntry.baseStat > 50 ? .green : .red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Garante o alinhamento à esquerda
    }
}