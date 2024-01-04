//
//  PokemonAPI.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import Combine

protocol PokemonFetchable {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse, NetworkError>
    func fetchPokemon(name: String) -> AnyPublisher<Pokemon, NetworkError>
    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse, NetworkError>
}

class PokemonAPI {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
}

private extension PokemonAPI {
    struct PokemonAPIComponent {
        static let scheme = "https"
        static let host = "pokeapi.co"
        static let path = "/api/v2/pokemon/"
        static let pokemonTypePath = "/api/v2/type/"
    }

    private func urlComponentForAPIResponse(limit: String, offset: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PokemonAPIComponent.scheme
        components.host = PokemonAPIComponent.host
        components.path = PokemonAPIComponent.path
        components.queryItems = [
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: offset)
        ]

        return components
    }

    private func urlComponentForPokemonResponse(name: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PokemonAPIComponent.scheme
        components.host = PokemonAPIComponent.host
        components.path = PokemonAPIComponent.path + name
        return components
    }

    private func urlComponentForAPITypeResponse(type: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PokemonAPIComponent.scheme
        components.host = PokemonAPIComponent.host
        components.path = PokemonAPIComponent.pokemonTypePath + type
        return components
    }
}


extension PokemonAPI: PokemonFetchable, Fetchable {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse, NetworkError> {
        return fetch(with: self.urlComponentForAPIResponse(limit: limit, offset: offset), session: self.session)
    }

    func fetchPokemon(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        return fetch(with: self.urlComponentForPokemonResponse(name: name), session: self.session)
    }

    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse, NetworkError> {
        return fetch(with: self.urlComponentForAPITypeResponse(type: type), session: self.session)
    }
}
