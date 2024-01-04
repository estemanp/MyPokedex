//
//  TypeTag.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import SwiftUI

struct TypeTag: View {
    var type: RowDetail
    var isCell: Bool

    private var iconSize: CGFloat {
        return isCell ? 20 : 40
    }

    private var fontSize: CGFloat {
        return isCell ? 12 : 18
    }


    var body: some View {
        HStack(spacing: 4) {
            Image(type.name)
                .resizable()
                .frame(width: iconSize, height: iconSize)
            Text(type.name.capitalized)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .font(.system(size: fontSize, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .padding(.leading, 1)
            .padding(.trailing, 8)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.15))
            )
    }
}
