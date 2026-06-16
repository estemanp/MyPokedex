//
//  PokemonCache.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import Foundation

protocol PokemonCacheProtocol: Actor {
    func getAPIResponse(offset: String) -> APIResponse?
    func getPokemon(name: String) -> Pokemon?
    func getAPITypeResponse(type: String) -> APITypeResponse?
    
    func saveAPIResponse(offset: String, response: APIResponse)
    func savePokemon(pokemon: Pokemon)
    func saveAPITypeResponse(type: String, response: APITypeResponse)
}

actor PokemonCache: PokemonCacheProtocol {
    
    static let shared = PokemonCache()
    
    private var apiResponseCache: [String: APIResponse] = [:]
    private var pokemonCache: [String: Pokemon] = [:]
    private var apiTypeResponseCache: [String: APITypeResponse] = [:]
    
    private init() {}
    
    func getAPIResponse(offset: String) -> APIResponse? {
        return apiResponseCache[offset]
    }
    
    func getPokemon(name: String) -> Pokemon? {
        return pokemonCache[name]
    }
    
    func getAPITypeResponse(type: String) -> APITypeResponse? {
        return apiTypeResponseCache[type]
    }
    
    func saveAPIResponse(offset: String, response: APIResponse) {
        apiResponseCache[offset] = response
    }
    
    func savePokemon(pokemon: Pokemon) {
        pokemonCache[pokemon.name] = pokemon
    }
    
    func saveAPITypeResponse(type: String, response: APITypeResponse) {
        apiTypeResponseCache[type] = response
    }
}
