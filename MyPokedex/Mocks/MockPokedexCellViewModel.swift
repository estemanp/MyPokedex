//
//  MockPokedexCellViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 25/11/23.
//

import Foundation

class MockPokedexCellViewModel: PokedexCellViewModelProtocol {
    @Published var pokemon: Pokemon?
    @Published var showingUnexpectedErrorAlert: Bool

    private var types: [Species] = [
        .init(type: .init(name: "grass", url: "https://pokeapi.co/api/v2/type/12/")),
        .init(type: .init(name: "poison", url: "https://pokeapi.co/api/v2/type/4/"))
    ]

    var abilityList: [Ability] = [.init(ability: .init(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/"))]
    var moveList: [Move] = [.init(move: .init(name: "petal-dance", url: "https://pokeapi.co/api/v2/move/80/"))]

    var number: String {
        return "#001"
    }

    var species: [Species] {
        return types
    }

    required init(pokemon: RowDetail, pokemonAPIService: PokemonAPIService) {
        self.pokemon = .init(
            id: 1,
            name: "bulbasaur",
            sprites: .init(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            abilities: abilityList,
            moves: moveList,
            types: types
        )
        self.showingUnexpectedErrorAlert = false
    }

    func fetchPokemon() {}
}
