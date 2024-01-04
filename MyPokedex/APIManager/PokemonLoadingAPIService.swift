//
//  PokemonLoadingAPIService.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation
import Combine

protocol PokemonAPIService {
    init(cache: PokemonCacheProtocol, apiService: PokemonFetchable)
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse, NetworkError>
    func fetchPokemon(name: String) -> AnyPublisher<Pokemon, NetworkError>
    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse, NetworkError>
    func saveAPIResponse(offSet: String, apiResponse: APIResponse)
    func savePokemon(pokemon: Pokemon)
    func SaveAPITypeResponse(type: String, apyTypeResponse: APITypeResponse)
}

struct PokemonLoadingAPIService: PokemonAPIService {

    private let cache: PokemonCacheProtocol
    private let apiService: PokemonFetchable

    init(cache: PokemonCacheProtocol, apiService: PokemonFetchable) {
        self.cache = cache
        self.apiService = apiService
    }

    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse, NetworkError> {
        return cache
            .fetchAPIResponse(limit: limit, offset: offset)
            .catch({ _ in
                Just(nil)
            })
            .flatMap({ (response: APIResponse?) -> AnyPublisher<APIResponse, NetworkError> in
                if let response = response {
                    return Just(response)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                }
                return self.apiService.fetchAPIResponse(limit: limit, offset: offset)
            })
            .eraseToAnyPublisher()
    }

    func fetchPokemon(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        return cache
            .fetchPokemon(name: name)
            .catch({ _ in
                Just(nil)
            })
            .flatMap({ (response: Pokemon?) -> AnyPublisher<Pokemon, NetworkError> in
                if let response = response {
                    return Just(response)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                }
                return self.apiService.fetchPokemon(name: name)
            })
            .eraseToAnyPublisher()
    }

    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse, NetworkError> {
        return cache
            .fetchAPITypeResponse(type: type)
            .catch({ _ in
                Just(nil)
            })
            .flatMap({ (response: APITypeResponse?) -> AnyPublisher<APITypeResponse, NetworkError> in
                if let response = response {
                    return Just(response)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                }
                return self.apiService.fetchAPITypeResponse(type: type)
            })
            .eraseToAnyPublisher()
    }

    func saveAPIResponse(offSet: String, apiResponse: APIResponse) {
        cache.saveAPIResponse(offSet: offSet, apiResponse: apiResponse)
    }

    func savePokemon(pokemon: Pokemon) {
        cache.savePokemon(pokemon: pokemon)
    }

    func SaveAPITypeResponse(type: String, apyTypeResponse: APITypeResponse) {
        cache.SaveAPITypeResponse(type: type, apyTypeResponse: apyTypeResponse)
    }
}
