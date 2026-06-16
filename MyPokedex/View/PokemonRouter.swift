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

    @MainActor
    func makeView() -> some View {
        
        let repository = PokemonDataRepository()
        
        switch self {
        case .pokedexCellView(let pokemon):
            let viewModel = PokedexCellViewModel(pokemon: pokemon, repository: repository)
            return AnyView(PokedexCellView(viewModel: viewModel))
            
        case .pokedexDetailView(let pokemon):
            let viewModel = PokedexDetailViewModel(pokemon: pokemon, repository: repository)
            return AnyView(PokedexDetailView(viewModel: viewModel))
        }
    }
}
