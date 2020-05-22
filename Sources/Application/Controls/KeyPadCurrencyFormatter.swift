//
//  KeyPadCurrencyFormatter.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import Foundation

class KeyPadCurrencyFormatter: KeyPadFormatter {

    private(set) var text: String = "$0"

    func appendCharacter(character: Character) {
        var currentText = text
        currentText.removeFirst()

        if character == "." {
            if currentText.contains(".") {
                return
            }
            if currentText == "0" {
                return
            }
        }

        if currentText.suffix(3).starts(with: ".") {
            return
        }

        if currentText == "0" {
            currentText = ""
        }

        if character != "." && !currentText.contains(".") && currentText.count >= 5 {
            return
        }

        currentText.append(character)
        text = "$\(currentText)"
    }

    func removeCharacter() {
        var currentText = text
        currentText.removeFirst()
        currentText.removeLast()

        if currentText.isEmpty {
            currentText = "0"
        }

        text = "$\(currentText)"
    }
}
