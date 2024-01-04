//
//  Species.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import Foundation

struct Species: Decodable {
    let type: RowDetail
}

extension Species: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(type.name)
    }

    static func == (lhs: Species, rhs: Species) -> Bool {
        lhs.type.name == rhs.type.name
    }
}
