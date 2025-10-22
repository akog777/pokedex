import SwiftUI

// Tela de detalhes do Pokémon
struct PokemonDetailView: View {
    let pokemon: PokemonDetail
    
    // 0 = About, 1 = Stats, 2 = Evolution
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack {
                // --- Cabeçalho com Imagem ---
                ZStack(alignment: .bottom) {
                    // Fundo colorido
                    Rectangle()
                        .fill(pokemon.primaryTypeColor)
                        .frame(height: 300)
                        .ignoresSafeArea()
                    
                    // Imagem
                    AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) { image in
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
                VStack {
                    // Nomes e Tipos
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
                    .padding(.bottom)
                    
                    // Picker (Abas)
                    Picker("Details", selection: $selectedTab) {
                        Text("About").tag(0)
                        Text("Stats").tag(1)
                        Text("Evolution").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Conteúdo das Abas
                    VStack(alignment: .leading, spacing: 15) {
                        if selectedTab == 0 {
                            PokemonAboutView(pokemon: pokemon)
                        } else if selectedTab == 1 {
                            PokemonStatsView(pokemon: pokemon)
                        } else {
                            Text("Informações de evolução indisponíveis.")
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(30)
                .offset(y: -50) // Sobe o card para sobrepor
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
                Text(pokemon.formattedHeight)
            }
            HStack {
                Text("Weight")
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                Text(pokemon.formattedWeight)
            }
        }
        .padding()
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
                    
                    // Barra de progresso para o stat
                    ProgressView(value: Double(statEntry.baseStat), total: 200) // 200 é um total razoável
                        .tint(statEntry.baseStat > 50 ? .green : .red)
                }
            }
        }
        .padding()
    }
}