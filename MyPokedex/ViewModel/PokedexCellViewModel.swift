//
//  PokedexCellViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation

@MainActor
protocol PokedexCellViewModelProtocol: ObservableObject {
    var pokemon: Pokemon? { get set }
    var showingUnexpectedErrorAlert: Bool { get set }
    var number: String { get }
    var species: [Species] { get }
    
    init(pokemon: RowDetail, repository: PokemonRepositoryProtocol)
    func fetchPokemon()
}

@MainActor
class PokedexCellViewModel: PokedexCellViewModelProtocol {
    
    @Published var pokemon: Pokemon?
    @Published var showingUnexpectedErrorAlert: Bool = false
    
    private var namePokemon: String
    
    private let repository: PokemonRepositoryProtocol

    var number: String {
        guard let id = pokemon?.id else { return "" }
        return "#\(String(format: "%03d", id))"
    }

    var species: [Species] {
        return pokemon?.types ?? []
    }

    required init(pokemon: RowDetail, repository: PokemonRepositoryProtocol) {
        self.namePokemon = pokemon.name
        self.repository = repository
    }

    func fetchPokemon() {
        Task {
            do {
                let fetchedPokemon = try await repository.fetchPokemon(name: namePokemon)
                self.pokemon = fetchedPokemon
                self.showingUnexpectedErrorAlert = false
            } catch {
                print("Failure error: \(error.localizedDescription)")
                self.showingUnexpectedErrorAlert = true
            }
        }
    }
}
