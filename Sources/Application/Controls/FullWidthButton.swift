//
//  FullWidthButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class FullWidthButton: Control {

    var text: String = "" {
        didSet { label.text = text }
    }

    private let label = UILabel(font: .rubik(ofSize: 18, weight: .medium), alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.textColor = .white
        label.pinEdges(to: safeAreaLayoutGuide, insets: .init(all: 24))
    }

    override func updateState() {
        backgroundColor = isEnabled ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
        label.alpha = isHighlighted ? 0.3 : 1
    }
}
