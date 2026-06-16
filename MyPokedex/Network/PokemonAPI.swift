//
//  PokemonAPI.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation

protocol PokemonFetchable {
    func fetchAPIResponse(limit: String, offset: String) async throws -> APIResponse
    func fetchPokemon(name: String) async throws -> Pokemon
    func fetchAPITypeResponse(type: String) async throws -> APITypeResponse
}

class PokemonAPI: PokemonFetchable, Fetchable {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAPIResponse(limit: String, offset: String) async throws -> APIResponse {
        let components = urlComponentForAPIResponse(limit: limit, offset: offset)
        return try await fetch(with: components, session: session)
    }
    
    func fetchPokemon(name: String) async throws -> Pokemon {
        let components = urlComponentForPokemonResponse(name: name)
        return try await fetch(with: components, session: session)
    }
    
    func fetchAPITypeResponse(type: String) async throws -> APITypeResponse {
        let components = urlComponentForAPITypeResponse(type: type)
        return try await fetch(with: components, session: session)
    }
}

// MARK: - URL Components Private Extension
private extension PokemonAPI {
    struct PokemonAPIComponent {
        static let scheme = "https"
        static let host = "pokeapi.co"
        static let path = "/api/v2/pokemon/"
        static let pokemonTypePath = "/api/v2/type/"
    }

    func urlComponentForAPIResponse(limit: String, offset: String) -> URLComponents {
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

    func urlComponentForPokemonResponse(name: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PokemonAPIComponent.scheme
        components.host = PokemonAPIComponent.host
        components.path = PokemonAPIComponent.path + name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return components
    }

    func urlComponentForAPITypeResponse(type: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PokemonAPIComponent.scheme
        components.host = PokemonAPIComponent.host
        components.path = PokemonAPIComponent.pokemonTypePath + type.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return components
    }
}
