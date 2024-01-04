//
//  PokedexCellView.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 23/11/23.
//

import SwiftUI
import Kingfisher

struct PokedexCellView<Model>: View where Model: PokedexCellViewModelProtocol {
    @StateObject private var viewModel: Model


    init(viewModel: Model) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            let color = Color.pokemon(species: viewModel.pokemon?.types.first)
            ZStack(alignment: .bottomTrailing) {
                pokeballBackground
                VStack {
                    title
                    data
                }
            }
            .frame(minWidth: 176, maxWidth: 280, minHeight: 110, maxHeight: 140)
            .background(color)
            .cornerRadius(24)
            .animation(.default)

        }.onAppear {
            viewModel.fetchPokemon()
        }
    }

    var pokeballBackground: some View {
        Image("BasePokeball")
            .resizable()
            .frame(width: 80, height: 80)
            .opacity(0.1)
    }

    var pokemonName: some View {
        Text(viewModel.pokemon?.name.capitalized ?? "")
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white)
    }

    var pokemonNumber: some View {

        Text(viewModel.number)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white)
    }

    var title: some View {
        HStack {
            pokemonName
            Spacer()
            pokemonNumber
        }
        .padding(.top, 16)
        .padding(.horizontal, 8)
    }

    var data: some View {
        HStack {
            types
            Spacer()
            if let url = URL(string: viewModel.pokemon?.sprites.url ?? "") {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
        }
    }

    var types: some View {
        VStack(alignment: .leading, spacing: 2) {
            Spacer()
            ForEach(viewModel.species, id: \.self) { specie in
                TypeTag(type: specie.type, isCell: true)
             }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
    }
}

struct PokedexCellView_Previews: PreviewProvider {

    static var previews: some View {
        PokedexCellView(viewModel: MockPokedexCellViewModel(
            pokemon: .init(name: "", url: ""),
            pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                        apiService: PokemonAPI())))
        .previewLayout(.fixed(width: 400, height: 200))
    }
}
