//
//  GradientView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/26/20.
//

import UIKit

class GradientView: UIView {

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else {
            fatalError("y no gradient")
        }

        return layer
    }

    var colors: [UIColor] = [] {
        didSet { update() }
    }

    func update() {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = .init(x: 0.42, y: 0.55)
        gradientLayer.endPoint = .init(x: 0.75, y: 1)
    }
}
