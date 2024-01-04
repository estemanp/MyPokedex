//
//  APIResponse.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 26/11/23.
//

import Foundation

struct APIResponse: Decodable {
    let next: String
    let results: [RowDetail]
}

struct APITypeResponse: Decodable {
    let id: Int
    let name: String
    let pokemonList: [APIPokemonType]

    private enum CodingKeys: String, CodingKey {
        case id, name
        case pokemonList = "pokemon"
    }
}

struct APIPokemonType: Decodable {
    let pokemon: RowDetail
}
