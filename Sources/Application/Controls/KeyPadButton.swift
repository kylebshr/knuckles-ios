//
//  KeyPadButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class KeyPadButton: Control {

    let character: Character

    private let label = UILabel(font: .rubik(ofSize: 24, weight: .medium))

    init(character: Character) {
        self.character = character

        super.init(frame: .zero)

        addSubview(label)
        label.text = "\(character)"
        label.pinEdges(to: self, insets: .init(vertical: 18, horizontal: 0))
        label.textAlignment = .center
    }

    override func updateState() {
        label.alpha = isHighlighted ? 0.3 : 1
    }
}
