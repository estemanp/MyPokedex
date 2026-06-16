//
//  PokemonDataRepository.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation

protocol PokemonRepositoryProtocol {
    func fetchAPIResponse(limit: String, offset: String) async throws -> APIResponse
    func fetchPokemon(name: String) async throws -> Pokemon
    func fetchAPITypeResponse(type: String) async throws -> APITypeResponse
}

struct PokemonDataRepository: PokemonRepositoryProtocol {
    
    private let cache: PokemonCacheProtocol
    private let apiService: PokemonFetchable
    
    init(cache: PokemonCacheProtocol = PokemonCache.shared, apiService: PokemonFetchable = PokemonAPI()) {
        self.cache = cache
        self.apiService = apiService
    }
    
    func fetchAPIResponse(limit: String, offset: String) async throws -> APIResponse {
        if let cachedResponse = await cache.getAPIResponse(offset: offset) {
            return cachedResponse
        }
        let networkResponse = try await apiService.fetchAPIResponse(limit: limit, offset: offset)
        await cache.saveAPIResponse(offset: offset, response: networkResponse)
        return networkResponse
    }
    
    func fetchPokemon(name: String) async throws -> Pokemon {
        if let cachedPokemon = await cache.getPokemon(name: name) {
            return cachedPokemon
        }
        let networkPokemon = try await apiService.fetchPokemon(name: name)
        await cache.savePokemon(pokemon: networkPokemon)
        return networkPokemon
    }
    
    func fetchAPITypeResponse(type: String) async throws -> APITypeResponse {
        if let cachedType = await cache.getAPITypeResponse(type: type) {
            return cachedType
        }
        let networkType = try await apiService.fetchAPITypeResponse(type: type)
        await cache.saveAPITypeResponse(type: type, response: networkType)
        return networkType
    }
}
