//
//  Model+Extension.swift
//  MyPokedexTests
//
//  Created by Andres Perez Ramirez on 29/11/23.
//

import Foundation
@testable import MyPokedex

extension RowDetail {
    static func make(name: String = "Arcanine",
                     url: String = "url") -> RowDetail {
        return .init(name: name,
                     url: url)
    }
}

extension Ability {
    static func make(name: String = "Blaze",
                     url: String = "urlBlaze") -> Ability {
        return .init(ability: .make(name: name,
                                    url: url))
    }
}

extension Move {
    static func make(name: String = "Cut",
                     url: String = "urlCut") -> Move {
        return .init(move: .make(name: name,
                                 url: url))
    }
}

extension Species {
    static func make(name: String = "Fire",
                     url: String = "urlFire") -> Species {
        return .init(type: .make(name: name,
                                url: url))
    }
}


extension Pokemon {
    static func make(id: Int = 1,
                     name: String = "Arcanine",
                     sprites: Sprite = Sprite(url: "urlSprite"),
                     abilities: [Ability] = [.make()],
                     moves: [Move] = [.make()],
                     types: [Species] = [.make()]) -> Pokemon {
        return .init(id: id,
                     name: name,
                     sprites: sprites,
                     abilities: abilities,
                     moves: moves,
                     types: types)
    }
}

extension APIPokemonType {
    static func make(name: String = "Arcanine",
                     url: String = "url") -> APIPokemonType {
        return .init(pokemon: .make(name: name,
                                    url: url))
    }
}
