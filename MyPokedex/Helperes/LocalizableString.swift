//
//  LocalizableString.swift
//  MyPokedex
//
//  Created by Andres Perez Ramirez on 27/11/23.
//

import Foundation

enum LocalizableString {

    case abilitiesLabel
    case continueButton
    case filterLabel
    case mainDescription
    case mainTitle
    case movesLabel
    case networkConnectionMessage
    case searchPlaceHolder
    case unexpectedErrorMessage
    
}

extension LocalizableString {

    private var key: String {
        let key = String(describing: self).split(separator: "(", maxSplits: 1)[0]
        return String(key)
    }

    var value: String {
        let value: String = .localized(forKey: key)
        precondition(value != key, "No localized string found for '\(key)'")

        return value
    }
}

extension String {
    static func localized(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
