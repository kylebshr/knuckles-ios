//
//  NavigationView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class NavigationView: UIView {

    var text: String = "" {
        didSet { label.text = text }
    }

    private let label = UILabel(font: .rubik(ofSize: 32, weight: .bold))

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutMargins = .init(top: 30, left: 20, bottom: 15, right: 20)
        addSubview(label)
        label.setHuggingAndCompression(to: .required)
        label.numberOfLines = 0
        label.pinEdges([.left, .top, .bottom], to: layoutMarginsGuide)
        label.widthAnchor.pin(to: widthAnchor, multiplier: 0.6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
