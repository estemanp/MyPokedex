//
//  PokemonRouter.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import Foundation
import SwiftUI

enum PokemonRouter {
    case pokedexCellView(pokemon: RowDetail)
    case pokedexDetailView(pokemon: RowDetail)

    func makeView() -> some View {
        switch self {
        case .pokedexCellView(let pokemon):
            let viewModel = PokedexCellViewModel(pokemon: pokemon,
                                                 pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                                                             apiService: PokemonAPI()))
            let view = PokedexCellView(viewModel: viewModel)
            return AnyView(view)
        case .pokedexDetailView(let pokemon):
            let viewModel = PokedexDetailViewModel(pokemon: pokemon,
                                                   pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                                                               apiService: PokemonAPI()))
            let view = PokedexDetailView(viewModel: viewModel)
            return AnyView(view)
        }
    }
}
