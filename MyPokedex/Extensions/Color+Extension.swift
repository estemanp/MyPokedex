//
//  Color+Extension.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {

    static func pokemon(species: Species?) -> Color {
        guard let species = species, let pokemonType = PokemonType(rawValue: species.type.name) else {
            return  Color(.systemIndigo)
        }
        switch pokemonType {
        case .bug: return Color(.systemGreen)
        case .dark: return Color(.systemGray)
        case .dragon: return Color(.systemIndigo)
        case .electric: return Color(.systemYellow)
        case .fairy: return Color(.systemPink)
        case .fighting: return Color(.systemCyan)
        case .flying: return Color(.systemTeal)
        case .fire: return Color(hex: "#FE9740") ?? Color(.systemRed)
        case .ghost: return Color(.systemPurple)
        case .grass: return Color(hex: "#38BF4B") ?? Color(.systemGreen)
        case .ground: return Color(.systemGray3)
        case .ice: return Color(.systemCyan)
        case .normal: return Color(.systemOrange)
        case .poison: return Color(.systemBrown)
        case .psychic: return Color(.systemMint)
        case .rock: return Color(.systemGray5)
        case .steel: return Color(.systemGray6)
        case .water: return Color(hex: "#3792DC") ?? Color(.systemBlue)
        default: return  Color(.systemIndigo)
        }
    }
}
