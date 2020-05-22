//
//  ProgressView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import UIKit

class ProgressView: UIView {

    var progress: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    private let fillView = UIView()

    override var intrinsicContentSize: CGSize {
        CGSize(width: 8, height: 26)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 2
        tintColor = .label
        clipsToBounds = true

        fillView.clipsToBounds = true
        addSubview(fillView)

        setHuggingAndCompression(to: .required)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        fillView.backgroundColor = tintColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        fillView.frame = bounds
        fillView.frame.size.height *= progress
        fillView.frame.origin.y = frame.height - fillView.frame.height

        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = bounds.midX
    }
}
