//
//  PokedexCellViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import Combine

protocol PokedexCellViewModelProtocol: ObservableObject {
    var pokemon: Pokemon? { get set }
    var showingUnexpectedErrorAlert: Bool { get set }
    var number: String { get }
    var species: [Species] { get }
    init(pokemon: RowDetail, pokemonAPIService: PokemonAPIService)
    func fetchPokemon()
}

class PokedexCellViewModel: PokedexCellViewModelProtocol {
    @Published var pokemon: Pokemon?
    @Published var showingUnexpectedErrorAlert: Bool
    private var namePokemon: String
    private var subsriptions = Set<AnyCancellable>()
    private let pokemonAPIService: PokemonAPIService


    var number: String {
        guard let id = pokemon?.id else { return "" }
        return "#\(String(format: "%03d", id))"
    }

    var species: [Species] {
        guard let species = pokemon?.types else { return [] }
        return species
    }

    required init(pokemon: RowDetail, pokemonAPIService: PokemonAPIService) {
        self.namePokemon = pokemon.name
        self.pokemonAPIService = pokemonAPIService
        self.showingUnexpectedErrorAlert = false
    }

    func fetchPokemon() {
        pokemonAPIService
            .fetchPokemon(name: namePokemon)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] value in
                switch value {
                case .failure(let error):
                    print("Failure error:", error.localizedDescription)
                    print("MY error: ", error)
                    self?.showingUnexpectedErrorAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] pokemon in
                guard let self = self else { return }
                self.showingUnexpectedErrorAlert = false

                self.pokemonAPIService.savePokemon(pokemon: pokemon)
                self.pokemon = pokemon
            }
            .store(in: &subsriptions)
    }
}
