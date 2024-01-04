//
//  APIError.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation

enum NetworkError: Error {
    case network(message: String)
    case other(message: String)
    case parsing(message: String)
    case request(message: String)
    case status(message: String)

    static func map(_ error: Error) -> NetworkError {
        return (error as? NetworkError) ?? .other(message: error.localizedDescription)
    }
}
