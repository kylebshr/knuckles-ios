//
//  PageControl.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class PageControl: Control {

    private let height: CGFloat = 8
    private let space: CGFloat = 6
    private let extra: CGFloat = 44

    var numberOfPages = 0 {
        didSet { update() }
    }

    var page = 0 {
        didSet { setNeedsStateUpdate(animated: true) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setHuggingAndCompression(to: .required)
    }

    private func update() {
        subviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<numberOfPages {
            let view = ProgressView()
            view.backgroundColor = .systemFill
            addSubview(view)
        }

        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: (height + space) * CGFloat(numberOfPages) - space + extra, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for (index, dot) in subviews.enumerated() {
            var frame = CGRect(origin: .zero, size: .init(width: height, height: height))
            frame.origin.x += CGFloat(index) * (height + space)

            if index > page {
                frame.origin.x += CGFloat(extra)
            }

            if index == page {
                frame.origin.y += 1
                frame.size.height -= 2
                frame.size.width += CGFloat(extra)
                (dot as? ProgressView)?.progress = 0.3
            }

            dot.layer.cornerRadius = frame.midY
            dot.frame = frame
        }
    }

    override func setNeedsStateUpdate(animated: Bool) {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
