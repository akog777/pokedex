import SwiftUI

struct PokemonDetail: View {
    let pokemon: PokemonUrl
    @State private var details: PokemonDados?
    @State private var selectedTab = "About"
    @State private var isFavorite = false
    private let favManager = FavoriteManager.shared
    
    var cardColor: Color {
        guard let details = details,
              let firstType = details.types.first?.type.name,
              let typeEnum = TypeEnum(rawValue: firstType) else {
            return .red
        }
        return typeEnum.color
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PokemonHeaderView(
                pokemon: pokemon,
                details: details,
                cardColor: cardColor
            )
            PokemonContentView(
                details: details,
                cardColor: cardColor,
                selectedTab: $selectedTab
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    favManager.toggleFavorite(pokemon: pokemon)
                    updateFavoriteStatus()
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(.black)
                        .font(.system(size: 28))
                }
            }
        }
        .onAppear {
            updateFavoriteStatus()
        }
        .task {
            do {
                let detail = try await getPokemonDados(from: pokemon.url)
                self.details = detail
                updateFavoriteStatus()
            } catch {
                print("Erro ao buscar detalhes")
            }
        }
    }
    
    private func updateFavoriteStatus() {
        favManager.reloadFavorites()
        isFavorite = favManager.isFavorite(pokemon: pokemon)
    }
}

struct PokemonHeaderView: View {
    let pokemon: PokemonUrl
    let details: PokemonDados?
    let cardColor: Color
    
    var body: some View {
        ZStack {
            cardColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if let details = details {
                    AsyncImage(url: URL(string: details.sprites.frontDefault)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        default:
                            Image("loading")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding(.top, 90)
                    
                    Text(String(format: "#%03d", details.id))
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 20)
                    
                    Text(pokemon.name.capitalized)
                        .foregroundColor(.white)
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 6)
                        .padding(.bottom, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 420)
    }
}

struct PokemonContentView: View {
    let details: PokemonDados?
    let cardColor: Color
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: { selectedTab = "About" }) {
                    Text("About")
                        .font(.headline)
                        .foregroundColor(selectedTab == "About" ? cardColor : .gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                Button(action: { selectedTab = "Stats" }) {
                    Text("Stats")
                        .font(.headline)
                        .foregroundColor(selectedTab == "Stats" ? cardColor : .gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            
            ZStack {
                if selectedTab == "About" {
                    AboutView(details: details, cardColor: cardColor)
                } else {
                    StatsView(details: details, cardColor: cardColor)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 350)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .offset(y: -30)
    }
}

struct AboutView: View {
    let details: PokemonDados?
    let cardColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Pokédex Data")
                .font(.title2)
                .foregroundColor(cardColor)
                .bold()
                .padding(.top, 15)
            
            if let details = details {
                VStack(spacing: 25) {
                    HStack {
                        Text("Abilities")
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text(details.abilities.map { $0.ability.name.capitalized }.joined(separator: ", "))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Species")
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text(details.species.name.capitalized)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Type")
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text(details.types.map { $0.type.name.capitalized }.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Height")
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text("\(Double(details.height) / 10, specifier: "%.1f") m")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Weight")
                            .font(.headline)
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        Text("\(Double(details.weight) / 10, specifier: "%.1f") kg")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 40)
            }
            
            Spacer()
        }
    }
}

struct StatsView: View {
    let details: PokemonDados?
    let cardColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Base Stats")
                .font(.title2)
                .foregroundColor(cardColor)
                .bold()
                .padding(.top, 15)
            
            if let details = details {
                VStack(spacing: 14) {
                    ForEach(details.stats, id: \.stat.name) { stat in
                        StatRow(name: stat.stat.name.capitalized,
                                value: stat.baseStat,
                                barColor: cardColor)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 40)
            }
            
            Spacer()
        }
    }
}

struct StatRow: View {
    let name: String
    let value: Int
    let barColor: Color
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(barColor)
                        .frame(width: geo.size.width * CGFloat(value) / 255, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(value)")
                .font(.subheadline)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

#Preview {
    PokemonDetail(
        pokemon: PokemonUrl(
            name: "Bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1")
    )
}
