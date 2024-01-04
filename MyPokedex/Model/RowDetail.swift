//
//  RowDetail.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 26/11/23.
//

import Foundation

struct RowDetail: Decodable {
    let name: String
    let url: String
}

extension RowDetail: Hashable, Equatable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: RowDetail, rhs: RowDetail) -> Bool {
        lhs.name == rhs.name
    }
}
