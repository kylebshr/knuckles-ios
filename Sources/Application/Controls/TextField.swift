//
//  TextField.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class TextField: UITextField {

    var insets: UIEdgeInsets = .init(all: 20) {
        didSet { setNeedsLayout() }
    }

    override var placeholder: String? {
        get { return super.placeholder }
        set { updatePlaceholder(with: newValue) }
    }

    private var placeholderColor: UIColor? {
        didSet { updatePlaceholder(with: placeholder) }
    }

    private let borderLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsFontForContentSizeCategory = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let origin = bounds.width - bounds.height
        return CGRect(x: origin, y: 0, width: bounds.height, height: bounds.height)
    }

    private func updatePlaceholder(with placeholder: String?) {
        guard let placeholderColor = placeholderColor else {
            super.placeholder = placeholder
            return
        }

        guard let placeholder = placeholder else {
            return
        }

        super.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: placeholderColor,
        ])
    }
}
