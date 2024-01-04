//
//  PokedexViewModel.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import Combine
import Network

protocol PokedexViewModelProtocol: ObservableObject {
    var pokemonList: [RowDetail] { get set }
    var searchText: String { get set }
    var selectedType: String { get set }
    var showFilter: Bool { get set }
    var showUnexpectedErrorAlert: Bool { get set }
    var mainTitle: String { get }
    var mainDescription: String { get }
    init(pokemonAPIService: PokemonAPIService)
    func fetchPokemonsIfNeeded(index: Int)
    func fetchPokemons(isFilter: Bool)
    func fetchAPITypeResponse()
    
}


final class PokedexViewModel: PokedexViewModelProtocol {
    @Published var pokemonList: [RowDetail]
    @Published var searchText: String
    @Published var selectedType: String
    @Published var showFilter: Bool
    @Published var showUnexpectedErrorAlert: Bool
    private var subsriptions = Set<AnyCancellable>()
    private let pokemonAPIService: PokemonAPIService
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

    required init(pokemonAPIService: PokemonAPIService) {
        self.pokemonAPIService = pokemonAPIService
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

    func fetchPokemonsIfNeeded(index: Int) {
        guard selectedType == PokemonType.none.rawValue else { return }
        if shouldRequestMoreItems(index) && canRequestMoreItems() {
            fetchPokemons(isFilter: false)
        }
    }

    func fetchPokemons(isFilter: Bool) {
        pokemonAPIService
            .fetchAPIResponse(limit: String(limit), offset: String(offSet))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .failure(let error):
                    print("Failure error:", error.localizedDescription)
                    print("MY error: ", error)
                    self?.showUnexpectedErrorAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.showUnexpectedErrorAlert = false
                if isFilter {
                    self.pokemonList = response.results
                    self.offSet = limit
                } else {
                    self.pokemonList.append(contentsOf: response.results)
                    self.pokemonAPIService.saveAPIResponse(offSet: String(offSet), apiResponse: response)
                    self.offSet += self.limit
                }
            }
            .store(in: &subsriptions)
    }

    func fetchAPITypeResponse() {
        if selectedType == PokemonType.none.rawValue {
            fetchPokemons(isFilter: true)
        } else {
            pokemonAPIService
                .fetchAPITypeResponse(type: selectedType)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    switch value {
                    case .failure(let error):
                        self?.pokemonList = []
                        print("Failure error:", error.localizedDescription)
                        print("MY error: ", error)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.pokemonAPIService.SaveAPITypeResponse(type: selectedType, apyTypeResponse: response)
                    self.pokemonList = response.pokemonList.map{ $0.pokemon }
                    self.offSet = 0
                }
                .store(in: &subsriptions)
        }
    }

    private func shouldRequestMoreItems( _ index: Int) -> Bool {
        return (offSet - index) == itemsFromEndThreshold
    }

    private func canRequestMoreItems() -> Bool {
        return (offSet + limit) <= totalMaxItemsAvailable
    }
}
