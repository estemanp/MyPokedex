//
//  MockPokedexDetailViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation

final class MockPokedexDetailViewModel: MockPokedexCellViewModel, PokedexDetailViewModelProtocol {

    var abilities: [Ability] {
        return abilityList
    }

    var moves: [Move] {
        return moveList
    }

    var abilitiesLabel: String {
        return LocalizableString.abilitiesLabel.value
    }

    var movesLabel: String {
        return LocalizableString.movesLabel.value
    }
}
