//
//  ShapeView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/26/20.
//

import UIKit

class ShapeView: UIView {

    private let square = UIView()
    private let circle = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(square)
        addSubview(circle)

        circle.backgroundColor = .customLabel
        square.layer.borderWidth = 3

        circle.centerYAnchor.pin(to: centerYAnchor)
        circle.widthAnchor.pin(to: widthAnchor, multiplier: 0.8)
        circle.heightAnchor.pin(to: circle.widthAnchor)
        circle.leftAnchor.pin(to: leftAnchor, constant: -80)

        square.heightAnchor.pin(to: square.widthAnchor)
        square.widthAnchor.pin(to: widthAnchor, multiplier: 1.0 / 3)
        square.bottomAnchor.pin(to: circle.bottomAnchor, constant: 20)
        square.centerXAnchor.pin(to: centerXAnchor, constant: 20)

        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.circle.transform = .init(translationX: 0, y: 10)
        }, completion: nil)

        UIView.animate(withDuration: 2.5, delay: 0.5, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.square.transform = .init(translationX: 0, y: -5)
        }, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        square.layer.borderColor = UIColor.customLabel.cgColor
        circle.layer.cornerRadius = circle.bounds.midY
    }
}
