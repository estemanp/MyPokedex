//
//  Fetchable.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation

protocol Fetchable {
    func fetch<T: Decodable>(with urlComponent: URLComponents, session: URLSession) async throws -> T
}

extension Fetchable {
    func fetch<T: Decodable>(with urlComponent: URLComponents, session: URLSession = .shared) async throws -> T {
        guard let url = urlComponent.url else {
            throw NetworkError.request(message: "Opss invalid URL")
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.status(message: "Invalid response from server")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.parsing(message: error.localizedDescription)
        }
    }
}
