//
//  MockPokedexViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 25/11/23.
//

import Foundation

final class MockPokedexViewModel: PokedexViewModelProtocol {
    @Published var pokemonList: [RowDetail]
    @Published var searchText: String
    @Published var selectedType: String
    @Published var showFilter: Bool
    @Published var showUnexpectedErrorAlert: Bool

    var mainTitle: String {
        return LocalizableString.mainTitle.value
    }

    var mainDescription: String {
        return LocalizableString.mainDescription.value
    }

    required init(pokemonAPIService: PokemonAPIService) {
        self.searchText = ""
        self.selectedType = ""
        self.showFilter = false
        self.showUnexpectedErrorAlert = false
        self.pokemonList = [.init(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                            .init(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                            .init(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
                            .init(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
                            .init(name: "charmeleon", url: "https://pokeapi.co/api/v2/pokemon/5/"),
                            .init(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/"),
                            .init(name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/")]
    }

    func fetchPokemonsIfNeeded(index: Int) {
    }

    func fetchPokemons(isFilter: Bool) {
    }

    func fetchAPITypeResponse() {
    }
}
