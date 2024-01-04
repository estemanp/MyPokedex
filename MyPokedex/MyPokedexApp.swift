//
//  MyPokedexApp.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 23/11/23.
//

import SwiftUI

@main
struct MyPokedexApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    private let viewModel = PokedexViewModel(pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                                                         apiService: PokemonAPI()))
    var body: some Scene {
        WindowGroup {
            PokedexView(viewModel: viewModel)
                .environmentObject(networkMonitor)
        }
    }
}
