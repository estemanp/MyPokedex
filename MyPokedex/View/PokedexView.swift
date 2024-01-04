//
//  PokedexView.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 24/11/23.
//
import SwiftUI

struct PokedexView<Model>: View where Model: PokedexViewModelProtocol {
    @StateObject private var viewModel: Model
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showNetworkAlert = false

    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    init (viewModel: Model) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack{
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    mainDescription
                    ScrollView {
                        LazyVGrid(columns: gridItems, spacing: 16) {
                            ForEach(Array(filteredPokemon.enumerated()), id: \.element) { index, pokemon in
                                NavigationLink(destination: PokemonRouter.pokedexDetailView(pokemon: pokemon).makeView()) {
                                    PokemonRouter.pokedexCellView(pokemon: pokemon).makeView()
                                        .frame(minWidth: 176, maxWidth: 280, minHeight: 110, maxHeight: 140)
                                }.onAppear { viewModel.fetchPokemonsIfNeeded(index: index) }
                            }
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .padding(.horizontal, 20)
                VStack{
                    Spacer()
                    RadioButtons(selected: $viewModel.selectedType, show: $viewModel.showFilter, callFetchPokemons: viewModel.fetchAPITypeResponse)
                        .offset(y: viewModel.showFilter ? ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last?.safeAreaInsets.bottom ?? 0 ) + 15
                                : UIScreen.main.bounds.height)
                }
                .background(Color(UIColor.label.withAlphaComponent(viewModel.showFilter ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            }.alert(LocalizableString.unexpectedErrorMessage.value, isPresented: $viewModel.showUnexpectedErrorAlert) {
                Button(LocalizableString.continueButton.value, role: .cancel) { }
            }
            .navigationTitle(Text(viewModel.mainTitle.capitalized))
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.showFilter.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title)
                }
                Spacer().searchable(text: $viewModel.searchText)
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default)
            .onChange(of: networkMonitor.isConnected) { connection in
                showNetworkAlert = connection == false
            }
            .alert(LocalizableString.networkConnectionMessage.value, isPresented: $showNetworkAlert) {}
        }
        .onAppear {
            viewModel.fetchPokemons(isFilter: false)
        }
    }

    private var mainTitle: some View {
        Text(viewModel.mainTitle.capitalized)
            .font(.title)
    }

    private var mainDescription: some View {
        Text(viewModel.mainDescription)
            .font(.body).fontWeight(.light)
    }

    private var filteredPokemon: [RowDetail] {
        return viewModel.searchText.isEmpty
            ? viewModel.pokemonList
            : viewModel.pokemonList.filter { $0.name.lowercased().contains(viewModel.searchText.lowercased()) }
        }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(viewModel: MockPokedexViewModel(
            pokemonAPIService: PokemonLoadingAPIService(cache: PokemonCache.shared,
                                                        apiService: PokemonAPI()))
        )
    }
}

