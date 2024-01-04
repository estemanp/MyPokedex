//
//  Move.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import Foundation

struct Move: Decodable {
    let move: RowDetail
}

extension Move: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(move.name)
    }

    static func == (lhs: Move, rhs: Move) -> Bool {
        lhs.move.name == rhs.move.name
    }
}
