//
//  PokedexViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import Network

@MainActor
protocol PokedexViewModelProtocol: ObservableObject {
    var pokemonList: [RowDetail] { get set }
    var searchText: String { get set }
    var selectedType: String { get set }
    var showFilter: Bool { get set }
    var showUnexpectedErrorAlert: Bool { get set }
    var mainTitle: String { get }
    var mainDescription: String { get }
    
    init(repository: PokemonRepositoryProtocol)
    
    func onAppearSetup()
    func fetchPokemonsIfNeeded(index: Int)
    func fetchPokemons(isFilter: Bool)
    func fetchAPITypeResponse()
    func searchPokemon()
}

@MainActor
final class PokedexViewModel: PokedexViewModelProtocol {
    @Published var pokemonList: [RowDetail]
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                resetAndFetchList()
            } else {
                self.pokemonList = fullPokemonDirectory.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }
    
    @Published var selectedType: String
    @Published var showFilter: Bool
    @Published var showUnexpectedErrorAlert: Bool
        
    private var fullPokemonDirectory: [RowDetail] = []
    
    private let repository: PokemonRepositoryProtocol
    
    private let limit: Int
    private let totalMaxItemsAvailable: Int
    private let itemsFromEndThreshold: Int
    private var offSet: Int

    var mainTitle: String {
        return LocalizableString.mainTitle.value
    }

    var mainDescription: String {
        return LocalizableString.mainDescription.value
    }

    required init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
        self.pokemonList = [RowDetail]()
        self.searchText = ""
        self.selectedType = PokemonType.none.rawValue
        self.showFilter = false
        self.showUnexpectedErrorAlert = false
        self.limit = 20
        self.offSet = 0
        self.itemsFromEndThreshold = 4
        self.totalMaxItemsAvailable = 1020
    }
    
    func onAppearSetup() {
        fetchPokemons(isFilter: false)
        
        Task {
            do {
                let response = try await repository.fetchAPIResponse(limit: "2000", offset: "0")
                self.fullPokemonDirectory = response.results
            } catch {
                print("Directory download error: \(error)")
            }
        }
    }

    func fetchPokemonsIfNeeded(index: Int) {
        guard selectedType == PokemonType.none.rawValue, searchText.isEmpty else { return }
        
        if shouldRequestMoreItems(index) && canRequestMoreItems() {
            fetchPokemons(isFilter: false)
        }
    }

    func fetchPokemons(isFilter: Bool) {
        Task {
            do {
                let response = try await repository.fetchAPIResponse(limit: String(limit), offset: String(offSet))
                
                self.showUnexpectedErrorAlert = false
                
                if isFilter {
                    self.pokemonList = response.results
                    self.offSet = limit
                } else {
                    self.pokemonList.append(contentsOf: response.results)
                    self.offSet += self.limit
                }
            } catch {
                print("Failure error: \(error.localizedDescription)")
                self.showUnexpectedErrorAlert = true
            }
        }
    }

    func fetchAPITypeResponse() {
        if selectedType == PokemonType.none.rawValue {
            fetchPokemons(isFilter: true)
        } else {
            Task {
                do {
                    let response = try await repository.fetchAPITypeResponse(type: selectedType)
                    self.pokemonList = response.pokemonList.map { $0.pokemon }
                    self.offSet = 0
                } catch {
                    self.pokemonList = []
                    print("Failure error: \(error.localizedDescription)")
                }
            }
        }
    }
        
    func searchPokemon() {
        guard !searchText.isEmpty else { return }
        
        Task {
            do {
                let result = try await repository.fetchPokemon(name: searchText)
                
                let searchedPokemon = RowDetail(name: result.name, url: "https://pokeapi.co/api/v2/pokemon/\(result.id)/")
                
                self.pokemonList = [searchedPokemon]
                self.showUnexpectedErrorAlert = false
            } catch {
                print("Pokemon no encontrado: \(searchText)")
                self.pokemonList = []
            }
        }
    }
    
    private func resetAndFetchList() {
        self.offSet = 0
        self.pokemonList.removeAll()
        fetchPokemons(isFilter: true)
    }

    private func shouldRequestMoreItems( _ index: Int) -> Bool {
        return (offSet - index) == itemsFromEndThreshold
    }

    private func canRequestMoreItems() -> Bool {
        return (offSet + limit) <= totalMaxItemsAvailable
    }
}
