//
//  MyPokedexTests.swift
//  MyPokedexTests
//
//  Created by Andres Perez Ramirez on 29/11/23.
//

import XCTest
@testable import MyPokedex

final class PokemonLoadingAPIServiceTests: XCTestCase {

    private var apiService: MockPokemonAPI!
    private var cache: MockPokemonCache!
    private var pokemonAPIService: PokemonAPIService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiService = MockPokemonAPI()
        cache = MockPokemonCache()
        pokemonAPIService = PokemonLoadingAPIService(cache: cache, apiService: apiService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiService = nil
        cache = nil
        pokemonAPIService = nil
    }

    func testFetchAPIResponseWithoutCache() throws {

        XCTAssertEqual(cache.countFetchAPICalls, 0)
        XCTAssertEqual(apiService.countFetchAPICalls, 0)

        let expectedArcanine: RowDetail = .make()
        let expectedGengar: RowDetail = .make(name: "Gengar")

        apiService.response = .init(next: "next",
                                    results: [ expectedArcanine, expectedGengar])

        let result = try awaitPublisher(pokemonAPIService.fetchAPIResponse(limit: "20", offset: "20"))
        let apiResponse = try result.get()

        XCTAssertEqual(cache.countFetchAPICalls, 1)
        XCTAssertEqual(apiService.countFetchAPICalls, 1)
        XCTAssertEqual(apiResponse.next, "next")
        XCTAssertEqual(apiResponse.results.count, 2)

        let arcanine: RowDetail? = apiResponse.results.first{ $0.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine, arcanine)

        let gengar: RowDetail? = apiResponse.results.first{ $0.name == "Gengar" }
        XCTAssertNotNil(gengar)
        XCTAssertEqual(expectedGengar, gengar)
    }

    func testFetchAPIResponseCache() throws {

        XCTAssertEqual(cache.countFetchAPICalls, 0)
        XCTAssertEqual(apiService.countFetchAPICalls, 0)

        let expectedArcanine: RowDetail = .make()
        let expectedGengar: RowDetail = .make(name: "Gengar")

        cache.response = .init(next: "next",
                               results: [ expectedArcanine, expectedGengar])

        let result = try awaitPublisher(pokemonAPIService.fetchAPIResponse(limit: "20", offset: "20"))
        let apiResponse = try result.get()

        XCTAssertEqual(cache.countFetchAPICalls, 1)
        XCTAssertEqual(apiService.countFetchAPICalls, 0)
        XCTAssertEqual(apiResponse.next, "next")
        XCTAssertEqual(apiResponse.results.count, 2)

        let arcanine: RowDetail? = apiResponse.results.first{ $0.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine, arcanine)

        let gengar: RowDetail? = apiResponse.results.first{ $0.name == "Gengar" }
        XCTAssertNotNil(gengar)
        XCTAssertEqual(expectedGengar, gengar)
    }

    func testFetchAPIResponseCacheFails() throws {

        XCTAssertEqual(cache.countFetchAPICalls, 0)
        XCTAssertEqual(apiService.countFetchAPICalls, 0)

        let expectedArcanine: RowDetail = .make()
        let expectedGengar: RowDetail = .make(name: "Gengar")

        cache.shouldFail = true
        apiService.response = .init(next: "next",
                                    results: [ expectedArcanine, expectedGengar])

        let result = try awaitPublisher(pokemonAPIService.fetchAPIResponse(limit: "20", offset: "20"))
        let apiResponse = try result.get()

        XCTAssertEqual(cache.countFetchAPICalls, 1)
        XCTAssertEqual(apiService.countFetchAPICalls, 1)
        XCTAssertEqual(apiResponse.next, "next")
        XCTAssertEqual(apiResponse.results.count, 2)

        let arcanine: RowDetail? = apiResponse.results.first{ $0.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine, arcanine)

        let gengar: RowDetail? = apiResponse.results.first{ $0.name == "Gengar" }
        XCTAssertNotNil(gengar)
        XCTAssertEqual(expectedGengar, gengar)
    }

    func testFetchPokemonWithoutCache() throws {

        XCTAssertEqual(cache.countFetchPokemonCalls, 0)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 0)

        let expectedPokemon: Pokemon = .make()
        apiService.pokemonResponse = expectedPokemon

        let result = try awaitPublisher(pokemonAPIService.fetchPokemon(name: ""))
        let pokemonResponse = try result.get()

        XCTAssertEqual(cache.countFetchPokemonCalls, 1)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 1)
        XCTAssertEqual(expectedPokemon, pokemonResponse)
    }

    func testFetchPokemonCache() throws {

        XCTAssertEqual(cache.countFetchPokemonCalls, 0)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 0)

        let expectedPokemon: Pokemon = .make()
        cache.pokemonResponse = expectedPokemon

        let result = try awaitPublisher(pokemonAPIService.fetchPokemon(name: ""))
        let pokemonResponse = try result.get()

        XCTAssertEqual(cache.countFetchPokemonCalls, 1)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 0)
        XCTAssertEqual(expectedPokemon, pokemonResponse)
    }

    func testFetchPokemonCacheFails() throws {

        XCTAssertEqual(cache.countFetchPokemonCalls, 0)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 0)

        let expectedPokemon: Pokemon = .make()
        cache.shouldFail = true
        apiService.pokemonResponse = expectedPokemon

        let result = try awaitPublisher(pokemonAPIService.fetchPokemon(name: ""))
        let pokemonResponse = try result.get()

        XCTAssertEqual(cache.countFetchPokemonCalls, 1)
        XCTAssertEqual(apiService.countFetchPokemonCalls, 1)
        XCTAssertEqual(expectedPokemon, pokemonResponse)
    }

    func testFetchAPITypeResponseWithoutCache() throws {

        XCTAssertEqual(cache.countFetchTypeCalls, 0)
        XCTAssertEqual(apiService.countFetchTypeCalls, 0)

        let expectedArcanine: APIPokemonType = .make()
        let expectedCharizard: APIPokemonType = .make(name: "Charizard")

        apiService.typeResponse = .init(id: 1,
                                        name: "fire",
                                        pokemonList: [expectedArcanine, expectedCharizard])

        let result = try awaitPublisher(pokemonAPIService.fetchAPITypeResponse(type: "fire"))
        let typeResponse = try result.get()

        XCTAssertEqual(cache.countFetchTypeCalls, 1)
        XCTAssertEqual(apiService.countFetchTypeCalls, 1)
        XCTAssertEqual(typeResponse.id, 1)
        XCTAssertEqual(typeResponse.name, "fire")
        XCTAssertEqual(typeResponse.pokemonList.count, 2)

        let arcanine: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine.pokemon, arcanine?.pokemon)

        let charizard: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Charizard" }
        XCTAssertNotNil(charizard)
        XCTAssertEqual(expectedCharizard.pokemon, charizard?.pokemon)
    }

    func testFetchAPITypeResponseCache() throws {

        XCTAssertEqual(cache.countFetchTypeCalls, 0)
        XCTAssertEqual(apiService.countFetchTypeCalls, 0)

        let expectedArcanine: APIPokemonType = .make()
        let expectedCharizard: APIPokemonType = .make(name: "Charizard")

        cache.typeResponse = .init(id: 1,
                                        name: "fire",
                                        pokemonList: [expectedArcanine, expectedCharizard])

        let result = try awaitPublisher(pokemonAPIService.fetchAPITypeResponse(type: "fire"))
        let typeResponse = try result.get()

        XCTAssertEqual(cache.countFetchTypeCalls, 1)
        XCTAssertEqual(apiService.countFetchTypeCalls, 0)
        XCTAssertEqual(typeResponse.id, 1)
        XCTAssertEqual(typeResponse.name, "fire")
        XCTAssertEqual(typeResponse.pokemonList.count, 2)

        let arcanine: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine.pokemon, arcanine?.pokemon)

        let charizard: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Charizard" }
        XCTAssertNotNil(charizard)
        XCTAssertEqual(expectedCharizard.pokemon, charizard?.pokemon)
    }

    func testFetchAPITypeResponseCacheFails() throws {

        XCTAssertEqual(cache.countFetchTypeCalls, 0)
        XCTAssertEqual(apiService.countFetchTypeCalls, 0)

        let expectedArcanine: APIPokemonType = .make()
        let expectedCharizard: APIPokemonType = .make(name: "Charizard")

        cache.shouldFail = true
        apiService.typeResponse = .init(id: 1,
                                        name: "fire",
                                        pokemonList: [expectedArcanine, expectedCharizard])

        let result = try awaitPublisher(pokemonAPIService.fetchAPITypeResponse(type: "fire"))
        let typeResponse = try result.get()

        XCTAssertEqual(cache.countFetchTypeCalls, 1)
        XCTAssertEqual(apiService.countFetchTypeCalls, 1)
        XCTAssertEqual(typeResponse.id, 1)
        XCTAssertEqual(typeResponse.name, "fire")
        XCTAssertEqual(typeResponse.pokemonList.count, 2)

        let arcanine: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Arcanine" }
        XCTAssertNotNil(arcanine)
        XCTAssertEqual(expectedArcanine.pokemon, arcanine?.pokemon)

        let charizard: APIPokemonType? = typeResponse.pokemonList.first{ $0.pokemon.name == "Charizard" }
        XCTAssertNotNil(charizard)
        XCTAssertEqual(expectedCharizard.pokemon, charizard?.pokemon)
    }
}
