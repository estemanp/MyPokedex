//
//  Ability.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import Foundation

struct Ability: Decodable {
    let ability: RowDetail
}

extension Ability: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(ability.name)
    }

    static func == (lhs: Ability, rhs: Ability) -> Bool {
        lhs.ability.name == rhs.ability.name
    }
}
