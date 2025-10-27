import SwiftUI

struct PokemonCards: View {
    let pokemon: PokemonUrl
    @State private var details: PokemonDados?
    @State private var spriteUrl: String?
    
    var cardColor: Color {
        guard let details = details,
              let firstType = details.types.first?.type.name,
              let typeEnum = TypeEnum(rawValue: firstType) else {
            return .red
        }
        return typeEnum.color.opacity(0.7)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(cardColor)
                .cornerRadius(20)
                .frame(width: 350, height: 120)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    if let details = details {
                        Text(String(format: "#%03d", details.id))
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    Text(pokemon.name.capitalized)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    
                    if let details = details,
                       let first = details.types.first?.type.name {
                        Text(first.capitalized)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.leading, 45)
                
                Spacer()
                
                if let spriteUrl,
                   let url = URL(string: spriteUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.trailing, 30)

                        default:
                            Image("loading")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .padding(.trailing, 60)
                        }
                    }
                } else {
                    Image("loading")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(.trailing, 60)
                }
            }
        }
        .task {
            do {
                let detail = try await getPokemonDados(from: pokemon.url)
                self.details = detail
                self.spriteUrl = detail.sprites.frontDefault
            } catch {
                print("Erro ao carregar detalhes")
            }
        }
    }
}

#Preview {
    PokemonCards(
        pokemon: PokemonUrl(
            name: "pikachu",
            url: "https:asdpokeapi.co/api/v2/pokemon/25"
        )
    )
}
