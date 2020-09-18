//
//  RetroView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import UIKit

class RetroView: UIView {

    let shadowView = UIView()
    let borderView = UIView()

    let offset: CGFloat

    var background: UIColor? {
        get { shadowView.backgroundColor }
        set { shadowView.backgroundColor = newValue }
    }

    var foreground: UIColor? {
        get { borderView.backgroundColor }
        set { borderView.backgroundColor = newValue }
    }

    init(content: UIView, borderWidth: CGFloat = 2, offset: CGFloat = 5) {
        self.offset = offset

        super.init(frame: .zero)

        addSubview(shadowView)
        shadowView.backgroundColor = .customBlue
        shadowView.layer.borderWidth = borderWidth
        shadowView.layer.cornerRadius = 10

        addSubview(borderView)
        borderView.backgroundColor = .customBackground
        borderView.layer.borderWidth = borderWidth
        borderView.layer.cornerRadius = 10

        borderView.addSubview(content)
        content.pinEdges(to: borderView, insets: .init(vertical: 8, horizontal: 12))

        shadowView.pinEdges(to: self, insets: .init(top: offset, left: offset, bottom: 0, right: 0))
        borderView.pinEdges(to: self, insets: .init(top: 0, left: 0, bottom: offset, right: offset))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        shadowView.layer.borderColor = UIColor.customLabel.cgColor
        borderView.layer.borderColor = UIColor.customLabel.cgColor
    }
}
