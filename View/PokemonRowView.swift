import SwiftUI

// Este é o card colorido que aparece na lista principal
struct PokemonRowView: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        HStack {
            // Informações (ID, Nome, Tipos)
            VStack(alignment: .leading, spacing: 5) {
                Text(String(format: "#%03d", pokemon.id))
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(pokemon.name.capitalized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Tags de Tipo
                HStack {
                    ForEach(pokemon.types, id: \.slot) { typeEntry in
                        Text(typeEntry.type.name.capitalized)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
            
            Spacer()
            
            // Imagem do Pokémon (Usando AsyncImage nativo do SwiftUI)
            AsyncImage(url: URL(string: pokemon.sprites.officialArtwork)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } placeholder: {
                // Coloca a pokebola como placeholder
                Image("pokebola")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .opacity(0.3)
                    .padding()
            }
        }
        .padding(16)
        .background(pokemon.primaryTypeColor) // Cor de fundo dinâmica
        .cornerRadius(20)
        .shadow(color: pokemon.primaryTypeColor.opacity(0.4), radius: 8, y: 4)
    }
}