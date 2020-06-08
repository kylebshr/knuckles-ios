//
//  ShapeView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/26/20.
//

import UIKit

class ShapeView: UIView {

    private let squareBackground = UIView()
    private let square = UIView()

    private let circleBackground = UIView()
    private let circle = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(squareBackground)
        addSubview(square)

        addSubview(circleBackground)
        addSubview(circle)

        circle.layer.borderWidth = 3
        circle.backgroundColor = .systemBackground
        circleBackground.layer.borderWidth = 3
        circleBackground.backgroundColor = .customBlue

        square.layer.borderWidth = 3
        square.backgroundColor = .systemBackground
        squareBackground.layer.borderWidth = 3
        squareBackground.backgroundColor = .customPink

        circle.centerYAnchor.pin(to: centerYAnchor)
        circle.widthAnchor.pin(to: widthAnchor, multiplier: 0.8)
        circle.heightAnchor.pin(to: circle.widthAnchor)
        circle.leftAnchor.pin(to: leftAnchor, constant: -80)

        square.heightAnchor.pin(to: square.widthAnchor)
        square.widthAnchor.pin(to: widthAnchor, multiplier: 1.0 / 3)
        square.bottomAnchor.pin(to: circle.bottomAnchor, constant: 20)
        square.centerXAnchor.pin(to: centerXAnchor, constant: 20)

        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.circle.transform = .init(translationX: -3, y: 8)
        }, completion: nil)

        UIView.animate(withDuration: 2.5, delay: 0.5, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.square.transform = .init(translationX: -3, y: -3)
        }, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for view in [square, circle, circleBackground, squareBackground] {
            view.layer.borderColor = UIColor.label.cgColor
        }

        circle.layer.cornerRadius = circle.bounds.midY
        circleBackground.layer.cornerRadius = circle.bounds.midY

        circleBackground.frame = circle.frame.offsetBy(dx: 7, dy: 7)
        squareBackground.frame = square.frame.offsetBy(dx: 7, dy: 7)
    }
}
