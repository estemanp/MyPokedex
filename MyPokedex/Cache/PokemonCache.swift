//
//  PokemonCache.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation

protocol PokemonCacheProtocol: Actor {
    func getAPIResponse(limit: String, offset: String) -> APIResponse?
    func getPokemon(name: String) -> Pokemon?
    func getAPITypeResponse(type: String) -> APITypeResponse?
    
    func saveAPIResponse(limit: String, offset: String, response: APIResponse)
    func savePokemon(pokemon: Pokemon)
    func saveAPITypeResponse(type: String, response: APITypeResponse)
}

actor PokemonCache: PokemonCacheProtocol {
    
    static let shared = PokemonCache()
    
    private var apiResponseCache: [String: APIResponse] = [:]
    private var pokemonCache: [String: Pokemon] = [:]
    private var apiTypeResponseCache: [String: APITypeResponse] = [:]
    
    private init() {}
    
    func getAPIResponse(limit: String, offset: String) -> APIResponse? {
        let key = "\(limit)-\(offset)"
        return apiResponseCache[key]
    }
    
    func getPokemon(name: String) -> Pokemon? {
        return pokemonCache[name]
    }
    
    func getAPITypeResponse(type: String) -> APITypeResponse? {
        return apiTypeResponseCache[type]
    }
    
    func saveAPIResponse(limit: String, offset: String, response: APIResponse) {
        let key = "\(limit)-\(offset)"
        apiResponseCache[key] = response
    }
    
    func savePokemon(pokemon: Pokemon) {
        pokemonCache[pokemon.name] = pokemon
    }
    
    func saveAPITypeResponse(type: String, response: APITypeResponse) {
        apiTypeResponseCache[type] = response
    }
}
