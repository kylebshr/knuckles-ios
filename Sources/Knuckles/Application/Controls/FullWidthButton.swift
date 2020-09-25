//
//  FullWidthButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class FullWidthButton: Control {

    var onTap: (() -> Void)?

    var text: String = "" {
        didSet { label.text = text }
    }

    private let label = UILabel(font: .systemFont(ofSize: 18, weight: .medium), alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.setHuggingAndCompression(to: .required)
        label.textColor = .white
        label.pinEdges(to: safeAreaLayoutGuide, insets: .init(all: 24))
    }

    override func updateState() {
        backgroundColor = isEnabled ? .customBlue : UIColor.customBlue.withAlphaComponent(0.3)
        label.alpha = isHighlighted ? 0.3 : 1
    }

    override func touchUpInside() {
        onTap?()
    }
}
