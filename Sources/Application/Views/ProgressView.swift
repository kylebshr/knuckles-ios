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
        CGSize(width: UIView.noIntrinsicMetric, height: 8)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondarySystemFill
        clipsToBounds = true

        fillView.clipsToBounds = true
        addSubview(fillView)
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
        fillView.frame.size.width *= progress

        fillView.layer.cornerRadius = bounds.midY
        layer.cornerRadius = bounds.midY
    }
}
