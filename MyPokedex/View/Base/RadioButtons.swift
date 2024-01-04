//
//  RadioButtons.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 28/11/23.
//

import SwiftUI

struct RadioButtons : View {
    @Binding var selected: String
    @Binding var show: Bool
    var callFetchPokemons: (() -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(LocalizableString.filterLabel.value)
                .font(.subheadline)
                .padding(.top, 8)
            ForEach(PokemonType.allCases, id: \.self) { pokemonType in
                Button(action: {
                    self.selected = pokemonType.rawValue
                }) {
                    HStack{
                        Text(pokemonType.rawValue.capitalized)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(self.selected == pokemonType.rawValue ? .cyan : .black)

                        Spacer()
                        ZStack {
                            Circle()
                                .fill(self.selected == pokemonType.rawValue ? Color.cyan : Color.black.opacity(0.5))
                                .frame(width: 10, height: 10)
                            if self.selected == pokemonType.rawValue {
                                Circle().stroke(Color.cyan, lineWidth: 4).frame(width: 15, height: 15 )
                            }
                        }
                    }.foregroundColor(.black)
                }.padding(.top, 8)
            }
            HStack{
                Spacer()
                Button(action: {
                    self.callFetchPokemons()
                    self.show.toggle()
                }) {
                    Text(LocalizableString.continueButton.value)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 25)
                        .foregroundColor(.white)
                }
                .background(
                    self.selected != "" ?
                    LinearGradient(gradient: .init(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.2), Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .disabled(self.selected != "" ? false : true)
            }.padding(.top, 8)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 25)
        .padding(.bottom, ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last?.safeAreaInsets.bottom ?? 0 ) + 15)
        .background(Color.white)
        .cornerRadius(25)
    }
}
