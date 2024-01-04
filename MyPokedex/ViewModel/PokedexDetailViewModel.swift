//
//  PokedexDetailViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import Foundation
import Combine

protocol PokedexDetailViewModelProtocol: PokedexCellViewModelProtocol {
    var abilities: [Ability] { get }
    var moves: [Move] { get }
    var abilitiesLabel: String { get }
    var movesLabel: String { get }
}

final class PokedexDetailViewModel: PokedexCellViewModel, PokedexDetailViewModelProtocol {

    var abilities: [Ability] {
        guard let abilities = pokemon?.abilities else { return [] }
        return abilities
    }

    var moves: [Move] {
        guard let moves = pokemon?.moves else { return [] }
        return moves
    }

    var abilitiesLabel: String {
        return LocalizableString.abilitiesLabel.value
    }

    var movesLabel: String {
        return LocalizableString.movesLabel.value
    }
}
