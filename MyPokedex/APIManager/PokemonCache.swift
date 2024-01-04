//
//  PokemonCache.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation
import Combine

protocol PokemonCacheProtocol {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse?, NetworkError>
    func fetchPokemon(name: String) -> AnyPublisher<Pokemon?, NetworkError>
    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse?, NetworkError>
    func saveAPIResponse(offSet: String, apiResponse: APIResponse)
    func savePokemon(pokemon: Pokemon)
    func SaveAPITypeResponse(type: String, apyTypeResponse: APITypeResponse)
}

final class PokemonCache {

    static let shared = PokemonCache()
    private var apiResponseCache: [String : APIResponse]
    private var pokemonCache: [String : Pokemon]
    private var apiTypeResponseCache: [String : APITypeResponse]

    private init() {
        apiResponseCache = [String: APIResponse]()
        pokemonCache = [String : Pokemon]()
        apiTypeResponseCache = [String : APITypeResponse]()
    }
}

extension PokemonCache: PokemonCacheProtocol {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse?, NetworkError> {
        return Just(apiResponseCache[offset])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func fetchPokemon(name: String) -> AnyPublisher<Pokemon?, NetworkError> {
        return Just(pokemonCache[name])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse?, NetworkError> {
        return Just(apiTypeResponseCache[type])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }

    func saveAPIResponse(offSet: String, apiResponse: APIResponse) {
        self.apiResponseCache[offSet] = apiResponse
    }

    func savePokemon(pokemon: Pokemon) {
        self.pokemonCache[pokemon.name] = pokemon
    }

    func SaveAPITypeResponse(type: String, apyTypeResponse: APITypeResponse) {
        self.apiTypeResponseCache[type] = apyTypeResponse
    }
}
