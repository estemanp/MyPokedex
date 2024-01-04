//
//  PokedexDetailView.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//

import SwiftUI
import Kingfisher

struct PokedexDetailView<Model>: View where Model: PokedexDetailViewModelProtocol {
    @StateObject private var viewModel: Model


    init(viewModel: Model) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            let color = Color.pokemon(species: viewModel.pokemon?.types.first)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack {
                        pokemonName
                        Spacer()
                        if let url = URL(string: viewModel.pokemon?.sprites.url ?? "") {
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                        pokemonNumber
                        Spacer()
                        types
                    }
                    .frame(maxWidth: .infinity, minHeight:  250, maxHeight: 800)
                    .background(color)
                    .cornerRadius(24)
                    abilityLabel
                    abilities
                    moveLabel
                    moves
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray2))
                .cornerRadius(24)
            }
            .alert(LocalizableString.unexpectedErrorMessage.value, isPresented: $viewModel.showingUnexpectedErrorAlert) {
                Button(LocalizableString.continueButton.value, role: .cancel) { }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .cornerRadius(24)
        }.onAppear {
            viewModel.fetchPokemon()
        }
    }

    var pokemonName: some View {
        Text(viewModel.pokemon?.name.capitalized ?? "")
            .font(.headline)
            .foregroundColor(.white)
    }

    var pokemonNumber: some View {
        Text(viewModel.number)
            .fontWeight(.heavy)
            .foregroundColor(.white)
    }

    var types: some View {
        HStack(alignment: .center, spacing: 20) {
            ForEach(viewModel.species, id: \.self) { specie in
                TypeTag(type: specie.type, isCell: false)
             }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
    }

    var abilityLabel: some View {
        Text(viewModel.abilitiesLabel)
            .font(.subheadline).bold()
            .foregroundColor(.white)
            .padding(.leading, 10)
    }

    var abilities: some View {
        HStack(alignment: .center, spacing: 20) {
            ForEach(viewModel.abilities, id: \.self) { ability in
                Text("  - \(ability.ability.name.capitalized)")
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
             }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
    }

    var moveLabel: some View {
        Text(viewModel.movesLabel)
            .font(.subheadline).bold()
            .foregroundColor(.white)
            .padding(.leading, 10)
    }

    var moves: some View {
        LazyVGrid(columns:  [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.moves, id: \.self) { move in
                Text("  - \(move.move.name.capitalized)")
                    .frame(width: 120, height: 30, alignment: .leading).minimumScaleFactor(0.5)
                    .font(.body)
                    .foregroundColor(.white)
                    .lineLimit(1)
             }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
    }
}

struct PokedexDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexDetailView(viewModel: MockPokedexDetailViewModel(
            pokemon: .init(name: "", url: ""),
            pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                        apiService: PokemonAPI())))
          .previewLayout(.fixed(width: 400, height: 200))
    }
}
