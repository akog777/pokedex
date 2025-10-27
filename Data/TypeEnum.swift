import Foundation
import SwiftUI

enum TypeEnum: String, Codable {
    case fire, poison, water, electric, psychic, normal, ground, flying, fairy, grass, bug, steel, fighting, ice, rock, none
    case dragon, ghost
    
    var color: Color { switch self {
        case .fire: return .red
        case .poison: return .purple
        case .water: return .blue
        case .electric: return .yellow
        case .psychic: return .pink
        case .normal: return Color(white: 0.65)
        case .ground: return Color(red: 0.8, green: 0.7, blue: 0.5)
        case .flying: return Color(red: 0.6, green: 0.8, blue: 1.0)
        case .fairy: return Color(red: 0.95, green: 0.6, blue: 0.9)
        case .grass: return .green
        case .bug: return Color(red: 0.6, green: 0.9, blue: 0.2)
        case .steel: return Color(white: 0.75)
        case .fighting: return Color(red: 0.75, green: 0.2, blue: 0.1)
        case .ice: return .cyan
        case .rock: return Color(red: 0.7, green: 0.6, blue: 0.4)
        case .dragon: return Color(red: 0.4, green: 0.2, blue: 0.9)
        case .ghost: return Color(red: 0.4, green: 0.2, blue: 0.6)
        case .none: return .gray
        }
    }
}
