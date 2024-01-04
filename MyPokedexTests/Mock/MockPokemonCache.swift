//
//  MockPokemonCache.swift
//  MyPokedexTests
//
//  Created by Andres Perez Ramirez on 29/11/23.
//

import Combine
@testable import MyPokedex

final class MockPokemonCache {


    var countFetchAPICalls: Int = 0
    var countFetchPokemonCalls: Int = 0
    var countFetchTypeCalls: Int = 0
    var countSaveAPICalls: Int = 0
    var countSavePokemonCalls: Int = 0
    var countSaveTypeCalls: Int = 0

    var response: APIResponse?
    var pokemonResponse: Pokemon?
    var typeResponse: APITypeResponse?

    var shouldFail: Bool = false

    init() {
    }
}

extension MockPokemonCache: PokemonCacheProtocol {
    func fetchAPIResponse(limit: String, offset: String) -> AnyPublisher<APIResponse?, NetworkError> {
        Deferred {
            Future<APIResponse?, NetworkError> { future in
                self.countFetchAPICalls += 1
                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(self.response))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchPokemon(name: String) -> AnyPublisher<Pokemon?, NetworkError> {
        Deferred {
            Future<Pokemon?, NetworkError> { future in
                self.countFetchPokemonCalls += 1
                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(self.pokemonResponse))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchAPITypeResponse(type: String) -> AnyPublisher<APITypeResponse?, NetworkError> {
        Deferred {
            Future<APITypeResponse?, NetworkError> { future in
                self.countFetchTypeCalls += 1
                if self.shouldFail {
                    future(.failure(NetworkError.parsing(message: "Forced Error")))
                } else {
                    future(.success(self.typeResponse))
                }
            }
        }.eraseToAnyPublisher()
    }

    func saveAPIResponse(offSet: String, apiResponse: APIResponse) {
        self.countSaveAPICalls += 1
    }

    func savePokemon(pokemon: Pokemon) {
        self.countSavePokemonCalls += 1
    }

    func SaveAPITypeResponse(type: String, apyTypeResponse: APITypeResponse) {
        self.countSaveTypeCalls += 1
    }
}
