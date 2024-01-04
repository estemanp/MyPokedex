//
//  MockPokemonAPI.swift
//  MyPokedexTests
//
//  Created by Andres Perez Ramirez on 29/11/23.
//

import Combine
@testable import MyPokedex

final class MockPokemonAPI {


    var countFetchAPICalls: Int = 0
    var countFetchPokemonCalls: Int = 0
    var countFetchTypeCalls: Int = 0

    var response: APIResponse?
    var pokemonResponse: Pokemon?
    var typeResponse: APITypeResponse?

    var shouldFail: Bool = false

    init() {
    }
}

extension MockPokemonAPI: PokemonFetchable {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse, MyPokedex.NetworkError> {
        Deferred {
            Future<APIResponse, NetworkError> { future in
                self.countFetchAPICalls += 1

                guard let response = self.response else {
                    future(.failure(NetworkError.parsing(message: "response is nil")))
                    return
                }

                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(response))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchPokemon(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        Deferred {
            Future<Pokemon, NetworkError> { future in
                self.countFetchPokemonCalls += 1

                guard let pokemonResponse = self.pokemonResponse else {
                    future(.failure(NetworkError.parsing(message: "response is nil")))
                    return
                }

                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(pokemonResponse))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse, NetworkError> {
        Deferred {
            Future<APITypeResponse, NetworkError> { future in

                self.countFetchTypeCalls += 1

                guard let typeResponse = self.typeResponse else {
                    future(.failure(NetworkError.parsing(message: "response is nil")))
                    return
                }

                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(typeResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
}
