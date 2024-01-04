//
//  Pokemon.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 23/11/23.
//

import Foundation

struct Pokemon: Decodable {
    let id: Int
    let name: String
    let sprites: Sprite
    let abilities: [Ability]
    let moves: [Move]
    let types: [Species]
}

extension Pokemon: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}


struct Sprite: Decodable {
    let url: String

    private enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
}
