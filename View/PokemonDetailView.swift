import SwiftUI

// Tela de detalhes do Pokémon (Focando na aba "About" e "Stats")
struct PokemonDetailView: View {
    let pokemon: PokemonDetail
    
    // @State para controlar o Picker (Segmented Control)
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
                    
                    // Picker (Abas)
                    Picker("Details", selection: $selectedTab) {
                        Text("About").tag(0)
                        Text("Stats").tag(1)
                        Text("Evolution").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Conteúdo das Abas
                    if selectedTab == 0 {
                        PokemonAboutView(pokemon: pokemon)
                    } else if selectedTab == 1 {
                        PokemonStatsView(pokemon: pokemon)
                    } else {
                        Text("Evolução (placeholder)")
                            .padding()
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(30)
                .offset(y: -50) // Sobe o card
                .padding(.bottom, -50) // Remove espaço extra
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- Sub-views para as Abas ---

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
        .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    // Barra de progresso (ProgressView)
                    ProgressView(value: Double(statEntry.baseStat), total: 200)
                        .tint(statEntry.baseStat > 50 ? .green : .red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}